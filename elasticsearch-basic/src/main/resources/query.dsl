
GET _search
{
  "query": {
    "match_all": {}
  }
}

GET /_cat/indices

GET /

PUT test-canal

get test_canal

PUT test_canal
{
  "mappings": {
      "properties": {
        "id":{
          "type":"keyword"
        },
        "name":{
          "type":"text"
        }
      }
  }
}


GET /test_canal/_doc/105
PUT /test_canal/_doc/105?if_seq_no=169&if_primary_term=199
{
  "name":"ls"
}
POST /test_canal/_doc/105
{
  "name":"zs"
}


GET /test_canal/_search
{
  "query":{
    "match_all": {}
  }
}
GET /test_canal/_search
{
  "query": {
    "match_phrase": {
      "_name": "s"
    }
  }
}


get /_cat/indices?v


PUT /hello-es

get /_nodes/

GET /test_ik

PUT /test_ik
{
  "mappings": {
    "properties": {
      "id":{
        "type": "keyword"
      },
      "name":{
        "type": "text",
        "analyzer": "ik_max_word",
        "search_analyzer": "ik_max_word"
      }
    }
  }
}

POST /test_ik/_doc/2
{
  "id":2,
  "name":"李四2"
}


GET /test_ik/_doc/1

GET /test_ik/_search

GET /test_ik/_search
{
  "query": {
    "match": {
      "name": "张三"
    }
  },
  "from": 10,
  "size": 20,
  "sort": [
    {
      "name": {
        "order": "desc"
      }
    }
  ]
}

GET /test_ik/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "_id": "1"
          }
        },
        {
          "match": {
            "name": "张三"
          }
        }
      ]
    }
  }
}



PUT /test_ik_type_test
{
  "mappings": {
    "ddd": {
      "properties": {
        "id": {
          "type": "keyword"
        },
        "name": {
          "type": "text",
          "analyzer": "ik_max_word",
          "search_analyzer": "ik_max_word"
        }
      }
    }
  }
}

PUT /test_ha
{
  "settings": {
    "number_of_replicas": 2,
    "number_of_shards": 3
  }
}

get /test_alias

PUT /test_alias
{
  "aliases": {
    "test_alias_1": {}
  }
}

POST /_aliases
{
  "actions": [
    {
      "remove": {
        "index": "test_alias",
        "alias": "test_alias_1"
      }
    },
    {
      "add": {
        "index": "test_alias",
        "alias": "test_alias_2"
      }
    }
  ]
}

PUT /test_idx
GET /test_idx/_mapping
GET /test_idx/_settings
HEAD /test_idx1
PUT /test_idx
{
  "settings": {
    "refresh_interval": "1s",
    "blocks.read": true,
    "blocks.write": true,
    "blocks.read_only": true,
    "blocks.metadata": true
  }
}

PUT /_template/test_template
{
  "index_patterns": ["test_template_*", "template_*"],
  "settings": {
    "refresh_interval": "1s"
  },
  "mappings": {
    "properties": {
      "id":{
        "type": "keyword"
      },
      "create_time":{
        "type": "date",
        "format": ["EEE MMM dd HH:mm:ss Z YYYY"]
      }
    }
  }
}

GET /_template
GET /_template/test_template

GET /test_idx
POST /test_idx/_close
POST /test_idx/_open


PUT /test_target_index
{
  "settings": {
    "number_of_replicas": 4
  }
}

GET /

PUT /test_source_index
PUT /test_target_index

PUT /test_source_index
{
  "settings": {
    "blocks.write": true,
    "routing": {
      "allocation": {
        "require": {
          "tag": "shrink_node_name"
        }
      }
    }
  }
}

PUT /test_source_index/_shrink
{
  "settings": {}
}

GET /_cat/recovery?v
GET /_cat/health


PUT /test_split_index
{
  "settings": {
  }
}

PUT /test_rollover_index-000001
{
  "aliases": {
    "2test_rollover_index": {}
  }
}

POST /2test_rollover_index/_rollover
{
  "conditions": {
    "max_docs": 1
  }
}

