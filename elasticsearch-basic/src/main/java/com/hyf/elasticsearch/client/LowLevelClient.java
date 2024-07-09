package com.hyf.elasticsearch.client;

import org.apache.http.Header;
import org.apache.http.HttpHost;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.impl.nio.client.HttpAsyncClientBuilder;
import org.apache.http.impl.nio.reactor.IOReactorConfig;
import org.apache.http.message.BasicHeader;
import org.elasticsearch.client.Node;
import org.elasticsearch.client.NodeSelector;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestClientBuilder;
import org.elasticsearch.client.sniff.Sniffer;

import java.io.IOException;

/**
 * @author baB_hyf
 * @date 2022/04/03
 */
public class LowLevelClient {

    public static final String HOST   = "localhost";
    public static final int    PORT   = 9200;
    public static final String SCHEMA = "http";

    private static RestClient INSTANCE = init();

    private static RestClient init() {

        // 构建器
        RestClientBuilder builder = RestClient.builder(new HttpHost(HOST, PORT, SCHEMA)
                // , new HttpHost("localhost", 9201)
        );

        // 默认添加的请求头
        Header[] defaultHeaders = {new BasicHeader("header", "value")};
        builder.setDefaultHeaders(defaultHeaders);

        // 设置失败监听器
        builder.setFailureListener(new RestClient.FailureListener() {
            @Override
            public void onFailure(Node node) {
                System.out.println("node: " + node);
            }
        });

        // 设置默认的请求配置
        builder.setRequestConfigCallback(new RestClientBuilder.RequestConfigCallback() {
            @Override
            public RequestConfig.Builder customizeRequestConfig(RequestConfig.Builder builder) {
                builder.setConnectTimeout(3000);
                builder.setSocketTimeout(30_000);
                return builder;
            }
        });

        // 设置默认的客户端配置
        builder.setHttpClientConfigCallback(new RestClientBuilder.HttpClientConfigCallback() {
            @Override
            public HttpAsyncClientBuilder customizeHttpClient(HttpAsyncClientBuilder httpAsyncClientBuilder) {
                // httpAsyncClientBuilder.setProxy(new HttpHost("localhost", 9200, "http"));

                // reactor 配置
                httpAsyncClientBuilder.setDefaultIOReactorConfig(
                        IOReactorConfig.custom().setIoThreadCount(1).build());

                // 认证配置
                // CredentialsProvider credentialsProvider = new BasicCredentialsProvider();
                // credentialsProvider.setCredentials(AuthScope.ANY, new UsernamePasswordCredentials("user", "test-user-password"));
                // httpAsyncClientBuilder.setDefaultCredentialsProvider(credentialsProvider);
                // httpAsyncClientBuilder.disableAuthCaching();

                // ssl
                // https://www.elastic.co/guide/en/elasticsearch/client/java-api-client/current/_encrypted_communication.html
                // httpAsyncClientBuilder.setSSLContext(null);


                return httpAsyncClientBuilder;
            }
        });


        // 默认情况下，客户端向每个配置的节点发送请求，可控制防止向专用主节点发送请求，用于嗅探
        // https://www.elastic.co/guide/en/elasticsearch/client/java-api-client/current/_node_selector.html
        builder.setNodeSelector(NodeSelector.SKIP_DEDICATED_MASTERS);

        return builder.build();
    }

    public static RestClient get() {
        return INSTANCE;
    }

    public static void close() {
        try {
            INSTANCE.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
