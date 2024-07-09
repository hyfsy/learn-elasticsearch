package com.hyf.elasticsearch.controller;

import com.hyf.elasticsearch.pojo.User;
import com.hyf.elasticsearch.service.UserESService;
import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.elasticsearch.core.ElasticsearchRestTemplate;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.data.elasticsearch.core.query.NativeSearchQuery;
import org.springframework.data.elasticsearch.core.query.NativeSearchQueryBuilder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

/**
 * @author baB_hyf
 * @date 2022/04/04
 */
@RestController
public class UserController {

    private final AtomicInteger             i = new AtomicInteger(0);
    @Resource
    private       ElasticsearchRestTemplate elasticsearchRestTemplate;
    @Resource
    private       UserESService             userESService;

    @RequestMapping("find/{id}")
    public User list(@PathVariable Integer id) {
        return userESService.findById(id).orElse(new User());
    }

    @RequestMapping("list")
    public List<User> list() {
        PageRequest request = PageRequest.of(0, 10, Sort.Direction.ASC, "id");
        Page<User> page = userESService.findAll(request);
        return page.getContent();
    }

    @RequestMapping("list/{name}")
    public List<User> list(@PathVariable String name) {
        return userESService.findByName(name);
    }

    @RequestMapping("create/{name}")
    public void create(@PathVariable String name) {
        User user = new User();
        user.setId(i.incrementAndGet());
        user.setName(name);
        user.setAge(111);
        user.setSalary(111d);
        try {
            userESService.save(user);
        } catch (NullPointerException ignored) {
        }
    }

    @RequestMapping("highlight/{idOrName}")
    public List<User> highlight(@PathVariable String idOrName) {

        QueryBuilder queryBuilder = QueryBuilders.boolQuery()
                .should(QueryBuilders.matchQuery("id", idOrName))
                .should(QueryBuilders.matchQuery("name", idOrName));

        NativeSearchQuery searchQuery = new NativeSearchQueryBuilder()
                .withQuery(queryBuilder)
                .withHighlightBuilder(new HighlightBuilder().preTags("<font style='color:red'>").postTags("</font>"))
                .withHighlightFields(new HighlightBuilder.Field("name"))
                .build();

        SearchHits<User> userSearchHits = elasticsearchRestTemplate.search(searchQuery, User.class);

        return userSearchHits.getSearchHits().stream().map(userSearchHit -> {
            User user = userSearchHit.getContent();
            Map<String, List<String>> highlightFields = userSearchHit.getHighlightFields();
            Optional.ofNullable(highlightFields.get("name"))
                    .ifPresent(names -> user.setName(names.get(0)));
            return user;
        }).collect(Collectors.toList());
    }
}
