Feature: correlation feature - timebased rule

  @concurrent
  Scenario: given meta alarm rule and events should create meta alarm
    Given I am admin
    When I do POST /api/v4/cat/metaalarmrules:
    """json
    {
      "name": "test-timebased-correlation-1",
      "type": "timebased",
      "config": {
        "time_interval": {
          "value": 10,
          "unit": "s"
        }
      },
      "alarm_pattern": [
        [
          {
            "field": "v.component",
            "cond": {
              "type": "eq",
              "value": "test-timebased-correlation-1"
            }
          }
        ]
      ]
    }
    """
    Then the response code should be 201
    Then I save response metaAlarmRuleID={{ .lastResponse._id }}
    When I wait the next periodical process
    When I send an event and wait the end of event processing:
    """json
    {
      "connector": "test-timebased-1",
      "connector_name": "test-timebased-1-name",
      "source_type": "resource",
      "event_type": "check",
      "component":  "test-timebased-correlation-1",
      "resource": "test-timebased-correlation-resource-1-1",
      "state": 2,
      "output": "test",
      "long_output": "test",
      "author": "test-author"
    }
    """
    When I send an event and wait the end of event processing:
    """json
    {
      "connector": "test-timebased-1",
      "connector_name": "test-timebased-1-name",
      "source_type": "resource",
      "event_type": "check",
      "component":  "test-timebased-correlation-1",
      "resource": "test-timebased-correlation-resource-1-2",
      "state": 2,
      "output": "test",
      "long_output": "test",
      "author": "test-author"
    }
    """
    When I do GET /api/v4/alarms?search=test-timebased-correlation-resource-1&correlation=true until response code is 200 and body contains:
    """json
    {
      "data": [
        {
          "is_meta_alarm": true,
          "children": 2,
          "meta_alarm_rule": {
            "name": "test-timebased-correlation-1"
          }
        }
      ],
      "meta": {
        "page": 1,
        "page_count": 1,
        "per_page": 10,
        "total_count": 1
      }
    }
    """
    When I do POST /api/v4/alarm-details:
    """json
    [
      {
        "_id": "{{ (index .lastResponse.data 0)._id }}",
        "children": {
          "page": 1,
          "sort_by": "v.resource",
          "sort": "asc"
        }
      }
    ]
    """
    Then the response code should be 207
    Then the response body should contain:
    """json
    [
      {
        "status": 200,
        "data": {
          "children": {
            "data": [
              {
                "v": {
                  "connector": "test-timebased-1",
                  "connector_name": "test-timebased-1-name",
                  "component":  "test-timebased-correlation-1",
                  "resource": "test-timebased-correlation-resource-1-1"
                }
              },
              {
                "v": {
                  "connector": "test-timebased-1",
                  "connector_name": "test-timebased-1-name",
                  "component":  "test-timebased-correlation-1",
                  "resource": "test-timebased-correlation-resource-1-2"
                }
              }
            ],
            "meta": {
              "page": 1,
              "page_count": 1,
              "per_page": 10,
              "total_count": 2
            }
          }
        }
      }
    ]
    """

  @concurrent
  Scenario: given meta alarm rule and events should create 2 meta alarms because of 2 separate time intervals
    Given I am admin
    When I do POST /api/v4/cat/metaalarmrules:
    """json
    {
      "name": "test-timebased-correlation-2",
      "type": "timebased",
      "config": {
        "time_interval": {
          "value": 3,
          "unit": "s"
        }
      },
      "alarm_pattern": [
        [
          {
            "field": "v.component",
            "cond": {
              "type": "eq",
              "value": "test-timebased-correlation-2"
            }
          }
        ]
      ]
    }
    """
    Then the response code should be 201
    Then I save response metaAlarmRuleID={{ .lastResponse._id }}
    When I wait the next periodical process
    When I send an event and wait the end of event processing:
    """json
    {
      "connector": "test-timebased-2",
      "connector_name": "test-timebased-2-name",
      "source_type": "resource",
      "event_type": "check",
      "component":  "test-timebased-correlation-2",
      "resource": "test-timebased-correlation-resource-2-1",
      "state": 2,
      "output": "test",
      "long_output": "test",
      "author": "test-author"
    }
    """
    When I send an event and wait the end of event processing:
    """json
    {
      "connector": "test-timebased-2",
      "connector_name": "test-timebased-2-name",
      "source_type": "resource",
      "event_type": "check",
      "component":  "test-timebased-correlation-2",
      "resource": "test-timebased-correlation-resource-2-2",
      "state": 2,
      "output": "test",
      "long_output": "test",
      "author": "test-author"
    }
    """
    When I do GET /api/v4/alarms?search=test-timebased-correlation-resource-2&correlation=true&sort_by=t&sort=desc until response code is 200 and body contains:
    """json
    {
      "data": [
        {
          "children": 2
        }
      ]
    }
    """
    When I wait 4s
    When I send an event and wait the end of event processing:
    """json
    {
      "connector": "test-timebased-2",
      "connector_name": "test-timebased-2-name",
      "source_type": "resource",
      "event_type": "check",
      "component":  "test-timebased-correlation-2",
      "resource": "test-timebased-correlation-resource-2-3",
      "state": 2,
      "output": "test",
      "long_output": "test",
      "author": "test-author"
    }
    """
    When I send an event and wait the end of event processing:
    """json
    {
      "connector": "test-timebased-2",
      "connector_name": "test-timebased-2-name",
      "source_type": "resource",
      "event_type": "check",
      "component":  "test-timebased-correlation-2",
      "resource": "test-timebased-correlation-resource-2-4",
      "state": 2,
      "output": "test",
      "long_output": "test",
      "author": "test-author"
    }
    """
    When I do GET /api/v4/alarms?search=test-timebased-correlation-resource-2&correlation=true&sort_by=t&sort=desc until response code is 200 and body contains:
    """json
    {
      "data": [
        {
          "children": 2
        },
        {
          "children": 2
        }
      ]
    }
    """
    When I send an event and wait the end of event processing:
    """json
    {
      "connector": "test-timebased-2",
      "connector_name": "test-timebased-2-name",
      "source_type": "resource",
      "event_type": "check",
      "component":  "test-timebased-correlation-2",
      "resource": "test-timebased-correlation-resource-2-5",
      "state": 2,
      "output": "test",
      "long_output": "test",
      "author": "test-author"
    }
    """
    When I do GET /api/v4/alarms?search=test-timebased-correlation-resource-2&correlation=true&sort_by=t&sort=desc until response code is 200 and body contains:
    """json
    {
      "data": [
        {
          "is_meta_alarm": true,
          "children": 3,
          "meta_alarm_rule": {
            "name": "test-timebased-correlation-2"
          }
        },
        {
          "is_meta_alarm": true,
          "children": 2,
          "meta_alarm_rule": {
            "name": "test-timebased-correlation-2"
          }
        }
      ],
      "meta": {
        "page": 1,
        "page_count": 1,
        "per_page": 10,
        "total_count": 2
      }
    }
    """
    When I do POST /api/v4/alarm-details:
    """json
    [
      {
        "_id": "{{ (index .lastResponse.data 0)._id }}",
        "children": {
          "page": 1,
          "sort_by": "v.resource",
          "sort": "asc"
        }
      },
      {
        "_id": "{{ (index .lastResponse.data 1)._id }}",
        "children": {
          "page": 1,
          "sort_by": "v.resource",
          "sort": "asc"
        }
      }
    ]
    """
    Then the response code should be 207
    Then the response body should contain:
    """json
    [
      {
        "status": 200,
        "data": {
          "children": {
            "data": [
              {
                "v": {
                  "connector": "test-timebased-2",
                  "connector_name": "test-timebased-2-name",
                  "component":  "test-timebased-correlation-2",
                  "resource": "test-timebased-correlation-resource-2-3"
                }
              },
              {
                "v": {
                  "connector": "test-timebased-2",
                  "connector_name": "test-timebased-2-name",
                  "component":  "test-timebased-correlation-2",
                  "resource": "test-timebased-correlation-resource-2-4"
                }
              },
              {
                "v": {
                  "connector": "test-timebased-2",
                  "connector_name": "test-timebased-2-name",
                  "component":  "test-timebased-correlation-2",
                  "resource": "test-timebased-correlation-resource-2-5"
                }
              }
            ],
            "meta": {
              "page": 1,
              "page_count": 1,
              "per_page": 10,
              "total_count": 3
            }
          }
        }
      },
      {
        "status": 200,
        "data": {
          "children": {
            "data": [
              {
                "v": {
                  "connector": "test-timebased-2",
                  "connector_name": "test-timebased-2-name",
                  "component":  "test-timebased-correlation-2",
                  "resource": "test-timebased-correlation-resource-2-1"
                }
              },
              {
                "v": {
                  "connector": "test-timebased-2",
                  "connector_name": "test-timebased-2-name",
                  "component":  "test-timebased-correlation-2",
                  "resource": "test-timebased-correlation-resource-2-2"
                }
              }
            ],
            "meta": {
              "page": 1,
              "page_count": 1,
              "per_page": 10,
              "total_count": 2
            }
          }
        }
      }
    ]
    """

  @concurrent
  Scenario: given meta alarm rule and events should create one single meta alarms because first group didn't reached default timebased threshold = 2 alarms
    Given I am admin
    When I do POST /api/v4/cat/metaalarmrules:
    """json
    {
      "name": "test-timebased-correlation-3",
      "type": "timebased",
      "config": {
        "time_interval": {
          "value": 3,
          "unit": "s"
        }
      },
      "alarm_pattern": [
        [
          {
            "field": "v.component",
            "cond": {
              "type": "eq",
              "value": "test-timebased-correlation-3"
            }
          }
        ]
      ]
    }
    """
    Then the response code should be 201
    Then I save response metaAlarmRuleID={{ .lastResponse._id }}
    When I wait the next periodical process
    When I send an event and wait the end of event processing:
    """json
    {
      "connector": "test-timebased-3",
      "connector_name": "test-timebased-3-name",
      "source_type": "resource",
      "event_type": "check",
      "component":  "test-timebased-correlation-3",
      "resource": "test-timebased-correlation-resource-3-1",
      "state": 2,
      "output": "test",
      "long_output": "test",
      "author": "test-author"
    }
    """
    When I wait 4s
    When I send an event and wait the end of event processing:
    """json
    {
      "connector": "test-timebased-3",
      "connector_name": "test-timebased-3-name",
      "source_type": "resource",
      "event_type": "check",
      "component":  "test-timebased-correlation-3",
      "resource": "test-timebased-correlation-resource-3-2",
      "state": 2,
      "output": "test",
      "long_output": "test",
      "author": "test-author"
    }
    """
    When I send an event and wait the end of event processing:
    """json
    {
      "connector": "test-timebased-3",
      "connector_name": "test-timebased-3-name",
      "source_type": "resource",
      "event_type": "check",
      "component":  "test-timebased-correlation-3",
      "resource": "test-timebased-correlation-resource-3-3",
      "state": 2,
      "output": "test",
      "long_output": "test",
      "author": "test-author"
    }
    """
    When I do GET /api/v4/alarms?search=test-timebased-correlation-resource-3&correlation=true&sort_by=v.meta&sort=desc until response code is 200 and body contains:
    """json
    {
      "data": [
        {
          "is_meta_alarm": true,
          "children": 2,
          "meta_alarm_rule": {
            "name": "test-timebased-correlation-3"
          }
        },
        {
          "is_meta_alarm": false,
          "v": {
            "connector": "test-timebased-3",
            "connector_name": "test-timebased-3-name",
            "component":  "test-timebased-correlation-3",
            "resource": "test-timebased-correlation-resource-3-1"
          }
        }
      ],
      "meta": {
        "page": 1,
        "page_count": 1,
        "per_page": 10,
        "total_count": 2
      }
    }
    """
    When I do POST /api/v4/alarm-details:
    """json
    [
      {
        "_id": "{{ (index .lastResponse.data 0)._id }}",
        "children": {
          "page": 1,
          "sort_by": "v.resource",
          "sort": "asc"
        }
      }
    ]
    """
    Then the response code should be 207
    Then the response body should contain:
    """json
    [
      {
        "status": 200,
        "data": {
          "children": {
            "data": [
              {
                "v": {
                  "connector": "test-timebased-3",
                  "connector_name": "test-timebased-3-name",
                  "component":  "test-timebased-correlation-3",
                  "resource": "test-timebased-correlation-resource-3-2"
                }
              },
              {
                "v": {
                  "connector": "test-timebased-3",
                  "connector_name": "test-timebased-3-name",
                  "component":  "test-timebased-correlation-3",
                  "resource": "test-timebased-correlation-resource-3-3"
                }
              }
            ],
            "meta": {
              "page": 1,
              "page_count": 1,
              "per_page": 10,
              "total_count": 2
            }
          }
        }
      }
    ]
    """

  @concurrent
  Scenario: given deleted meta alarm rule should delete meta alarm
    Given I am admin
    When I do POST /api/v4/cat/metaalarmrules:
    """json
    {
      "name": "test-timebased-correlation-4",
      "type": "timebased",
      "config": {
        "time_interval": {
          "value": 10,
          "unit": "s"
        }
      },
      "alarm_pattern": [
        [
          {
            "field": "v.component",
            "cond": {
              "type": "eq",
              "value": "test-timebased-correlation-4"
            }
          }
        ]
      ]
    }
    """
    Then the response code should be 201
    Then I save response metaAlarmRuleID={{ .lastResponse._id }}
    When I wait the next periodical process
    When I send an event and wait the end of event processing:
    """json
    {
      "connector": "test-timebased-4",
      "connector_name": "test-timebased-4-name",
      "source_type": "resource",
      "event_type": "check",
      "component":  "test-timebased-correlation-4",
      "resource": "test-timebased-correlation-resource-4-1",
      "state": 2
    }
    """
    When I send an event and wait the end of event processing:
    """json
    {
      "connector": "test-timebased-4",
      "connector_name": "test-timebased-4-name",
      "source_type": "resource",
      "event_type": "check",
      "component":  "test-timebased-correlation-4",
      "resource": "test-timebased-correlation-resource-4-2",
      "state": 2
    }
    """
    When I do GET /api/v4/alarms?search=test-timebased-correlation-resource-4&correlation=true until response code is 200 and body contains:
    """json
    {
      "data": [
        {
          "is_meta_alarm": true,
          "children": 2,
          "meta_alarm_rule": {
            "name": "test-timebased-correlation-4"
          }
        }
      ],
      "meta": {
        "page": 1,
        "page_count": 1,
        "per_page": 10,
        "total_count": 1
      }
    }
    """
    When I save response metaAlarmID={{ (index .lastResponse.data 0)._id }}
    When I do DELETE /api/v4/cat/metaalarmrules/{{ .metaAlarmRuleID }}
    Then the response code should be 204
    When I do GET /api/v4/alarms/{{ .metaAlarmID }}
    Then the response code should be 404
    When I do GET /api/v4/alarms?search=test-timebased-correlation-4&sort_by=v.resource&sort=asc
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "v": {
            "connector": "test-timebased-4",
            "connector_name": "test-timebased-4-name",
            "component":  "test-timebased-correlation-4",
            "resource": "test-timebased-correlation-resource-4-1",
            "parents": []
          }
        },
        {
          "v": {
            "connector": "test-timebased-4",
            "connector_name": "test-timebased-4-name",
            "component":  "test-timebased-correlation-4",
            "resource": "test-timebased-correlation-resource-4-2",
            "parents": []
          }
        }
      ],
      "meta": {
        "page": 1,
        "page_count": 1,
        "per_page": 10,
        "total_count": 2
      }
    }
    """

  @concurrent
  Scenario: given meta alarm and removed child should update meta alarm
    Given I am admin
    When I do POST /api/v4/cat/metaalarmrules:
    """json
    {
      "name": "test-metaalarmrule-correlation-timebased-5",
      "type": "timebased",
      "output_template": "{{ `{{ .Count }}` }}",
      "config": {
        "time_interval": {
          "value": 10,
          "unit": "s"
        }
      },
      "alarm_pattern": [
        [
          {
            "field": "v.component",
            "cond": {
              "type": "eq",
              "value": "test-component-correlation-timebased-5"
            }
          }
        ]
      ]
    }
    """
    Then the response code should be 201
    Then I save response metaAlarmRuleID={{ .lastResponse._id }}
    When I wait the next periodical process
    When I send an event and wait the end of event processing:
    """json
    [
      {
        "event_type": "check",
        "state": 2,
        "component": "test-component-correlation-timebased-5",
        "connector": "test-connector-correlation-timebased-5",
        "connector_name": "test-connector-name-correlation-timebased-5",
        "resource": "test-resource-correlation-timebased-5-1",
        "source_type": "resource"
      },
      {
        "event_type": "check",
        "state": 3,
        "component": "test-component-correlation-timebased-5",
        "connector": "test-connector-correlation-timebased-5",
        "connector_name": "test-connector-name-correlation-timebased-5",
        "resource": "test-resource-correlation-timebased-5-2",
        "source_type": "resource"
      }
    ]
    """
    When I do GET /api/v4/alarms?search=test-resource-correlation-timebased-5&correlation=true until response code is 200 and body contains:
    """json
    {
      "data": [
        {
          "is_meta_alarm": true,
          "children": 2,
          "meta_alarm_rule": {
            "name": "test-metaalarmrule-correlation-timebased-5"
          },
          "v": {
            "output": "2",
            "state": {
              "val": 3
            }
          }
        }
      ],
      "meta": {
        "page": 1,
        "page_count": 1,
        "per_page": 10,
        "total_count": 1
      }
    }
    """
    When I save response metaAlarmId={{ (index .lastResponse.data 0)._id }}
    When I do POST /api/v4/alarm-details:
    """json
    [
      {
        "_id": "{{ .metaAlarmId }}",
        "children": {
          "page": 1,
          "sort_by": "v.resource",
          "sort": "asc"
        }
      }
    ]
    """
    Then the response code should be 207
    Then the response body should contain:
    """json
    [
      {
        "status": 200,
        "data": {
          "children": {
            "data": [
              {
                "v": {
                  "component": "test-component-correlation-timebased-5",
                  "connector": "test-connector-correlation-timebased-5",
                  "connector_name": "test-connector-name-correlation-timebased-5",
                  "resource": "test-resource-correlation-timebased-5-1"
                }
              },
              {
                "v": {
                  "component": "test-component-correlation-timebased-5",
                  "connector": "test-connector-correlation-timebased-5",
                  "connector_name": "test-connector-name-correlation-timebased-5",
                  "resource": "test-resource-correlation-timebased-5-2"
                }
              }
            ],
            "meta": {
              "page": 1,
              "page_count": 1,
              "per_page": 10,
              "total_count": 2
            }
          }
        }
      }
    ]
    """
    When I save response childAlarmId2={{ (index (index .lastResponse 0).data.children.data 1)._id }}
    When I do PUT /api/v4/cat/meta-alarms/{{ .metaAlarmId }}/remove:
    """json
    {
      "comment": "test-metaalarmrule-correlation-timebased-5-remove-comment",
      "alarms": ["{{ .childAlarmId2 }}"]
    }
    """
    Then the response code should be 204
    When I do GET /api/v4/alarms?search=test-resource-correlation-timebased-5&correlation=true&sort_by=v.meta&sort=desc until response code is 200 and body contains:
    """json
    {
      "data": [
        {
          "is_meta_alarm": true,
          "children": 1,
          "meta_alarm_rule": {
            "name": "test-metaalarmrule-correlation-timebased-5"
          },
          "v": {
            "output": "1",
            "children": [
              "test-resource-correlation-timebased-5-1/test-component-correlation-timebased-5"
            ],
            "state": {
              "val": 2
            }
          }
        },
        {
          "v": {
            "component": "test-component-correlation-timebased-5",
            "connector": "test-connector-correlation-timebased-5",
            "connector_name": "test-connector-name-correlation-timebased-5",
            "resource": "test-resource-correlation-timebased-5-2"
          }
        }
      ],
      "meta": {
        "page": 1,
        "page_count": 1,
        "per_page": 10,
        "total_count": 2
      }
    }
    """
    When I do POST /api/v4/alarm-details:
    """json
    [
      {
        "_id": "{{ .metaAlarmId }}",
        "children": {
          "page": 1,
          "sort_by": "v.resource",
          "sort": "asc"
        }
      }
    ]
    """
    Then the response code should be 207
    Then the response body should contain:
    """json
    [
      {
        "status": 200,
        "data": {
          "children": {
            "data": [
              {
                "v": {
                  "component": "test-component-correlation-timebased-5",
                  "connector": "test-connector-correlation-timebased-5",
                  "connector_name": "test-connector-name-correlation-timebased-5",
                  "resource": "test-resource-correlation-timebased-5-1"
                }
              }
            ],
            "meta": {
              "page": 1,
              "page_count": 1,
              "per_page": 10,
              "total_count": 1
            }
          }
        }
      }
    ]
    """

  @concurrent
  Scenario: given meta alarm and removed child should not add child to meta alarm again but add to new meta alarm on change
    Given I am admin
    When I do POST /api/v4/cat/metaalarmrules:
    """json
    {
      "name": "test-metaalarmrule-correlation-timebased-6",
      "type": "timebased",
      "output_template": "{{ `{{ .Count }}` }}",
      "config": {
        "time_interval": {
          "value": 3,
          "unit": "s"
        }
      },
      "alarm_pattern": [
        [
          {
            "field": "v.component",
            "cond": {
              "type": "eq",
              "value": "test-component-correlation-timebased-6"
            }
          }
        ]
      ]
    }
    """
    Then the response code should be 201
    Then I save response metaAlarmRuleID={{ .lastResponse._id }}
    When I wait the next periodical process
    When I send an event and wait the end of event processing:
    """json
    [
      {
        "event_type": "check",
        "state": 2,
        "component": "test-component-correlation-timebased-6",
        "connector": "test-connector-correlation-timebased-6",
        "connector_name": "test-connector-name-correlation-timebased-6",
        "resource": "test-resource-correlation-timebased-6-1",
        "source_type": "resource"
      },
      {
        "event_type": "check",
        "state": 3,
        "component": "test-component-correlation-timebased-6",
        "connector": "test-connector-correlation-timebased-6",
        "connector_name": "test-connector-name-correlation-timebased-6",
        "resource": "test-resource-correlation-timebased-6-2",
        "source_type": "resource"
      }
    ]
    """
    When I do GET /api/v4/alarms?search=test-resource-correlation-timebased-6&correlation=true until response code is 200 and body contains:
    """json
    {
      "data": [
        {
          "is_meta_alarm": true,
          "children": 2,
          "meta_alarm_rule": {
            "name": "test-metaalarmrule-correlation-timebased-6"
          },
          "v": {
            "output": "2"
          }
        }
      ],
      "meta": {
        "page": 1,
        "page_count": 1,
        "per_page": 10,
        "total_count": 1
      }
    }
    """
    When I save response metaAlarmId1={{ (index .lastResponse.data 0)._id }}
    When I do POST /api/v4/alarm-details:
    """json
    [
      {
        "_id": "{{ .metaAlarmId1 }}",
        "children": {
          "page": 1,
          "sort_by": "v.resource",
          "sort": "asc"
        }
      }
    ]
    """
    Then the response code should be 207
    When I save response childAlarmId2={{ (index (index .lastResponse 0).data.children.data 1)._id }}
    When I do PUT /api/v4/cat/meta-alarms/{{ .metaAlarmId1 }}/remove:
    """json
    {
      "comment": "test-metaalarmrule-correlation-timebased-6-remove-comment",
      "alarms": ["{{ .childAlarmId2 }}"]
    }
    """
    Then the response code should be 204
    When I do GET /api/v4/alarms?search=test-resource-correlation-timebased-6&correlation=true&sort_by=v.meta&sort=desc until response code is 200 and body contains:
    """json
    {
      "data": [
        {
          "is_meta_alarm": true,
          "children": 1,
          "meta_alarm_rule": {
            "name": "test-metaalarmrule-correlation-timebased-6"
          },
          "v": {
            "output": "1",
            "children": [
              "test-resource-correlation-timebased-6-1/test-component-correlation-timebased-6"
            ],
            "state": {
              "val": 2
            }
          }
        },
        {
          "v": {
            "component": "test-component-correlation-timebased-6",
            "connector": "test-connector-correlation-timebased-6",
            "connector_name": "test-connector-name-correlation-timebased-6",
            "resource": "test-resource-correlation-timebased-6-2"
          }
        }
      ],
      "meta": {
        "page": 1,
        "page_count": 1,
        "per_page": 10,
        "total_count": 2
      }
    }
    """
    When I send an event and wait the end of event processing:
    """json
    {
      "event_type": "check",
      "state": 2,
      "component": "test-component-correlation-timebased-6",
      "connector": "test-connector-correlation-timebased-6",
      "connector_name": "test-connector-name-correlation-timebased-6",
      "resource": "test-resource-correlation-timebased-6-2",
      "source_type": "resource"
    }
    """
    When I wait 1s
    When I do GET /api/v4/alarms?search=test-resource-correlation-timebased-6&correlation=true&sort_by=v.meta&sort=desc
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "is_meta_alarm": true,
          "children": 1,
          "meta_alarm_rule": {
            "name": "test-metaalarmrule-correlation-timebased-6"
          },
          "v": {
            "output": "1",
            "children": [
              "test-resource-correlation-timebased-6-1/test-component-correlation-timebased-6"
            ],
            "state": {
              "val": 2
            }
          }
        },
        {
          "v": {
            "component": "test-component-correlation-timebased-6",
            "connector": "test-connector-correlation-timebased-6",
            "connector_name": "test-connector-name-correlation-timebased-6",
            "resource": "test-resource-correlation-timebased-6-2"
          }
        }
      ],
      "meta": {
        "page": 1,
        "page_count": 1,
        "per_page": 10,
        "total_count": 2
      }
    }
    """
    When I send an event and wait the end of event processing:
    """json
    {
      "event_type": "check",
      "state": 2,
      "component": "test-component-correlation-timebased-6",
      "connector": "test-connector-correlation-timebased-6",
      "connector_name": "test-connector-name-correlation-timebased-6",
      "resource": "test-resource-correlation-timebased-6-3",
      "source_type": "resource"
    }
    """
    When I do GET /api/v4/alarms?search=test-resource-correlation-timebased-6&correlation=true&sort_by=v.meta&sort=desc until response code is 200 and body contains:
    """json
    {
      "data": [
        {
          "is_meta_alarm": true,
          "children": 2,
          "meta_alarm_rule": {
            "name": "test-metaalarmrule-correlation-timebased-6"
          },
          "v": {
            "output": "2",
            "state": {
              "val": 2
            }
          }
        },
        {
          "v": {
            "resource": "test-resource-correlation-timebased-6-2"
          }
        }
      ],
      "meta": {
        "page": 1,
        "page_count": 1,
        "per_page": 10,
        "total_count": 2
      }
    }
    """
    When I wait 3s
    When I send an event and wait the end of event processing:
    """json
    {
      "event_type": "check",
      "state": 3,
      "component": "test-component-correlation-timebased-6",
      "connector": "test-connector-correlation-timebased-6",
      "connector_name": "test-connector-name-correlation-timebased-6",
      "resource": "test-resource-correlation-timebased-6-2",
      "source_type": "resource"
    }
    """
    When I send an event and wait the end of event processing:
    """json
    {
      "event_type": "check",
      "state": 2,
      "component": "test-component-correlation-timebased-6",
      "connector": "test-connector-correlation-timebased-6",
      "connector_name": "test-connector-name-correlation-timebased-6",
      "resource": "test-resource-correlation-timebased-6-4",
      "source_type": "resource"
    }
    """
    When I do GET /api/v4/alarms?search=test-resource-correlation-timebased-6&correlation=true&sort_by=t&sort=desc until response code is 200 and body contains:
    """json
    {
      "data": [
        {
          "is_meta_alarm": true,
          "children": 2,
          "meta_alarm_rule": {
            "name": "test-metaalarmrule-correlation-timebased-6"
          },
          "v": {
            "output": "2",
            "state": {
              "val": 3
            }
          }
        },
        {
          "is_meta_alarm": true,
          "children": 2,
          "meta_alarm_rule": {
            "name": "test-metaalarmrule-correlation-timebased-6"
          },
          "v": {
            "output": "2",
            "state": {
              "val": 2
            }
          }
        }
      ],
      "meta": {
        "page": 1,
        "page_count": 1,
        "per_page": 10,
        "total_count": 2
      }
    }
    """
    When I save response metaAlarmId2={{ (index .lastResponse.data 0)._id }}
    When I do POST /api/v4/alarm-details:
    """json
    [
      {
        "_id": "{{ .metaAlarmId2 }}",
        "children": {
          "page": 1,
          "sort_by": "v.resource",
          "sort": "asc"
        }
      },
      {
        "_id": "{{ .metaAlarmId1 }}",
        "children": {
          "page": 1,
          "sort_by": "v.resource",
          "sort": "asc"
        }
      }
    ]
    """
    Then the response code should be 207
    Then the response body should contain:
    """json
    [
      {
        "status": 200,
        "data": {
          "children": {
            "data": [
              {
                "v": {
                  "resource": "test-resource-correlation-timebased-6-2"
                }
              },
              {
                "v": {
                  "resource": "test-resource-correlation-timebased-6-4"
                }
              }
            ],
            "meta": {
              "page": 1,
              "page_count": 1,
              "per_page": 10,
              "total_count": 2
            }
          }
        }
      },
      {
        "status": 200,
        "data": {
          "children": {
            "data": [
              {
                "v": {
                  "resource": "test-resource-correlation-timebased-6-1"
                }
              },
              {
                "v": {
                  "resource": "test-resource-correlation-timebased-6-3"
                }
              }
            ],
            "meta": {
              "page": 1,
              "page_count": 1,
              "per_page": 10,
              "total_count": 2
            }
          }
        }
      }
    ]
    """