GET /2test_rollover_index/_search
POST /2test_rollover_index/_doc
{
  "id":"111"
}

PUT /test-rollover-index-001
{
  "aliases": {
    "test-rollover-index": {}
  }
}

POST /test-rollover-index/_rollover
{
  "conditions": {
    "max_docs": 1
  }
}

POST /test-rollover-index/_rollover?dry_run
{
  "conditions": {
    "max_docs": 1
  }
}

GET /test-rollover-index/_search
POST /test-rollover-index/_doc
{
  "name":"zs"
}

GET /test_idx/_stats
GET /_segments
GET /test_idx/_segments
GET /test_idx/_recovery
GET /_recovery
GET /test_idx/_shard_stores
GET /_shard_stores
POST /test_idx/_cache/clear
POST /test_idx/_refresh
POST /test_idx/_flush
POST /test_idx/_forcemerge?only_expunge_deletes=false&max_num_segments=100&flush=true

GET /test_idx/_mapping

PUT /test_mappings
{
  "mappings": {
    "properties": {
      "id": {
        "type": "keyword"
      },
      "name": {
        "type": "text"
      },
      "create_time": {
        "type": "date",
        "format": [
          "yyyy-MM-dd HH:mm:ss",
          "yyyy-MM-dd",
          "epoch_millis"
        ]
      }
    }
  }
}

GET /test_mappings
PUT /test_mappings_reindex
GET /test_mappings_reindex
POST /_reindex
{
  "source": {
    "index": "test_mappings"
  },
  "dest": {
    "index": "test_mappings_reindex"
  }
}

PUT /test_mappings_multifield
{
  "mappings": {
    "properties": {
      "id":{
        "type": "text",
        "fields": {
          "nest_id":{
            "type":"keyword"
          }
        }
      }
    }
  }
}

GET /test_mappings_multifield/_doc/1
POST /test_mappings_multifield/_doc/1
{
  "id":"New York"
}
POST /test_mappings_multifield/_doc/2
{
  "id":"ZNew York"
}
GET /test_mappings_multifield/_search
{
  "query":{
    "match":{
      "id":"york"
    }
  },
  "sort": [
    {
      "id.nest_id": {
        "order": "desc"
      }
    }
  ],
  "aggs": {
    "IDS": {
      "terms": {
        "field": "id.nest_id",
        "size": 10
      }
    }
  }
}

GET /test_dynamic_date_type/_stats
PUT /test_dynamic_date_type
{
  "mappings": {
    "date_detection": true,
    "dynamic_date_formats": ["MM/dd/yyyy"],
    "numeric_detection": true
  }
}


PUT /test_alias2
{
  "mappings": {
    "properties": {
      "id": {
        "type": "keyword"
      },
      "name": {
        "type": "text"
      }
    }
  },
  "aliases": {
    "test_alias2_1": {
      "filter": {
        "term": {
          "name": "hello"
        }
      },
      "routing": "1",
      "search_routing": "1,2",
      "index_routing": "1"
    }
  }
}
GET /test_alias2/_search
GET /test_alias2_1/_search
POST /test_alias2/_doc
{
  "id":"1",
  "name":"hei world"
}


PUT /test_alias3
{
  "aliases": {
    "test_alias3_1": {}
  }
}


GET /test_alias3
DELETE /test_alias3/_alias/test_alias3_1

GET /test_alias

POST /_aliases
{
  "actions": [
    {
      "add": {
        "index": "test_*",
        "alias": "test_alias_2"
      }
    }
  ]
}

POST /_aliases
{
  "actions": [
    {
      "add": {
        "indices": [
          "test_alias",
          "test_alias3"
        ],
        "alias": "test_alias_3"
      }
    }
  ]
}

GET /test_alias/_alias
GET /test_alias/_alias/test_alias_4
PUT /test_alias/_alias/test_alias_4
{
  "filter": {
    "term": {
      "name": "hello"
    }
  }
}

GET /_analyze
{
  "analyzer": "whitespace",
  "text": "hello world , 你好 世界"
}

GET /_analyze
{
  "tokenizer": "whitespace",
  "filter": ["lowercase", "asciifolding"],
  "text": "HELLO WORLD"
}

