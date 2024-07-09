package com.hyf.elasticsearch.client;

import co.elastic.clients.elasticsearch.ElasticsearchAsyncClient;
import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.json.jackson.JacksonJsonpMapper;
import co.elastic.clients.transport.rest_client.RestClientTransport;
import org.elasticsearch.client.RestClient;

/**
 * @author baB_hyf
 * @date 2022/04/03
 */
public class ESClient {

    // 基于三大组件：
    // API客户端
    // 对象映射器
    // 传输层实现

    private static RestClientTransport transport = init();

    private static RestClientTransport init() {
        // low-level client
        RestClient client = LowLevelClient.get();
        JacksonJsonpMapper mapper = new JacksonJsonpMapper();
        return new RestClientTransport(client, mapper);
    }

    public static ElasticsearchClient get() {
        return new ElasticsearchClient(transport);
    }

    public static ElasticsearchAsyncClient async() {
        return new ElasticsearchAsyncClient(transport);
    }
}
