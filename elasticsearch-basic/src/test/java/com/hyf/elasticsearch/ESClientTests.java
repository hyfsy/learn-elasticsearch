package com.hyf.elasticsearch;

import co.elastic.clients.elasticsearch.ElasticsearchAsyncClient;
import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.elasticsearch.core.IndexResponse;
import co.elastic.clients.elasticsearch.core.SearchResponse;
import co.elastic.clients.elasticsearch.core.search.HighlightField;
import co.elastic.clients.elasticsearch.core.search.Hit;
import co.elastic.clients.elasticsearch.indices.CreateIndexRequest;
import co.elastic.clients.elasticsearch.indices.CreateIndexResponse;
import co.elastic.clients.elasticsearch.indices.PutMappingResponse;
import com.hyf.elasticsearch.client.ESClient;
import com.hyf.elasticsearch.pojo.Hello;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.io.IOException;
import java.io.StringReader;
import java.util.List;
import java.util.Map;

/**
 * @author baB_hyf
 * @date 2022/04/03
 */
public class ESClientTests {

    private ElasticsearchClient client;

    @Test
    public void testCreateIndex() throws IOException {
        CreateIndexResponse response = client.indices().create(c -> c.index("hello-es"));
        System.out.println(response.index());
    }

    @Test
    public void testCreateMapping() throws IOException {
        PutMappingResponse response = client.indices().putMapping(m -> m
                .index("hello-es")
                .properties("id", p -> p.keyword(k -> k))
                .properties("name", p -> p.text(t -> t)));
        System.out.println(response.acknowledged());
    }

    @Test
    public void testCreateDocument() throws IOException {
        Hello hello = new Hello(1, "张三");
        IndexResponse response = client.index(i -> i
                .index("hello-es")
                .id(String.valueOf(hello.getId()))
                // .withJson(new StringReader("{\"id\":\"1\", \"name\":\"张三\"}"))
                .document(hello));
        System.out.println(response.result().jsonValue());
        System.out.println(response.version());
    }

    @Test
    public void testSearch() throws IOException {
        SearchResponse<Hello> response = client.search(i -> i.index("hello-es")
                        .query(q -> q.term(t -> t.field("name")
                                .value(v -> v.stringValue("张"))))
                        .highlight(h -> h.preTags("<font style='color:red'>").postTags("</font>")
                                .fields("name", HighlightField.of(f -> f))),
                Hello.class);

        for (Hit<Hello> hit : response.hits().hits()) {
            Hello hello = hit.source();
            System.out.println(hello);
            Map<String, List<String>> highlight = hit.highlight();
            for (String name : highlight.get("name")) {
                System.out.println(name);
            }
        }
    }

    @Test
    public void testSearchList() throws IOException {
        SearchResponse<Hello> response = client.search(i -> i.index("test_idx"), Hello.class);
        for (Hit<Hello> hit : response.hits().hits()) {
            Hello hello = hit.source();
            System.out.println(hello);
        }
    }

    @Test
    public void testAsync() {
        ElasticsearchAsyncClient asyncClient = ESClient.async();
        CreateIndexRequest.Builder builder = new CreateIndexRequest.Builder();
        builder.index("hello-test-async");
        asyncClient.indices().create(builder.build())
                .exceptionally(t -> {
                    // if (t instanceof ElasticsearchException) {
                    //     return ((ElasticsearchException)t).response();
                    // }
                    // if (t instanceof TransportException) {
                    //     ResponseException ex = (ResponseException) t.getCause();
                    //     return ex.getResponse();
                    // }

                    return null;
                })
                .thenAccept(response -> {
                    System.out.println(response.index());
                });
    }

    @Before
    public void init() {
        client = ESClient.get();
    }

    @After
    public void destroy() {
        client.shutdown();
    }
}