GET /_analyze
{
  "analyzer": "ik_max_word",
  "text":"这是你的马"
}

GET /_settings/test_idx/_analysis

GET /_analyze
{
  "tokenizer": "keyword",
  "char_filter": ["html_strip"],
  "text": ["<span class=\"strong strong\"><strong>You know, for search (and analysis)</strong></span>"]
}

PUT /test_analyze
{
  "settings": {
    "analysis": {
      "analyzer": {
        "my_analyzer": {
          "char_filter": ["my_char_filter"],
          "tokenizer": "keyword"
        }
      },
      "char_filter": {
        "my_char_filter": {
          "type": "html_strip",
          "escaped_tags": ["b"]
        }
      }
    }
  }
}

GET /test_analyze
GET /test_analyze/_analyze
{
  "analyzer": "my_analyzer",
  "text": ["<b><span>test</span></b>"]
}
GET /test_analyze/_analyze
{
  "char_filter": ["html_strip"],
  "text": ["<b>test</b>"]
}

PUT /test_analyze2
{
  "settings": {
    "analysis": {
      "analyzer": {
        "my_analyzer2": {
          "char_filter": ["my_char_filter2"],
          "tokenizer": "keyword"
        }
      },
      "char_filter": {
        "my_char_filter2": {
          "type": "mapping",
          "mappings": [
            "c => 2",
            "a => 0"
          ]
        }
      }
    }
  }
}

GET /test_analyze2/_analyze
{
  "analyzer": "my_analyzer2",
  "text": ["cacc"]
}

PUT /test_analyze3
{
  "settings": {
    "analysis": {
      "analyzer": {
        "my_analyzer3": {
          "char_filter": ["my_char_filter3"],
          "tokenizer": "standard"
        }
      },
      "char_filter": {
        "my_char_filter3": {
          "type": "pattern_replace",
          "pattern": "(\\d+)-(?=\\d)",
          "replacement": "$1_"
        }
      }
    }
  }
}

GET /test_analyze3/_analyze
{
  "analyzer": "my_analyzer3",
  "text": ["test 123-456-7890"]
}


GET /_analyze
{
  "tokenizer": "ik_smart",
  "text": ["你说的没毛病"]
}
GET /_analyze
{
  "tokenizer": "ik_max_word",
  "text": ["你说的没毛病"]
}

PUT /test_analyze4
{
  "settings": {
    "analysis": {
      "analyzer": {
        "my_analyzer4": {
          "tokenizer": "ik_smart",
          "filter": ["my_filter4"]
        }
      },
      "filter": {
        "my_filter4": {
          "type": "synonym",
          "synonyms_path": "analyzer/synonym.txt"
        }
      }
    }
  }
}

GET /test_analyze4/_analyze
{
  "analyzer": "my_analyzer4",
  "text": ["张三和李四一起出去玩", "买个电饭锅和电脑"]
}

PUT /test_analyze5
{
  "settings": {
    "analysis": {
      "analyzer": {
        "default": {
          "tokenizer": "ik_smart",
          "filter": ["my_filter5"]
        },
        "my_analyzer5": {
          "type":"custom",
          "char_filter":["html_strip"],
          "tokenizer": "ik_smart",
          "filter": ["my_filter5"]
        }
      },
      "filter": {
        "my_filter5": {
          "type": "synonym",
          "synonyms_path": "analyzer/synonym.txt"
        }
      }
    }
  }
}

GET /test_analyze5
PUT /test_analyze5/_mapping
{
  "properties": {
    "id": {
      "type": "keyword"
    },
    "name": {
      "type": "text",
      "analyzer": "my_analyzer5",
      "search_analyzer": "my_analyzer5"
    }
  }
}

POST /test_ik/_doc/11
{
  "id":"111",
  "name":"测试doc"
}

GET /test_ik/_doc/11
HEAD /test_ik/_doc/1
GET /test_ik/_doc/11?_source=false
GET /_mget
{
  "docs": [
    {
      "_index": "test_ik",
      "_id": "1"
    },
    {
      "_index": "test_ik",
      "_id": "11"
    }
  ]
}

