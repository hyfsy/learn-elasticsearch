package com.hyf.elasticsearch;

import co.elastic.clients.elasticsearch.transform.Settings;
import com.alibaba.druid.pool.ElasticSearchDruidDataSourceFactory;
import org.elasticsearch.plugin.nlpcn.QueryActionElasticExecutor;
import org.junit.Test;
import org.nlpcn.es4sql.SearchDao;
import org.nlpcn.es4sql.jdbc.ObjectResult;
import org.nlpcn.es4sql.jdbc.ObjectResultsExtractor;
import org.nlpcn.es4sql.query.QueryAction;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.Properties;

/**
 * @author baB_hyf
 * @date 2022/04/05
 */
public class SQLPluginTests {

    @Test
    public void testUseDruid() throws Exception {
        Properties properties = new Properties();
        properties.put("url", "jdbc:elasticsearch://localhost:9300,localhost:9300");
        DataSource dataSource = ElasticSearchDruidDataSourceFactory.createDataSource(properties);

        Connection conn = dataSource.getConnection();
        PreparedStatement ps = conn.prepareStatement("select id, name from user where id = ?");
        ps.setString(1, "1"); // 执行前会将参数拼到sql上
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            System.out.println(rs.getString("id") + " -> " + rs.getString("name"));
        }
    }

    // @Test
    // public void testUseOrigin() throws Exception {
    //     Settings settings = Settings.of(s -> s);
    //     NodeClient nodeClient = new NodeClient(settings, null);
    //     SearchDao searchDao = new SearchDao(nodeClient);
    //     // 1.解释SQL
    //     // 不支持传参的形式
    //     QueryAction queryAction = searchDao.explain("select id, name from user where id = 1");
    //     // 2.执行
    //     Object executeResult = QueryActionElasticExecutor.executeAnyAction(searchDao.getClient(), queryAction);
    //     // 3.格式化查询结果
    //     ObjectResult objectResult = new ObjectResultsExtractor(false, false, true, false, queryAction)
    //             .extractResults(executeResult, true);
    //
    //     List<String> headers = objectResult.getHeaders();
    //     List<List<Object>> lines = objectResult.getLines();
    // }
}
