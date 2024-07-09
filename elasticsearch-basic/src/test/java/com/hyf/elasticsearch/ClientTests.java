package com.hyf.elasticsearch;

import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.json.jackson.JacksonJsonpMapper;
import co.elastic.clients.transport.rest_client.RestClientTransport;
import org.apache.http.HttpHost;
import org.elasticsearch.client.RestClient;
import org.junit.Test;

/**
 * @author baB_hyf
 * @date 2022/04/04
 */
public class ClientTests {

    @Test
    public void testUse() {
        // low-level client
        RestClient restClient = RestClient.builder(new HttpHost("localhost", 9200)).build();
        // mapper
        JacksonJsonpMapper mapper = new JacksonJsonpMapper();
        // transport
        RestClientTransport transport = new RestClientTransport(restClient, mapper);
        // high-level client
        ElasticsearchClient client = new ElasticsearchClient(transport);

        // close
        client.shutdown();
    }
}