GET /test_ik/_mget
{
  "docs": [
    {
      "_id": "1"
    },
    {
      "_id": "11"
    }
  ]
}

GET /test_ik/_mget
{
  "ids": ["1", "11"]
}

PUT /test_template2_doc
GET /test_template2_doc

PUT /_template/test_template2
{
  "index_patterns": [
    "test_template2*"
  ],
  "mappings": {
    "properties": {
      "create_time": {
        "format": [
          "EEE MMM dd HH:mm:ss Z YYYY"
        ],
        "type": "date"
      },
      "id": {
        "type": "keyword"
      },
      "name": {
        "type": "text"
      }
    }
  }
}

PUT /test_doc_store
{
  "mappings": {
    "properties": {
      "id": {
        "type": "keyword",
        "store": true
      },
      "name": {
        "type": "text",
        "store": false
      },
      "age": {
        "type": "integer"
      }
    }
  }
}

PUT /test_doc_store/_doc/1
{
  "id": "1",
  "name": "zs",
  "age": 18
}

GET /test_doc_store/_doc/1?stored_fields=id,name,age
GET /test_ik/_doc/1
DELETE /test_idx_del2/_doc/1?if_seq_no=0
GET /test_idx_del2/_doc/1
PUT /test_idx_del2/_doc/1
{
  "id":1
}

GET /test_ik/_search
POST /test_ik/_delete_by_query?conflicts=proceed
{
  "query": {
    "match": {
      "name": "张三"
    }
  }
}

PUT /test_ik/_doc/1?version=1
{
  "id":"111"
}

GET /_tasks?detailed=true&actions=*/delete/byquery

PUT /test_bulk2
{
  "mappings": {
    "properties": {
      "id":{
        "type": "keyword"
      },
      "name":{
        "type": "text"
      }
    }
  }
}

GET /test_bulk
GET /test_bulk/_search
GET /test_bulk/_search?q=*&sort=name: asc&from=1&size=10
POST /_bulk
{ "index":{ "_index":"test_bulk2", "_id":1 } }
{ "id":1, "name":"zs" }
{ "create":{ "_index":"test_bulk2", "_id":2 } }
{ "id":2, "name":"zs2" }
{ "update":{ "_index":"test_bulk2", "_id":2 } }
{ "name":"zs_update" }
{ "delete":{ "_index":"test_bulk2", "_id":1 } }


POST /test_bulk/_bulk
{ "index":{ "_id":1 } }
{ "id":1, "name":"zs" }
{ "index":{ "_id":2 } }
{ "id":2, "name":"zs" }
{ "index":{ "_id":3 } }
{ "id":3, "name":"zs" }

POST /_reindex
{
  "source": {
    "remote": {
      "host": "http://localhost:9200",
      "username": "admin",
      "password": "admin",
      "connect_timeout": "30s",
      "socket_timeout": "30s"
    },
    "index": [
      "test_idx",
      "test_idx3"
    ],
    "_source": {
      "excludes": [
        "value",
        "test*"
      ]
    },
    "term": {
      "match": {
        "name": "张三"
      }
    },
    "size": 1000,
    "sort": {
      "name": "desc"
    }
  },
  "dest": {
    "index": "test_idx2",
    "op_type": "create",
    "version_type": "external",
    "routing": "=test"
  },
  "conflicts": "proceed",
  "script": {
    "source": "if (ctx._source.foo == 'bar') {ctx._version++; ctx._source.remove('foo')}",
    "lang": "painless"
  }
}

GET /test_idx/_search
GET /test_idx2/_search

PUT /test_refresh
{
  "settings": {
  }
}

DELETE /test_cluster
PUT /test_cluster
{
  "mappings": {
    "_routing": {
      "required": true
    }
  }
}

PUT /test_cluster/_doc/1?routing=cat
{
  "id":"1",
  "name":"zs"
}

GET /test_idx

PUT /hello-es
{
  "mappings": {
    "properties": {
      "id": {
        "type": "keyword"
      },
      "name": {
        "type": "text"
      }
    }
  }
}

