Feature: execute action on trigger
  I need to be able to trigger action on event

  Scenario: given scenario and check event should update alarm
    Given I am admin
    When I do POST /api/v4/scenarios:
    """json
    {
      "name": "test-scenario-action-webhook-1-name",
      "enabled": true,
      "triggers": ["create"],
      "actions": [
        {
          "alarm_pattern": [
            [
              {
                "field": "v.component",
                "cond": {
                  "type": "eq",
                  "value": "test-component-action-webhook-1"
                }
              }
            ]
          ],
          "type": "webhook",
          "parameters": {
            "request": {
              "method": "POST",
              "url": "{{ .apiURL }}/api/v4/scenarios",
              "auth": {
                "username": "root",
                "password": "test"
              },
              "headers": {"Content-Type": "application/json"},
              "payload": "{\"name\":\"test-scenario-action-webhook-1 {{ `{{ .Entity.ID }}` }}\",\"enabled\":true,\"triggers\":[\"create\"],\"actions\":[{\"entity_pattern\":[[{\"field\":\"name\",\"cond\":{\"type\": \"eq\", \"value\": \"test-scenario-action-webhook-1\"}}]],\"type\":\"ack\",\"drop_scenario_if_not_matched\":false,\"emit_trigger\":false}]}"
            },
            "declare_ticket": {
              "empty_response": false,
              "is_regexp": false,
              "ticket_id": "_id",
              "scenario_name": "name"
            }
          },
          "drop_scenario_if_not_matched": false,
          "emit_trigger": false
        }
      ]
    }
    """
    Then the response code should be 201
    When I wait the next periodical process
    When I send an event:
    """json
    {
      "connector" : "test-connector-action-webhook-1",
      "connector_name" : "test-connector-name-action-webhook-1",
      "source_type" : "resource",
      "event_type" : "check",
      "component" :  "test-component-action-webhook-1",
      "resource" : "test-resource-action-webhook-1",
      "state" : 2,
      "output" : "noveo alarm"
    }
    """
    When I wait the end of event processing
    When I do GET /api/v4/alarms?search=test-resource-action-webhook-1
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "v": {
            "ticket": {
              "_t": "declareticket",
              "a": "system",
              "data": {
                "scenario_name": "test-scenario-action-webhook-1 test-resource-action-webhook-1/test-component-action-webhook-1"
              }
            },
            "connector": "test-connector-action-webhook-1",
            "connector_name": "test-connector-name-action-webhook-1",
            "component": "test-component-action-webhook-1",
            "resource": "test-resource-action-webhook-1"
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
        "steps": {
          "page": 1
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
          "steps": {
            "data": [
              {
                "_t": "stateinc"
              },
              {
                "_t": "statusinc"
              },
              {
                "_t": "declareticket",
                "a": "system",
                "user_id": ""
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
      }
    ]
    """

  Scenario: given scenario and check event should emit declare ticket trigger
    Given I am admin
    When I do POST /api/v4/scenarios:
    """json
    {
      "name": "test-scenario-action-webhook-2-1-name",
      "enabled": true,
      "triggers": ["create"],
      "actions": [
        {
          "alarm_pattern": [
            [
              {
                "field": "v.component",
                "cond": {
                  "type": "eq",
                  "value": "test-component-action-webhook-2"
                }
              }
            ]
          ],
          "type": "webhook",
          "parameters": {
            "forward_author": true,
            "author": "test-scenario-action-webhook-2-action-1-author {{ `{{ .Alarm.Value.Resource }}` }}",
            "request": {
              "method": "POST",
              "url": "{{ .apiURL }}/api/v4/scenarios",
              "auth": {
                "username": "root",
                "password": "test"
              },
              "headers": {"Content-Type": "application/json"},
              "payload": "{\"name\":\"test-scenario-action-webhook-2 {{ `{{ .Alarm.Value.Resource }}` }}\",\"enabled\":true,\"triggers\":[\"create\"],\"actions\":[{\"entity_pattern\":[[{\"field\":\"name\",\"cond\":{\"type\": \"eq\", \"value\": \"test-scenario-action-webhook-2\"}}]],\"type\":\"ack\",\"drop_scenario_if_not_matched\":false,\"emit_trigger\":false}]}"
            },
            "declare_ticket": {
              "empty_response": false,
              "is_regexp": false,
              "ticket_id": "_id",
              "scenario_name": "name"
            }
          },
          "drop_scenario_if_not_matched": false,
          "emit_trigger": true
        }
      ]
    }
    """
    Then the response code should be 201
    When I do POST /api/v4/scenarios:
    """json
    {
      "name": "test-scenario-action-webhook-2-2-name",
      "enabled": true,
      "triggers": ["declareticketwebhook"],
      "actions": [
        {
          "alarm_pattern": [
            [
              {
                "field": "v.component",
                "cond": {
                  "type": "eq",
                  "value": "test-component-action-webhook-2"
                }
              }
            ]
          ],
          "type": "ack",
          "drop_scenario_if_not_matched": false,
          "emit_trigger": false
        }
      ]
    }
    """
    Then the response code should be 201
    When I wait the next periodical process
    When I send an event:
    """json
    {
      "connector" : "test-connector-action-webhook-2",
      "connector_name" : "test-connector-name-action-webhook-2",
      "source_type" : "resource",
      "event_type" : "check",
      "component" :  "test-component-action-webhook-2",
      "resource" : "test-resource-action-webhook-2",
      "state" : 2,
      "output" : "noveo alarm"
    }
    """
    When I wait the end of event processing
    When I do GET /api/v4/alarms?search=test-resource-action-webhook-2
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "v": {
            "ticket": {
              "_t": "declareticket",
              "a": "root",
              "data": {
                "scenario_name": "test-scenario-action-webhook-2 test-resource-action-webhook-2"
              }
            },
            "ack": {
              "_t": "ack"
            },
            "connector": "test-connector-action-webhook-2",
            "connector_name": "test-connector-name-action-webhook-2",
            "component": "test-component-action-webhook-2",
            "resource": "test-resource-action-webhook-2"
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
        "steps": {
          "page": 1
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
          "steps": {
            "data": [
              {
                "_t": "stateinc"
              },
              {
                "_t": "statusinc"
              },
              {
                "_t": "declareticket",
                "a": "root",
                "user_id": "root"
              },
              {
                "_t": "ack"
              }
            ],
            "meta": {
              "page": 1,
              "page_count": 1,
              "per_page": 10,
              "total_count": 4
            }
          }
        }
      }
    ]
    """

  Scenario: given scenario and ack resources event should update resource alarms
    Given I am admin
    When I do POST /api/v4/scenarios:
    """json
    {
      "name": "test-scenario-action-webhook-3-name",
      "enabled": true,
      "triggers": ["ack"],
      "actions": [
        {
          "alarm_pattern": [
            [
              {
                "field": "v.component",
                "cond": {
                  "type": "eq",
                  "value": "test-component-action-webhook-3"
                }
              }
            ]
          ],
          "type": "webhook",
          "parameters": {
            "request": {
              "method": "POST",
              "url": "{{ .apiURL }}/api/v4/scenarios",
              "auth": {
                "username": "root",
                "password": "test"
              },
              "headers": {"Content-Type": "application/json"},
              "payload": "{\"name\":\"test-scenario-action-webhook-3\",\"enabled\":true,\"triggers\":[\"create\"],\"actions\":[{\"entity_pattern\":[[{\"field\":\"name\",\"cond\":{\"type\": \"eq\", \"value\": \"test-scenario-action-webhook-3\"}}]],\"type\":\"ack\",\"drop_scenario_if_not_matched\":false,\"emit_trigger\":false}]}"
            },
            "declare_ticket": {
              "empty_response": false,
              "is_regexp": false,
              "ticket_id": "_id",
              "scenario_name": "name"
            }
          },
          "drop_scenario_if_not_matched": false,
          "emit_trigger": false
        }
      ]
    }
    """
    Then the response code should be 201
    When I wait the next periodical process
    When I send an event:
    """json
    {
      "connector" : "test-connector-action-webhook-3",
      "connector_name" : "test-connector-name-action-webhook-3",
      "source_type" : "component",
      "event_type" : "check",
      "component" :  "test-component-action-webhook-3",
      "state" : 2,
      "output" : "noveo alarm"
    }
    """
    When I wait the end of event processing
    When I send an event:
    """json
    {
      "connector" : "test-connector-action-webhook-3",
      "connector_name" : "test-connector-name-action-webhook-3",
      "source_type" : "resource",
      "event_type" : "check",
      "component" :  "test-component-action-webhook-3",
      "resource" : "test-resource-action-webhook-3",
      "state" : 2,
      "output" : "noveo alarm"
    }
    """
    When I wait the end of event processing
    When I send an event:
    """json
    {
      "connector" : "test-connector-action-webhook-3",
      "connector_name" : "test-connector-name-action-webhook-3",
      "source_type" : "component",
      "event_type" : "ack",
      "component" :  "test-component-action-webhook-3",
      "ack_resources": true,
      "output" : "noveo alarm"
    }
    """
    When I wait the end of 3 events processing
    When I do GET /api/v4/alarms?search=test-component-action-webhook-3&sort_by=v.resource&sort=asc
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "v": {
            "ticket": {
              "_t": "declareticket"
            },
            "ack": {
              "_t": "ack"
            },
            "connector": "test-connector-action-webhook-3",
            "connector_name": "test-connector-name-action-webhook-3",
            "component": "test-component-action-webhook-3"
          }
        },
        {
          "v": {
            "ticket": {
              "_t": "declareticket"
            },
            "ack": {
              "_t": "ack"
            },
            "connector": "test-connector-action-webhook-3",
            "connector_name": "test-connector-name-action-webhook-3",
            "component": "test-component-action-webhook-3",
            "resource": "test-resource-action-webhook-3"
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
        "steps": {
          "page": 1
        }
      },
      {
        "_id": "{{ (index .lastResponse.data 1)._id }}",
        "steps": {
          "page": 1
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
          "steps": {
            "data": [
              {
                "_t": "stateinc"
              },
              {
                "_t": "statusinc"
              },
              {
                "_t": "ack"
              },
              {
                "_t": "declareticket"
              }
            ],
            "meta": {
              "page": 1,
              "page_count": 1,
              "per_page": 10,
              "total_count": 4
            }
          }
        }
      },
      {
        "status": 200,
        "data": {
          "steps": {
            "data": [
              {
                "_t": "stateinc"
              },
              {
                "_t": "statusinc"
              },
              {
                "_t": "ack"
              },
              {
                "_t": "declareticket"
              }
            ],
            "meta": {
              "page": 1,
              "page_count": 1,
              "per_page": 10,
              "total_count": 4
            }
          }
        }
      }
    ]
    """

  Scenario: given webhook scenario to test response and header templates
    Given I am admin
    When I do POST /api/v4/scenarios:
    """json
    {
      "name": "test-scenario-action-webhook-4-name",
      "enabled": true,
      "triggers": ["create"],
      "actions": [
        {
          "alarm_pattern": [
            [
              {
                "field": "v.component",
                "cond": {
                  "type": "eq",
                  "value": "test-component-action-webhook-4"
                }
              }
            ]
          ],
          "type": "webhook",
          "parameters": {
            "request": {
              "method": "GET",
              "url": "{{ .apiURL }}/api/v4/pbehavior-types/test-default-active-type",
              "auth": {
                "username": "root",
                "password": "test"
              },
              "headers": {"Content-Type": "application/json"}
            }
          },
          "drop_scenario_if_not_matched": false,
          "emit_trigger": false
        },
        {
          "alarm_pattern": [
            [
              {
                "field": "v.component",
                "cond": {
                  "type": "eq",
                  "value": "test-component-action-webhook-4"
                }
              }
            ]
          ],
          "type": "webhook",
          "parameters": {
            "request": {
              "method": "POST",
              "url": "{{ .apiURL }}/api/v4/scenarios",
              "auth": {
                "username": "root",
                "password": "test"
              },
              "headers": {"Content-Type": "{{ `{{index .Header \"Content-Type\"}}` }}"},
              "payload": "{\"name\":\"test-scenario-action-webhook-4-webhook {{ `{{index .Response \"icon_name\"}}` }}\",\"enabled\":true,\"triggers\":[\"create\"],\"actions\":[{\"alarm_pattern\":[[{\"field\":\"v.resource\",\"cond\":{\"type\": \"eq\", \"value\": \"{{ `{{index .Response \"_id\"}}` }}\"}}]],\"type\":\"ack\",\"drop_scenario_if_not_matched\":false,\"emit_trigger\":false}]}"
            }
          },
          "drop_scenario_if_not_matched": false,
          "emit_trigger": false
        }
      ]
    }
    """
    Then the response code should be 201
    When I wait the next periodical process
    When I send an event:
    """json
    {
      "connector" : "test-connector-action-webhook-4",
      "connector_name" : "test-connector-name-action-webhook-4",
      "source_type" : "resource",
      "event_type" : "check",
      "component" :  "test-component-action-webhook-4",
      "resource" : "test-resource-action-webhook-4",
      "state" : 2,
      "output" : "noveo alarm"
    }
    """
    When I wait the end of event processing
    When I do GET /api/v4/scenarios?search=test-scenario-action-webhook-4-webhook
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "name": "test-scenario-action-webhook-4-webhook test-active-icon",
          "actions": [
            {
              "alarm_pattern": [
                [
                  {
                    "field": "v.resource",
                    "cond": {
                      "type": "eq",
                      "value": "test-default-active-type"
                    }
                  }
                ]
              ]
            }
          ]
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

  Scenario: given scenario and declareticket event should update alarm
    Given I am admin
    When I do POST /api/v4/scenarios:
    """json
    {
      "name": "test-scenario-action-webhook-5-name",
      "enabled": true,
      "triggers": ["declareticket"],
      "actions": [
        {
          "alarm_pattern": [
            [
              {
                "field": "v.component",
                "cond": {
                  "type": "eq",
                  "value": "test-component-action-webhook-5"
                }
              }
            ]
          ],
          "type": "webhook",
          "parameters": {
            "forward_author": false,
            "request": {
              "method": "POST",
              "url": "{{ .apiURL }}/api/v4/scenarios",
              "auth": {
                "username": "root",
                "password": "test"
              },
              "headers": {"Content-Type": "application/json"},
              "payload": "{\"name\":\"{{ `{{ .Entity.ID }}` }}\",\"enabled\":true,\"triggers\":[\"create\"],\"actions\":[{\"alarm_pattern\":[[{\"field\":\"v.resource\",\"cond\":{\"type\": \"eq\", \"value\": \"test-scenario-action-webhook-5-alarm\"}}]],\"type\":\"ack\",\"drop_scenario_if_not_matched\":false,\"emit_trigger\":false}]}"
            },
            "declare_ticket": {
              "empty_response": false,
              "is_regexp": false,
              "ticket_id": "_id",
              "scenario_name": "name"
            }
          },
          "drop_scenario_if_not_matched": false,
          "emit_trigger": false
        }
      ]
    }
    """
    Then the response code should be 201
    When I wait the next periodical process
    When I send an event:
    """json
    {
      "connector" : "test-connector-action-webhook-5",
      "connector_name" : "test-connector-name-action-webhook-5",
      "source_type" : "resource",
      "event_type" : "check",
      "component" :  "test-component-action-webhook-5",
      "resource" : "test-resource-action-webhook-5",
      "state" : 2,
      "output" : "noveo alarm"
    }
    """
    When I wait the end of event processing
    When I send an event:
    """json
    {
      "connector" : "test-connector-action-webhook-5",
      "connector_name" : "test-connector-name-action-webhook-5",
      "source_type" : "resource",
      "event_type" : "declareticket",
      "component" :  "test-component-action-webhook-5",
      "resource" : "test-resource-action-webhook-5",
      "output" : "noveo alarm"
    }
    """
    When I wait the end of event processing
    When I do GET /api/v4/alarms?search=test-resource-action-webhook-5
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "v": {
            "ticket": {
              "_t": "declareticket",
              "a": "system",
              "data": {
                "scenario_name": "test-resource-action-webhook-5/test-component-action-webhook-5"
              }
            },
            "connector": "test-connector-action-webhook-5",
            "connector_name": "test-connector-name-action-webhook-5",
            "component": "test-component-action-webhook-5",
            "resource": "test-resource-action-webhook-5"
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
        "steps": {
          "page": 1
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
          "steps": {
            "data": [
              {
                "_t": "stateinc"
              },
              {
                "_t": "statusinc"
              },
              {
                "_t": "declareticket",
                "a": "system",
                "user_id": ""
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
      }
    ]
    """

  Scenario: given scenarios with 2 actions and webhook should be able to use additional data in template
    Given I am admin
    When I do POST /api/v4/scenarios:
    """json
    {
      "name": "test-scenario-action-webhook-6-1-name",
      "enabled": true,
      "triggers": [
        "create"
      ],
      "actions": [
        {
          "alarm_pattern": [
            [
              {
                "field": "v.component",
                "cond": {
                  "type": "eq",
                  "value": "test-component-action-webhook-6"
                }
              }
            ]
          ],
          "type": "webhook",
          "parameters": {
            "forward_author": true,
            "request": {
              "method": "POST",
              "url": "{{ .apiURL }}/api/v4/scenarios",
              "auth": {
                "username": "root",
                "password": "test"
              },
              "headers": {
                "Content-Type": "application/json"
              },
              "payload": "{\"name\": \"{{ `test-scenario-action-webhook-6-1-action-1 [{{ .AdditionalData.AlarmChangeType }}] [{{ .AdditionalData.Author }}] [{{ .AdditionalData.Initiator }}] [{{ .AdditionalData.User }}]` }}\", \"enabled\":true,\"triggers\":[\"create\"],\"actions\":[{\"alarm_pattern\":[[{\"field\":\"v.resource\",\"cond\":{\"type\": \"eq\", \"value\": \"test-scenario-action-webhook-6-alarm\"}}]],\"type\":\"ack\",\"drop_scenario_if_not_matched\":false,\"emit_trigger\":false}]}"
            },
            "declare_ticket": {
              "empty_response": false,
              "is_regexp": false,
              "ticket_id": "_id",
              "scenario_name": "name"
            }
          },
          "drop_scenario_if_not_matched": false,
          "emit_trigger": false
        },
        {
          "alarm_pattern": [
            [
              {
                "field": "v.component",
                "cond": {
                  "type": "eq",
                  "value": "test-component-action-webhook-6"
                }
              }
            ]
          ],
          "drop_scenario_if_not_matched": false,
          "emit_trigger": true,
          "type": "webhook",
          "parameters": {
            "request": {
              "method": "POST",
              "url": "{{ .apiURL }}/api/v4/scenarios",
              "auth": {
                "username": "root",
                "password": "test"
              },
              "headers": {
                "Content-Type": "application/json"
              },
              "payload": "{\"name\": \"{{ `test-scenario-action-webhook-6-1-action-2 [{{ .AdditionalData.AlarmChangeType }}] [{{ .AdditionalData.Author }}] [{{ .AdditionalData.Initiator }}] [{{ .AdditionalData.User }}]` }}\", \"enabled\":true,\"triggers\":[\"create\"],\"actions\":[{\"alarm_pattern\":[[{\"field\":\"v.resource\",\"cond\":{\"type\": \"eq\", \"value\": \"test-scenario-action-webhook-6-alarm\"}}]],\"type\":\"ack\",\"drop_scenario_if_not_matched\":false,\"emit_trigger\":false}]}"
            },
            "declare_ticket": {
              "empty_response": false,
              "is_regexp": false,
              "ticket_id": "_id",
              "scenario_name_2": "name"
            }
          }
        }
      ]
    }
    """
    Then the response code should be 201
    When I do POST /api/v4/scenarios:
    """json
    {
      "name": "test-scenario-action-webhook-6-2-name",
      "enabled": true,
      "triggers": [
        "declareticketwebhook"
      ],
      "actions": [
        {
          "alarm_pattern": [
            [
              {
                "field": "v.component",
                "cond": {
                  "type": "eq",
                  "value": "test-component-action-webhook-6"
                }
              }
            ]
          ],
          "type": "webhook",
          "parameters": {
            "author": "test-scenario-action-webhook-6-2-action-1-author",
            "request": {
              "method": "POST",
              "url": "{{ .apiURL }}/api/v4/scenarios",
              "auth": {
                "username": "root",
                "password": "test"
              },
              "headers": {
                "Content-Type": "application/json"
              },
              "payload": "{\"name\": \"{{ `test-scenario-action-webhook-6-2-action-1 [{{ .AdditionalData.AlarmChangeType }}] [{{ .AdditionalData.Author }}] [{{ .AdditionalData.Initiator }}] [{{ .AdditionalData.User }}]` }}\", \"enabled\":true,\"triggers\":[\"create\"],\"actions\":[{\"alarm_pattern\":[[{\"field\":\"v.resource\",\"cond\":{\"type\": \"eq\", \"value\": \"test-scenario-action-webhook-6-alarm\"}}]],\"type\":\"ack\",\"drop_scenario_if_not_matched\":false,\"emit_trigger\":false}]}"
            },
            "declare_ticket": {
              "empty_response": false,
              "is_regexp": false,
              "ticket_id": "_id",
              "scenario_name_3": "name"
            }
          },
          "drop_scenario_if_not_matched": false,
          "emit_trigger": false
        }
      ]
    }
    """
    Then the response code should be 201
    When I do POST /api/v4/scenarios:
    """json
    {
      "name": "test-scenario-action-webhook-6-3-name",
      "enabled": true,
      "triggers": [
        "create"
      ],
      "actions": [
        {
          "alarm_pattern": [
            [
              {
                "field": "v.component",
                "cond": {
                  "type": "eq",
                  "value": "test-component-action-webhook-6"
                }
              }
            ]
          ],
          "type": "webhook",
          "parameters": {
            "author": "test-scenario-action-webhook-6-3-action-1-author",
            "request": {
              "method": "POST",
              "url": "{{ .apiURL }}/api/v4/scenarios",
              "auth": {
                "username": "root",
                "password": "test"
              },
              "headers": {
                "Content-Type": "application/json"
              },
              "payload": "{\"name\": \"{{ `{{ $testVar := .AdditionalData.Output }}test-scenario-action-webhook-6-3-action-1 [{{$testVar}}]` }}\", \"enabled\":true,\"triggers\":[\"create\"],\"actions\":[{\"alarm_pattern\":[[{\"field\":\"v.resource\",\"cond\":{\"type\": \"eq\", \"value\": \"test-scenario-action-webhook-6-alarm\"}}]],\"type\":\"ack\",\"drop_scenario_if_not_matched\":false,\"emit_trigger\":false}]}"
            }
          },
          "drop_scenario_if_not_matched": false,
          "emit_trigger": false
        }
      ]
    }
    """
    Then the response code should be 201
    When I wait the next periodical process
    When I send an event:
    """json
    {
      "connector" : "test-connector-action-webhook-6",
      "connector_name" : "test-connector-name-action-webhook-6",
      "source_type" : "resource",
      "event_type" : "check",
      "component" :  "test-component-action-webhook-6",
      "resource" : "test-resource-action-webhook-6",
      "state" : 2,
      "output" : "noveo alarm",
      "initiator": "user"
    }
    """
    When I wait the end of event processing
    When I do GET /api/v4/alarms?search=test-resource-action-webhook-6
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "v": {
            "ticket": {
              "_t": "declareticket",
              "data": {
                "scenario_name_3": "test-scenario-action-webhook-6-2-action-1 [declareticketwebhook] [test-scenario-action-webhook-6-2-action-1-author] [user] []"
              }
            },
            "connector": "test-connector-action-webhook-6",
            "connector_name": "test-connector-name-action-webhook-6",
            "component": "test-component-action-webhook-6",
            "resource": "test-resource-action-webhook-6"
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
        "steps": {
          "page": 1
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
          "steps": {
            "data": [
              {
                "_t": "stateinc"
              },
              {
                "_t": "statusinc"
              },
              {
                "_t": "declareticket",
                "a": "root",
                "user_id": "root"
              },
              {
                "_t": "declareticket",
                "a": "system",
                "user_id": ""
              },
              {
                "_t": "declareticket",
                "a": "test-scenario-action-webhook-6-2-action-1-author",
                "user_id": ""
              }
            ],
            "meta": {
              "page": 1,
              "page_count": 1,
              "per_page": 10,
              "total_count": 5
            }
          }
        }
      }
    ]
    """
    When I do GET /api/v4/scenarios?search=test-scenario-action-webhook-6-1-action-1
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "name": "test-scenario-action-webhook-6-1-action-1 [create] [root] [user] [root]",
          "enabled": true,
          "triggers": [
            "create"
          ],
          "actions": [
            {
              "alarm_pattern": [
                [
                  {
                    "field": "v.resource",
                    "cond": {
                      "type": "eq",
                      "value": "test-scenario-action-webhook-6-alarm"
                    }
                  }
                ]
              ]
            }
          ]
        }
      ],
      "meta": {
        "page": 1,
        "per_page": 10,
        "page_count": 1,
        "total_count": 1
      }
    }
    """
    When I do GET /api/v4/scenarios?search=test-scenario-action-webhook-6-1-action-2
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "name": "test-scenario-action-webhook-6-1-action-2 [declareticketwebhook] [system] [user] []",
          "enabled": true,
          "triggers": [
            "create"
          ],
          "actions": [
            {
              "alarm_pattern": [
                [
                  {
                    "field": "v.resource",
                    "cond": {
                      "type": "eq",
                      "value": "test-scenario-action-webhook-6-alarm"
                    }
                  }
                ]
              ]
            }
          ]
        }
      ],
      "meta": {
        "page": 1,
        "per_page": 10,
        "page_count": 1,
        "total_count": 1
      }
    }
    """
    When I do GET /api/v4/scenarios?search=test-scenario-action-webhook-6-2-action-1
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "name": "test-scenario-action-webhook-6-2-action-1 [declareticketwebhook] [test-scenario-action-webhook-6-2-action-1-author] [user] []",
          "enabled": true,
          "triggers": [
            "create"
          ],
          "actions": [
            {
              "alarm_pattern": [
                [
                  {
                    "field": "v.resource",
                    "cond": {
                      "type": "eq",
                      "value": "test-scenario-action-webhook-6-alarm"
                    }
                  }
                ]
              ]
            }
          ]
        }
      ],
      "meta": {
        "page": 1,
        "per_page": 10,
        "page_count": 1,
        "total_count": 1
      }
    }
    """
    When I do GET /api/v4/scenarios?search=test-scenario-action-webhook-6-3-action-1
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "name": "test-scenario-action-webhook-6-3-action-1 [noveo alarm]",
          "enabled": true,
          "triggers": [
            "create"
          ],
          "actions": [
            {
              "alarm_pattern": [
                [
                  {
                    "field": "v.resource",
                    "cond": {
                      "type": "eq",
                      "value": "test-scenario-action-webhook-6-alarm"
                    }
                  }
                ]
              ]
            }
          ]
        }
      ],
      "meta": {
        "page": 1,
        "per_page": 10,
        "page_count": 1,
        "total_count": 1
      }
    }
    """

  Scenario: given webhook scenario to test multiple response templates
    Given I am admin
    When I do POST /api/v4/scenarios:
    """json
    {
      "name": "test-scenario-action-webhook-7-name",
      "enabled": true,
      "priority": 46,
      "triggers": ["create"],
      "actions": [
        {
          "alarm_patterns": [
            {
              "v": {
                "component": "test-component-action-webhook-7"
              }
            }
          ],
          "entity_patterns": [
            {
              "_id": "test-resource-action-webhook-7/test-component-action-webhook-7"
            }
          ],
          "type": "webhook",
          "parameters": {
            "request": {
              "method": "GET",
              "url": "{{ .apiURL }}/api/v4/pbehavior-types/test-default-active-type",
              "auth": {
                "username": "root",
                "password": "test"
              },
              "headers": {"Content-Type": "application/json"}
            }
          },
          "drop_scenario_if_not_matched": false,
          "emit_trigger": false
        },
        {
          "alarm_patterns": [
            {
              "v": {
                "component": "test-component-action-webhook-7"
              }
            }
          ],
          "entity_patterns": [
            {
              "_id": "test-resource-action-webhook-7/test-component-action-webhook-7"
            }
          ],
          "type": "ack",
          "drop_scenario_if_not_matched": false,
          "emit_trigger": false
        },
        {
          "alarm_patterns": [
            {
              "v": {
                "component": "test-component-action-webhook-7"
              }
            }
          ],
          "entity_patterns": [
            {
              "_id": "test-resource-action-webhook-7/test-component-action-webhook-7"
            }
          ],
          "type": "webhook",
          "parameters": {
            "request": {
              "method": "GET",
              "url": "{{ .apiURL }}/api/v4/pbehavior-types/test-default-maintenance-type",
              "auth": {
                "username": "root",
                "password": "test"
              },
              "headers": {"Content-Type": "application/json"}
            }
          },
          "drop_scenario_if_not_matched": false,
          "emit_trigger": false
        },
        {
          "alarm_patterns": [
            {
              "v": {
                "component": "test-component-action-webhook-7"
              }
            }
          ],
          "entity_patterns": [
            {
              "_id": "test-resource-action-webhook-7/test-component-action-webhook-7"
            }
          ],
          "type": "webhook",
          "parameters": {
            "request": {
              "method": "POST",
              "url": "{{ .apiURL }}/api/v4/scenarios",
              "auth": {
                "username": "root",
                "password": "test"
              },
              "headers": {"Content-Type": "{{ `{{index .Header \"Content-Type\"}}` }}"},
              "payload": "{\"name\":\"test-scenario-action-webhook-7-webhook {{ `{{index .ResponseMap \"0._id\"}}` }}\",\"enabled\":true,\"priority\":47,\"triggers\":[\"create\"],\"actions\":[{\"alarm_patterns\":[{\"_id\":\"{{ `{{index .ResponseMap \"1._id\"}}` }}\"}],\"type\":\"ack\",\"drop_scenario_if_not_matched\":false,\"emit_trigger\":false}]}"
            }
          },
          "drop_scenario_if_not_matched": false,
          "emit_trigger": false
        }
      ]
    }
    """
    Then the response code should be 201
    When I wait the next periodical process
    When I send an event:
    """json
    {
      "connector" : "test-connector-action-webhook-7",
      "connector_name" : "test-connector-name-action-webhook-7",
      "source_type" : "resource",
      "event_type" : "check",
      "component" :  "test-component-action-webhook-7",
      "resource" : "test-resource-action-webhook-7",
      "state" : 2,
      "output" : "noveo alarm"
    }
    """
    When I wait the end of event processing
    When I do GET /api/v4/scenarios?search=test-scenario-action-webhook-7-webhook
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "name": "test-scenario-action-webhook-7-webhook test-default-active-type",
          "actions": [
            {
              "alarm_patterns": [
                {"_id": "test-default-maintenance-type"}
              ]
            }
          ]
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

  Scenario: given webhook scenario to test arrays in the response
    Given I am admin
    When I do POST /api/v4/scenarios:
    """json
    {
      "name": "test-scenario-action-webhook-8-name",
      "enabled": true,
      "priority": 48,
      "triggers": ["create"],
      "actions": [
        {
          "alarm_patterns": [
            {
              "v": {
                "component": "test-component-action-webhook-8"
              }
            }
          ],
          "entity_patterns": [
            {
              "_id": "test-resource-action-webhook-8/test-component-action-webhook-8"
            }
          ],
          "type": "webhook",
          "parameters": {
            "request": {
              "method": "GET",
              "url": "http://localhost:3000/webhook/arrays",
              "auth": {
                "username": "root",
                "password": "test"
              },
              "headers": {"Content-Type": "application/json"}
            },
            "declare_ticket": {
              "empty_response": false,
              "is_regexp": false,
              "ticket_id": "array.1.elem1",
              "test_val": "array.0.elem1"
            }
          },
          "drop_scenario_if_not_matched": false,
          "emit_trigger": false
        },
        {
          "alarm_patterns": [
            {
              "v": {
                "component": "test-component-action-webhook-8"
              }
            }
          ],
          "entity_patterns": [
            {
              "_id": "test-resource-action-webhook-8/test-component-action-webhook-8"
            }
          ],
          "type": "webhook",
          "parameters": {
            "request": {
              "method": "POST",
              "url": "{{ .apiURL }}/api/v4/scenarios",
              "auth": {
                "username": "root",
                "password": "test"
              },
              "headers": {"Content-Type": "application/json"},
              "payload": "{\"name\":\"test-scenario-action-webhook-8-webhook {{ `{{index .ResponseMap \"0.array.0.elem1\"}}` }}\",\"enabled\":true,\"priority\":49,\"triggers\":[\"create\"],\"actions\":[{\"alarm_patterns\":[{\"_id\":\"{{ `{{index .ResponseMap \"0.array.1.elem2\"}}` }}\"}],\"type\":\"ack\",\"drop_scenario_if_not_matched\":false,\"emit_trigger\":false}]}"
            }
          },
          "drop_scenario_if_not_matched": false,
          "emit_trigger": false
        }
      ]
    }
    """
    Then the response code should be 201
    When I wait the next periodical process
    When I send an event:
    """json
    {
      "connector" : "test-connector-action-webhook-8",
      "connector_name" : "test-connector-name-action-webhook-8",
      "source_type" : "resource",
      "event_type" : "check",
      "component" :  "test-component-action-webhook-8",
      "resource" : "test-resource-action-webhook-8",
      "state" : 2,
      "output" : "noveo alarm"
    }
    """
    When I wait the end of event processing
    When I do GET /api/v4/scenarios?search=test-scenario-action-webhook-8-webhook
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "name": "test-scenario-action-webhook-8-webhook test1",
          "actions": [
            {
              "alarm_patterns": [
                {"_id": "test4"}
              ]
            }
          ]
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
    When I do GET /api/v4/alarms?filter={"$and":[{"v.resource":"test-resource-action-webhook-8"}]}&with_steps=true
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "v": {
            "ticket": {
              "_t": "declareticket",
              "a": "system",
              "val": "test3",
              "data": {
                "test_val": "test1"
              }
            },
            "steps": [
              {
                "_t": "stateinc"
              },
              {
                "_t": "statusinc"
              },
              {
                "_t": "declareticket",
                "a": "system"
              }
            ],
            "connector": "test-connector-action-webhook-8",
            "connector_name": "test-connector-name-action-webhook-8",
            "component": "test-component-action-webhook-8",
            "resource": "test-resource-action-webhook-8"
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
