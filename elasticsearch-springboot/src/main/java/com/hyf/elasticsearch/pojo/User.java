package com.hyf.elasticsearch.pojo;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.*;

/**
 * @author baB_hyf
 * @date 2022/04/03
 */
@Document(indexName = "user",
        createIndex = true,
        versionType = Document.VersionType.EXTERNAL,
        writeTypeHint = WriteTypeHint.DEFAULT,
        dynamic = Dynamic.INHERIT)
public class User {

    @Id
    @Field(type = FieldType.Keyword)
    private Integer id;
    @Field(type = FieldType.Text, analyzer = "ik_smart", searchAnalyzer = "ik_max_word")
    private String  name;
    @Field(type = FieldType.Integer)
    private Integer age;
    @Field(type = FieldType.Double, index = false)
    private Double  salary;

    public User() {
    }

    public User(Integer id, String name, Integer age, Double salary) {
        this.id = id;
        this.name = name;
        this.age = age;
        this.salary = salary;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public Double getSalary() {
        return salary;
    }

    public void setSalary(Double salary) {
        this.salary = salary;
    }

    @Override
    public String toString() {
        return id + " -> " + name + " -> " + age + " -> " + salary;
    }
}
