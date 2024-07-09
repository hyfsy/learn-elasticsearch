package com.hyf.elasticsearch.config;

import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.elasticsearch.client.ClientConfiguration;
import org.springframework.data.elasticsearch.client.RestClients;

import java.net.InetSocketAddress;

/**
 * @author baB_hyf
 * @date 2022/04/04
 */
@Configuration
public class ESConfiguration {

    public static final String HOST = "localhost";
    public static final int    PORT = 9200;

    @Bean
    public RestHighLevelClient elasticsearchClient() {
        return RestClients.create(
                ClientConfiguration.create(new InetSocketAddress(HOST, PORT))).rest();
    }
}
