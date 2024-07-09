package com.hyf.elasticsearch.service;

import com.hyf.elasticsearch.pojo.User;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

import java.util.List;

/**
 * @author baB_hyf
 * @date 2022/04/04
 */
public interface UserESService extends ElasticsearchRepository<User, Integer> {

    List<User> findByName(String name);

}