GET /hello-es/_search
PUT /hello-es/_doc/1
{
  "id": "1",
  "name": "张三"
}

GET /hello-es/_search
{
  "query": {
    "match": {
      "name": "张"
    }
  },
  "highlight": {
    "fields": {
      "id": {},
      "name": {}
    },
    "pre_tags": ["<font style='color:red'>"],
    "post_tags": ["</font>"]
  }
}



GET /hello-es/_search
{
  "highlight": {
    "fields": {
      "name": {
      }
    },
    "post_tags": [
      "</font>"
    ],
    "pre_tags": [
      "<font style='color:red'>"
    ]
  }
}

GET /test_idx/_search
GET /test_idx_temp/_search
POST /_reindex
{
  "source": {"index": "test_idx_temp"},
  "dest": {"index": "test_idx"}
}
PUT /test_idx
{
  "mappings": {
    "properties": {
      "id": {
        "type": "keyword"
      },
      "name": {
        "type": "text"
      }
    }
  }
}
GET /test_idx/_mapping
POST /test_idx/_mapping
{
  "properties": {
    "id": {
      "type": "keyword"
    }
  }
}
DELETE /test_idx/_doc/ZyQt8n8B5uf75sib8Pap
POST /test_idx/_delete_by_query
{
  "query":{
    "match":{
      "id":["ZSQt8n8B5uf75sib5_bo", "ZiQt8n8B5uf75sib7Pae", "ZyQt8n8B5uf75sib8Pap"]
    }
  }
}

GET /test_idx/_search
PUT /test_idx/_doc/2
{
  "id":2,
  "name":"hello, my name is zhangsan"
}

PUT /test_idx3
{
  "mappings": {
    "properties": {
      "id": {
        "type": "keyword"
      },
      "name": {
        "type": "text"
      },
      "age": {
        "type": "integer"
      }
    }
  }
}

PUT /test_idx/_doc/11
{
  "id":11,

"name":"测试doc"
}

PUT /test_idx3/_bulk
{"index":{"_id":1}}
{"id":1,"name":"zs1","age":1}
{"index":{"_id":2}}
{"id":2,"name":"zs2","age":18}
{"index":{"_id":3}}
{"id":3,"name":"zs3","age":13}
{"index":{"_id":4}}
{"id":4,"name":"zs4","age":31}
{"index":{"_id":5}}
{"id":5,"name":"zs5","age":11}

PUT /test_idx3/_mapping
{
  "properties": {
    "salary": {
      "type": "double"
    }
  }
}

GET /test_idx3/_search
{
  "aggs": {
    "ageTerms": {
      "terms": {
        "field": "age",
        "size": 10
      },
      "aggs": {
        "ageMin": {
          "min": {
            "field": "age"
          }
        }
      }
    },
    "ageAvg": {
      "avg": {
        "field": "age"
      }
    },
    "ageCount": {
      "value_count": {
        "field": "age"
      }
    }
  },
  "size": 0
}

GET /_cluster/health
GET /_cat/health?v
GET /user/_search
PUT /user/_doc/1

GET /hello-es/_search
{
  "query": {
    "match": {
      "name": "张"
    }
  },
  "highlight": {
    "fields": {
      "id": {},
      "name": {}
    },
    "pre_tags": ["<font style='color:red'>"],
    "post_tags": ["</font>"]
  }
}

GET /user/_search
{
  "from": 0,
  "size": 10000,
  "query": {
    "bool": {
      "should": [
        {
          "match": {
            "id": {
              "query": "aaa",
              "operator": "OR",
              "prefix_length": 0,
              "max_expansions": 50,
              "fuzzy_transpositions": true,
              "lenient": false,
              "zero_terms_query": "NONE",
              "auto_generate_synonyms_phrase_query": true,
              "boost": 1
            }
          }
        },
        {
          "match": {
            "name": {
              "query": "aaa",
              "operator": "OR",
              "prefix_length": 0,
              "max_expansions": 50,
              "fuzzy_transpositions": true,
              "lenient": false,
              "zero_terms_query": "NONE",
              "auto_generate_synonyms_phrase_query": true,
              "boost": 1
            }
          }
        }
      ],
      "adjust_pure_negative": true,
      "boost": 1
    }
  },
  "version": true,
  "explain": false,
  "highlight": {
    "pre_tags": [
      "<font style='color:red'>"
    ],
    "post_tags": [
      "</font>"
    ],
    "fields": {
      "name": {}
    }
  }
}

