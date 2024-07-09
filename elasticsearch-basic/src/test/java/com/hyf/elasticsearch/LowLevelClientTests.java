package com.hyf.elasticsearch;

import com.hyf.elasticsearch.client.LowLevelClient;
import org.apache.http.Header;
import org.apache.http.HttpHost;
import org.apache.http.RequestLine;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.util.EntityUtils;
import org.elasticsearch.client.*;
import org.elasticsearch.client.sniff.ElasticsearchNodesSniffer;
import org.elasticsearch.client.sniff.NodesSniffer;
import org.elasticsearch.client.sniff.SniffOnFailureListener;
import org.elasticsearch.client.sniff.Sniffer;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.CancellationException;

/**
 * @author baB_hyf
 * @date 2022/04/03
 */
public class LowLevelClientTests {

    private RestClient client;

    @Test
    public void testSync() throws IOException {
        Request request = new Request("post", "/");
        // 请求参数与请求体
        request.addParameter("pretty", "true");
        // request.setEntity(new NStringEntity("{\"json\":\"text\"}", ContentType.APPLICATION_JSON));
        request.setJsonEntity("{\"json\":\"text\"}");

        // 请求选项
        RequestOptions.Builder builder = RequestOptions.DEFAULT.toBuilder();
        builder.addHeader("Authentication", "Bearer " + "TOKEN");
        // 响应消费者
        builder.setHttpAsyncResponseConsumerFactory(new HttpAsyncResponseConsumerFactory.HeapBufferedResponseConsumerFactory(2 << 14));
        builder.setRequestConfig(RequestConfig.custom().setConnectTimeout(3000).build()); // 单请求配置
        RequestOptions options = builder.build();
        request.setOptions(options);

        Response response = client.performRequest(request);

        // 响应获取信息
        RequestLine requestLine = response.getRequestLine();
        HttpHost host = response.getHost();
        int statusCode = response.getStatusLine().getStatusCode();
        Header[] headers = response.getHeaders();
        String responseBody = EntityUtils.toString(response.getEntity());


        System.out.println(response);
    }

    @Test
    public void testAsync() {
        Cancellable cancellable = client.performRequestAsync(new Request("get", "/"), new ResponseListener() {
            @Override
            public void onSuccess(Response response) {
                System.out.println(response);
            }

            @Override
            public void onFailure(Exception e) {
                if (e instanceof CancellationException) {
                    System.out.println("request has been canceled");
                }
                if (e instanceof IOException) {
                    System.out.println("socket error");
                }
                if (e instanceof ResponseException) {
                    Response response = ((ResponseException) e).getResponse();
                    System.out.println("code: " + response.getStatusLine().getStatusCode());
                }
                e.printStackTrace();
            }
        });

        // 取消正在进行的请求
        cancellable.cancel();
    }

    @Test
    public void testSniffer() throws IOException {

        // 定期从es集群中获取并设置节点列表
        // client.setNodes();

        RestClient restClient = RestClient.builder(new HttpHost("localhost", 9200, "http"))
                .setFailureListener(new SniffOnFailureListener()) // 每次失败都更新
                .build();

        // 核心嗅探器
        ElasticsearchNodesSniffer elasticsearchNodesSniffer = new ElasticsearchNodesSniffer(
                restClient,
                ElasticsearchNodesSniffer.DEFAULT_SNIFF_REQUEST_TIMEOUT, // 1s
                // 嗅探只返回ip/port，不返回schema，默认http，如果节点不是http，则需要在此处指定
                ElasticsearchNodesSniffer.Scheme.HTTPS
        );

        Sniffer sniffer = Sniffer.builder(restClient)
                .setSniffIntervalMillis(60_000) // 每1m刷新一次
                .setSniffAfterFailureDelayMillis(30_000) // 故障后如果30s还未恢复则进行刷新
                .setNodesSniffer(elasticsearchNodesSniffer)
                // 外部获取数据源
                .setNodesSniffer(new NodesSniffer() {

                    @Override
                    public List<Node> sniff() throws IOException {
                        return elasticsearchNodesSniffer.sniff();
                    }
                })
                .build();

        sniffer.close(); // 比client先关闭
        restClient.close();
    }

    @Before
    public void init() {
        client = LowLevelClient.get();
    }

    @After
    public void destroy() {
        LowLevelClient.close();
    }
}
