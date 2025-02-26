Feature: Count matches
  I need to be able to count matches by patterns
  Only admin should be able to count matches by patterns

  @standalone
  Scenario: given count request should return counts
    When I am admin
    When I send an event and wait the end of event processing:
    """json
    [
      {
        "connector": "test-connector-pbehavior-pattern-count-1",
        "connector_name": "test-connector-name-pbehavior-pattern-count-1",
        "source_type": "resource",
        "event_type": "check",
        "component": "test-component-pbehavior-pattern-count-1",
        "resource": "test-resource-pbehavior-pattern-count-1-1",
        "state": 1,
        "output": "noveo alarm"
      },
      {
        "connector": "test-connector-pbehavior-pattern-count-1",
        "connector_name": "test-connector-name-pbehavior-pattern-count-1",
        "source_type": "resource",
        "event_type": "check",
        "component": "test-component-pbehavior-pattern-count-1",
        "resource": "test-resource-pbehavior-pattern-count-1-2",
        "state": 1,
        "output": "noveo alarm"
      },
      {
        "connector": "test-connector-pbehavior-pattern-count-1",
        "connector_name": "test-connector-name-pbehavior-pattern-count-1",
        "source_type": "resource",
        "event_type": "check",
        "component": "test-component-pbehavior-pattern-count-1",
        "resource": "test-resource-pbehavior-pattern-count-1-3",
        "state": 1,
        "output": "noveo alarm"
      },
      {
        "connector": "test-connector-pbehavior-pattern-count-1",
        "connector_name": "test-connector-name-pbehavior-pattern-count-1",
        "source_type": "resource",
        "event_type": "check",
        "component": "test-component-pbehavior-pattern-count-1",
        "resource": "test-resource-pbehavior-pattern-count-1-4",
        "state": 1,
        "output": "noveo alarm"
      },
      {
        "connector": "test-connector-pbehavior-pattern-count-1",
        "connector_name": "test-connector-name-pbehavior-pattern-count-1",
        "source_type": "resource",
        "event_type": "check",
        "component": "test-component-pbehavior-pattern-count-1",
        "resource": "test-resource-pbehavior-pattern-count-1-5",
        "state": 0,
        "output": "noveo alarm"
      }
    ]
    """
    When I do POST /api/v4/pbehaviors:
    """json
    {
      "enabled": true,
      "name": "test-pbehavior-pattern-count-1",
      "tstart": {{ now }},
      "tstop": {{ nowAdd "1h" }},
      "color": "#FFFFFF",
      "type": "test-maintenance-type-to-engine",
      "reason": "test-reason-to-engine",
      "entity_pattern": [
        [
          {
            "field": "type",
            "cond": {
              "type": "eq",
              "value": "resource"
            }
          },
          {
            "field": "component",
            "cond": {
              "type": "eq",
              "value": "test-component-pbehavior-pattern-count-1"
            }
          }
        ]
      ]
    }
    """
    Then the response code should be 201
    When I save response pbehaviorID={{ .lastResponse._id }}
    Then I wait the end of events processing which contain:
    """json
    [
      {
        "event_type": "pbhenter",
        "connector": "test-connector-pbehavior-pattern-count-1",
        "connector_name": "test-connector-name-pbehavior-pattern-count-1",
        "component": "test-component-pbehavior-pattern-count-1",
        "resource": "test-resource-pbehavior-pattern-count-1-1",
        "source_type": "resource"
      },
      {
        "event_type": "pbhenter",
        "connector": "test-connector-pbehavior-pattern-count-1",
        "connector_name": "test-connector-name-pbehavior-pattern-count-1",
        "component": "test-component-pbehavior-pattern-count-1",
        "resource": "test-resource-pbehavior-pattern-count-1-2",
        "source_type": "resource"
      },
      {
        "event_type": "pbhenter",
        "connector": "test-connector-pbehavior-pattern-count-1",
        "connector_name": "test-connector-name-pbehavior-pattern-count-1",
        "component": "test-component-pbehavior-pattern-count-1",
        "resource": "test-resource-pbehavior-pattern-count-1-3",
        "source_type": "resource"
      },
      {
        "event_type": "pbhenter",
        "connector": "test-connector-pbehavior-pattern-count-1",
        "connector_name": "test-connector-name-pbehavior-pattern-count-1",
        "component": "test-component-pbehavior-pattern-count-1",
        "resource": "test-resource-pbehavior-pattern-count-1-4",
        "source_type": "resource"
      },
      {
        "event_type": "pbhenter",
        "connector": "test-connector-pbehavior-pattern-count-1",
        "connector_name": "test-connector-name-pbehavior-pattern-count-1",
        "component": "test-component-pbehavior-pattern-count-1",
        "resource": "test-resource-pbehavior-pattern-count-1-5",
        "source_type": "resource"
      }
    ]
    """
    When I do PUT /api/v4/internal/user_interface:
    """json
    {
      "max_matched_items": 5
    }
    """
    Then the response code should be 200
    Then I wait 2s
    When I am noperms
    When I do POST /api/v4/patterns-alarms-count:
    """json
    {
      "pbehavior_pattern": [
        [
          {
            "field": "pbehavior_info.id",
            "cond": {
              "type": "eq",
              "value": "{{ .pbehaviorID }}"
            }
          }
        ]
      ]
    }
    """
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "pbehavior_pattern": {
        "count": 4,
        "over_limit": false
      },
      "all": {
        "count": 4,
        "over_limit": false
      },
      "entities": {
        "count": 0,
        "over_limit": false
      }
    }
    """
    When I do POST /api/v4/patterns-entities-count:
    """json
    {
      "pbehavior_pattern": [
        [
          {
            "field": "pbehavior_info.id",
            "cond": {
              "type": "eq",
              "value": "{{ .pbehaviorID }}"
            }
          }
        ]
      ]
    }
    """
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "pbehavior_pattern": {
        "count": 5,
        "over_limit": false
      },
      "all": {
        "count": 5,
        "over_limit": false
      }
    }
    """
    When I am admin
    When I do PUT /api/v4/internal/user_interface:
    """json
    {
      "max_matched_items": 3
    }
    """
    Then the response code should be 200
    Then I wait 2s
    When I am noperms
    When I do POST /api/v4/patterns-alarms-count:
    """json
    {
      "pbehavior_pattern": [
        [
          {
            "field": "pbehavior_info.id",
            "cond": {
              "type": "eq",
              "value": "{{ .pbehaviorID }}"
            }
          }
        ]
      ]
    }
    """
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "pbehavior_pattern": {
        "count": 4,
        "over_limit": true
      },
      "all": {
        "count": 4,
        "over_limit": true
      },
      "entities": {
        "count": 0,
        "over_limit": false
      }
    }
    """
    When I do POST /api/v4/patterns-entities-count:
    """json
    {
      "pbehavior_pattern": [
        [
          {
            "field": "pbehavior_info.id",
            "cond": {
              "type": "eq",
              "value": "{{ .pbehaviorID }}"
            }
          }
        ]
      ]
    }
    """
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "pbehavior_pattern": {
        "count": 5,
        "over_limit": true
      },
      "all": {
        "count": 5,
        "over_limit": true
      }
    }
    """

  @concurrent
  Scenario: given count requests for pbh reasons
    When I am admin
    When I send an event and wait the end of event processing:
    """json
    [
      {
        "connector": "test-connector-pbehavior-pattern-count-2",
        "connector_name": "test-connector-name-pbehavior-pattern-count-2",
        "source_type": "resource",
        "event_type": "check",
        "component": "test-component-pbehavior-pattern-count-2",
        "resource": "test-resource-pbehavior-pattern-count-2-1",
        "state": 1,
        "output": "noveo alarm"
      },
      {
        "connector": "test-connector-pbehavior-pattern-count-2",
        "connector_name": "test-connector-name-pbehavior-pattern-count-2",
        "source_type": "resource",
        "event_type": "check",
        "component": "test-component-pbehavior-pattern-count-2",
        "resource": "test-resource-pbehavior-pattern-count-2-2",
        "state": 1,
        "output": "noveo alarm"
      }
    ]
    """
    When I do POST /api/v4/pbehaviors:
    """json
    {
      "enabled": true,
      "name": "test-pbehavior-pattern-count-2",
      "tstart": {{ now }},
      "tstop": {{ nowAdd "1h" }},
      "color": "#FFFFFF",
      "type": "test-maintenance-type-to-engine",
      "reason": "test-reason-to-engine-3",
      "entity_pattern": [
        [
          {
            "field": "name",
            "cond": {
              "type": "eq",
              "value": "test-resource-pbehavior-pattern-count-2-1"
            }
          }
        ],
        [
          {
            "field": "name",
            "cond": {
              "type": "eq",
              "value": "test-resource-pbehavior-pattern-count-2-2"
            }
          }
        ]
      ]
    }
    """
    Then the response code should be 201
    Then I wait the end of events processing which contain:
    """json
    [
      {
        "event_type": "pbhenter",
        "connector": "test-connector-pbehavior-pattern-count-2",
        "connector_name": "test-connector-name-pbehavior-pattern-count-2",
        "component": "test-component-pbehavior-pattern-count-2",
        "resource": "test-resource-pbehavior-pattern-count-2-1",
        "source_type": "resource"
      },
      {
        "event_type": "pbhenter",
        "connector": "test-connector-pbehavior-pattern-count-2",
        "connector_name": "test-connector-name-pbehavior-pattern-count-2",
        "component": "test-component-pbehavior-pattern-count-2",
        "resource": "test-resource-pbehavior-pattern-count-2-2",
        "source_type": "resource"
      }
    ]
    """
    Then I wait 2s
    When I do POST /api/v4/patterns-alarms-count:
    """json
    {
      "entity_pattern": [
        [
          {
            "field": "name",
            "cond": {
              "type": "eq",
              "value": "test-resource-pbehavior-pattern-count-2-1"
            }
          }
        ],
        [
          {
            "field": "name",
            "cond": {
              "type": "eq",
              "value": "test-resource-pbehavior-pattern-count-2-2"
            }
          }
        ]
      ],
      "pbehavior_pattern": [
        [
          {
            "field": "pbehavior_info.reason",
            "cond": {
              "type": "eq",
              "value": "test-reason-to-engine-3"
            }
          }
        ]
      ]
    }
    """
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "pbehavior_pattern": {
        "count": 2,
        "over_limit": false
      },
      "all": {
        "count": 2,
        "over_limit": false
      }
    }
    """
    When I do POST /api/v4/patterns-alarms-count:
    """json
    {
      "pbehavior_pattern": [
        [
          {
            "field": "pbehavior_info.reason",
            "cond": {
              "type": "eq",
              "value": "test-reason-to-engine-not-exist"
            }
          }
        ]
      ]
    }
    """
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "pbehavior_pattern": {
        "count": 0,
        "over_limit": false
      },
      "all": {
        "count": 0,
        "over_limit": false
      }
    }
    """