PUT /test_idx/_settings
{
  "translog.flush_threshold_ops": 5000,
  "translog.flush_threshold_period": "30m",
  "translog.flush_threshold_size": "200mb"

}

GET /user/_search?scroll=1m
{
  "query": {
    "match_all": {}
  },
  "sort": ["_doc"],
  "size": 2
}

GET /_search/scroll
{
  "scroll":"1m",
  "scroll_id":"FGluY2x1ZGVfY29udGV4dF91dWlkDXF1ZXJ5QW5kRmV0Y2gBFjZ1U21WZTl0Ui1XcFg0MEdxc2h0U3cAAAAAAAAjcRYteGpJd3hZTlFsT0NoU3QySXVWRHRn"
}

GET /_cat/indices?v

PUT /user/_settings
{
}

PUT /_all/_settings
{
}

GET /_cluster/settings

GET /user/_settings
GET /_cluster/health

GET /test_idx/_doc/2
PUT /test_idx/_doc/2?version=2&version_type=external
{
  "id": "2",
  "name":"hello, my name is lisi, not zhangsan"
}

PUT /user
{
  "mappings": {
    "properties": {
      "id":{
        "type": "text",
        "doc_values": false
      }
    }
  }
}

POST /user/_doc/1/_update
{
  "doc":{
    "name":"aaabbb"
  }
}


GET /user/_search
{
  "query":{
    "match": {
      "id": 1
    }
  }
}

PUT /test_idx/_doc/1?refresh=wait_for
{
  "id": 1,
  "name": "aaa"
}

POST /user/_update/1
{
  "doc": {
    "name": "bbb"
  }
}

PUT /user/_create/5
{
  "id":5,
  "name":"bbb"
}

GET /test_ik/_doc/11?_source


POST /test_ik/_update/99
{
  "doc": {
    "id": 99,
    "name": "99name"
  },
  "doc_as_upsert": true
}



GET /test_idx,test_idx2/_search
{
  "_source": false,
  "fields": [
    "id",
    "name"
  ]
}

GET /test_idx/_search
{
  "query": {
    "match": {
      "name": {
        "query": "你好，我是张三",
        "operator": "and"
      }
    }
  },
  "explain": true,
  "profile":true
}

PUT /test_idx/_doc/6
{
  "id":6,
  "name":"你好，我是张三"
}

GET /test_idx/_search
{
  "query": {
    "range": {
      "id": {
        "gte": 1,
        "lte": 20
      }
    },
    "exists": {
      "field": "name2"
    }
  }
}

GET /_sql
{
  "query": """
  SELECT * FROM test_idx where id > 1
  """
}

GET /_sql?sql=SELECT * FROM test_idx where id > 1

GET /_sql?format=txt
{
  "query":"desc test_idx"
}

GET /_sql?format=txt
{
  "query":"show functions"
}

GET /_sql/translate
{
  "query": "select * from test_idx where id > 1"
}

GET /test_idx/_field_caps?fields=id

PUT /test_idx/_mapping
{
  "properties":{
    "age":{
      "type":"integer"
    }
  }
}

PUT /test_idx/_bulk
{ "update":{ "_id": "2" } }
{ "doc": { "age": 2 } }
{ "update":{ "_id": "6" } }
{ "doc": { "age": 6 } }
{ "update":{ "_id": "1" } }
{ "doc": { "age": 1 } }
{ "update":{ "_id": "11" } }
{ "doc": { "age": 11 } }

GET /test_idx/_search
{
  "aggs": {
    "missingAggr": {
      "missing": {
        "field": "age1"
      }
    }
  }
}


POST /test_idx/_update/2
{
  "doc":{
    "id":2
  }
}

































































































































































