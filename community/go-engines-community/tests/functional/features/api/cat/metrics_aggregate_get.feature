Feature: Get alarm metrics
  I need to be able to get alarm metrics
  Only admin should be able to get alarm metrics

  @concurrent
  Scenario: given get aggregated number type of metric by hour request should return aggregated results
    When I am admin
    When I do POST /api/v4/cat/metrics/aggregate:
    """json
    {
      "from": {{ parseTimeTz "23-11-2021 00:00" }},
      "to": {{ parseTimeTz "23-11-2021 00:00" }},
      "sampling": "hour",
      "filter": "test-kpi-filter-to-alarm-metrics-get",
      "parameters": [
        {
          "metric": "created_alarms",
          "aggregate_func": "sum"
        },
        {
          "metric": "created_alarms",
          "aggregate_func": "max"
        },
        {
          "metric": "created_alarms",
          "aggregate_func": "min"
        },
        {
          "metric": "created_alarms",
          "aggregate_func": "avg"
        }
      ]
    }
    """
    Then the response code should be 200
    Then the response body should be:
    """json
    {
      "data": [
        {
          "title": "created_alarms",
          "value": 3,
          "aggregate_func": "sum"
        },
        {
          "title": "created_alarms",
          "value": 1,
          "aggregate_func": "max"
        },
        {
          "title": "created_alarms",
          "value": 1,
          "aggregate_func": "min"
        },
        {
          "title": "created_alarms",
          "value": 1,
          "aggregate_func": "avg"
        }
      ],
      "meta": {
        "min_date": {{ parseTimeTz "01-07-2021 00:00" }}
      }
    }
    """

  @concurrent
  Scenario: given get aggregated cumulative type of metric by hour request should return aggregated results
    When I am admin
    When I do POST /api/v4/cat/metrics/aggregate:
    """json
    {
      "from": {{ parseTimeTz "23-11-2021 00:00" }},
      "to": {{ parseTimeTz "23-11-2021 00:00" }},
      "sampling": "hour",
      "filter": "test-kpi-filter-to-alarm-metrics-get",
      "parameters": [
        {
          "metric": "active_alarms",
          "aggregate_func": "max"
        },
        {
          "metric": "active_alarms",
          "aggregate_func": "min"
        },
        {
          "metric": "active_alarms",
          "aggregate_func": "avg"
        }
      ]
    }
    """
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "title": "active_alarms",
          "value": 6,
          "aggregate_func": "max"
        },
        {
          "title": "active_alarms",
          "value": 5,
          "aggregate_func": "min"
        },
        {
          "title": "active_alarms",
          "value": 5.58,
          "aggregate_func": "avg"
        }
      ]
    }
    """

  @concurrent
  Scenario: given get aggregated subtraction type of metric by hour request should return aggregated results
    When I am admin
    When I do POST /api/v4/cat/metrics/aggregate:
    """json
    {
      "from": {{ parseTimeTz "23-11-2021 00:00" }},
      "to": {{ parseTimeTz "23-11-2021 00:00" }},
      "sampling": "hour",
      "filter": "test-kpi-filter-to-all-alarm-metrics-get",
      "parameters": [
        {
          "metric": "without_ticket_active_alarms",
          "aggregate_func": "avg"
        },
        {
          "metric": "without_ticket_active_alarms",
          "aggregate_func": "max"
        },
        {
          "metric": "without_ticket_active_alarms",
          "aggregate_func": "min"
        }
      ]
    }
    """
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "title": "without_ticket_active_alarms",
          "value": 1.79,
          "aggregate_func": "avg"
        },
        {
          "title": "without_ticket_active_alarms",
          "value": 2,
          "aggregate_func": "max"
        },
        {
          "title": "without_ticket_active_alarms",
          "value": 0,
          "aggregate_func": "min"
        }
      ]
    }
    """

  @concurrent
  Scenario: given get aggregated ratio metric by hour request should return aggregated results
    When I am admin
    When I do POST /api/v4/cat/metrics/aggregate:
    """json
    {
      "from": {{ parseTimeTz "23-11-2021 00:00" }},
      "to": {{ parseTimeTz "23-11-2021 00:00" }},
      "filter": "test-kpi-filter-to-alarm-metrics-get",
      "sampling": "day",
      "parameters": [
        {
          "metric": "ratio_tickets"
        }
      ]
    }
    """
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "title": "ratio_tickets",
          "value": 16.66
        }
      ]
    }
    """

  @concurrent
  Scenario: given get aggregated duration metric by hour request should return aggregated results
    When I am admin
    When I do POST /api/v4/cat/metrics/aggregate:
    """json
    {
      "from": {{ parseTimeTz "23-11-2021 00:00" }},
      "to": {{ parseTimeTz "23-11-2021 00:00" }},
      "filter": "test-kpi-filter-to-all-alarm-metrics-get",
      "parameters": [
        {
          "metric": "time_to_ack",
          "aggregate_func": "sum"
        },
        {
          "metric": "time_to_ack",
          "aggregate_func": "max"
        },
        {
          "metric": "time_to_ack",
          "aggregate_func": "min"
        },
        {
          "metric": "time_to_ack",
          "aggregate_func": "avg"
        }
      ]
    }
    """
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "title": "time_to_ack",
          "value": 1000,
          "aggregate_func": "sum"
        },
        {
          "title": "time_to_ack",
          "value": 600,
          "aggregate_func": "max"
        },
        {
          "title": "time_to_ack",
          "value": 400,
          "aggregate_func": "min"
        },
        {
          "title": "time_to_ack",
          "value": 500,
          "aggregate_func": "avg"
        }
      ]
    }
    """

  @concurrent
  Scenario: given get aggregated request with widget filters should return aggregated results
    When I am admin
    When I do POST /api/v4/cat/metrics/aggregate:
    """json
    {
      "from": {{ parseTimeTz "23-11-2021 00:00" }},
      "to": {{ parseTimeTz "23-11-2021 00:00" }},
      "sampling": "hour",
      "widget_filters": [
        "test-widget-filter-to-alarm-metrics-get-1"
      ],
      "parameters": [
        {
          "metric": "created_alarms",
          "aggregate_func": "sum"
        },
        {
          "metric": "created_alarms",
          "aggregate_func": "max"
        },
        {
          "metric": "created_alarms",
          "aggregate_func": "min"
        },
        {
          "metric": "created_alarms",
          "aggregate_func": "avg"
        }
      ]
    }
    """
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "data": [
        {
          "title": "created_alarms",
          "value": 3,
          "aggregate_func": "sum"
        },
        {
          "title": "created_alarms",
          "value": 1,
          "aggregate_func": "max"
        },
        {
          "title": "created_alarms",
          "value": 1,
          "aggregate_func": "min"
        },
        {
          "title": "created_alarms",
          "value": 1,
          "aggregate_func": "avg"
        }
      ]
    }
    """

  @concurrent
  Scenario: given get aggregated created_alarms without sampling should return error
    When I am admin
    When I do POST /api/v4/cat/metrics/aggregate:
    """json
    {
      "from": {{ parseTimeTz "23-11-2021 00:00" }},
      "to": {{ parseTimeTz "23-11-2021 00:00" }},
      "filter": "test-kpi-filter-to-alarm-metrics-get",
      "parameters": [
        {
          "metric": "created_alarms",
          "aggregate_func": "sum"
        }
      ]
    }
    """
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "sampling": "Sampling is missing."
      }
    }
    """

  @concurrent
  Scenario: given get aggregated created_alarms with unsupported metric should return error
    When I am admin
    When I do POST /api/v4/cat/metrics/aggregate:
    """json
    {
      "from": {{ parseTimeTz "23-11-2021 00:00" }},
      "to": {{ parseTimeTz "23-11-2021 00:00" }},
      "sampling": "hour",
      "filter": "test-kpi-filter-to-alarm-metrics-get",
      "parameters": [
        {
          "metric": "total_user_activity",
          "aggregate_func": "sum"
        }
      ]
    }
    """
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "parameters.0.metric": "Metric is not supported."
      }
    }
    """

  @concurrent
  Scenario: given get aggregated created_alarms with not found kpi filter should return error
    When I am admin
    When I do POST /api/v4/cat/metrics/aggregate:
    """json
    {
      "from": {{ parseTimeTz "23-11-2021 00:00" }},
      "to": {{ parseTimeTz "23-11-2021 00:00" }},
      "sampling": "hour",
      "filter": "test-kpi-filter-not-found",
      "parameters": [
        {
          "metric": "created_alarms",
          "aggregate_func": "sum"
        }
      ]
    }
    """
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "filter": "Filter doesn't exist."
      }
    }
    """

  @concurrent
  Scenario: given get aggregated created_alarms with not found widget filter should return error
    When I am admin
    When I do POST /api/v4/cat/metrics/aggregate:
    """json
    {
      "from": {{ parseTimeTz "23-11-2021 00:00" }},
      "to": {{ parseTimeTz "23-11-2021 00:00" }},
      "sampling": "hour",
      "widget_filters": [
        "test-widget-filter-not-found"
      ],
      "parameters": [
        {
          "metric": "created_alarms",
          "aggregate_func": "sum"
        }
      ]
    }
    """
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "widget_filters.0": "WidgetFilter doesn't exist."
      }
    }
    """

  @concurrent
  Scenario: given get aggregated created_alarms with both filters should return error
    When I am admin
    When I do POST /api/v4/cat/metrics/aggregate:
    """json
    {
      "from": {{ parseTimeTz "23-11-2021 00:00" }},
      "to": {{ parseTimeTz "23-11-2021 00:00" }},
      "filter": "test-kpi-filter-to-alarm-metrics-get",
      "sampling": "hour",
      "widget_filters": [
        "test-widget-filter-to-alarm-metrics-get-1"
      ],
      "parameters": [
        {
          "metric": "created_alarms",
          "aggregate_func": "sum"
        }
      ]
    }
    """
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "widget_filters": "Can't be present both WidgetFilters and KpiFilter."
      }
    }
    """

  @concurrent
  Scenario: given get aggregated number metric without aggregate function should return error
    When I am admin
    When I do POST /api/v4/cat/metrics/aggregate:
    """json
    {
      "from": {{ parseTimeTz "23-11-2021 00:00" }},
      "to": {{ parseTimeTz "23-11-2021 00:00" }},
      "sampling": "hour",
      "filter": "test-kpi-filter-to-alarm-metrics-get",
      "parameters": [
        {
          "metric": "active_alarms"
        }
      ]
    }
    """
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "parameters.0.aggregate_func": "AggregateFunc is missing."
      }
    }
    """

  @concurrent
  Scenario: given get aggregated cumulative number metric with sum aggregate function should return error
    When I am admin
    When I do POST /api/v4/cat/metrics/aggregate:
    """json
    {
      "from": {{ parseTimeTz "23-11-2021 00:00" }},
      "to": {{ parseTimeTz "23-11-2021 00:00" }},
      "sampling": "hour",
      "filter": "test-kpi-filter-to-alarm-metrics-get",
      "parameters": [
        {
          "metric": "active_alarms",
          "aggregate_func": "sum"
        }
      ]
    }
    """
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "parameters.0.aggregate_func": "AggregateFunc must be one of [avg, max, min]."
      }
    }
    """

  @concurrent
  Scenario: given get aggregated subtraction type of metric with sum function should return error
    When I am admin
    When I do POST /api/v4/cat/metrics/aggregate:
    """json
    {
      "from": {{ parseTimeTz "23-11-2021 00:00" }},
      "to": {{ parseTimeTz "23-11-2021 00:00" }},
      "sampling": "hour",
      "filter": "test-kpi-filter-to-alarm-metrics-get",
      "parameters": [
        {
          "metric": "without_ticket_active_alarms",
          "aggregate_func": "sum"
        }
      ]
    }
    """
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "parameters.0.aggregate_func": "AggregateFunc must be one of [avg, max, min]."
      }
    }
    """

  @concurrent
  Scenario: given get aggregated metric with invalid function should return error
    When I am admin
    When I do POST /api/v4/cat/metrics/aggregate:
    """json
    {
      "from": {{ parseTimeTz "23-11-2021 00:00" }},
      "to": {{ parseTimeTz "23-11-2021 00:00" }},
      "sampling": "hour",
      "filter": "test-kpi-filter-to-alarm-metrics-get",
      "parameters": [
        {
          "metric": "without_ticket_active_alarms",
          "aggregate_func": "qwe"
        }
      ]
    }
    """
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "parameters.0.aggregate_func": "AggregateFunc must be one of [sum last avg min max] or empty."
      }
    }
    """

  @concurrent
  Scenario: given get aggregated ratio metric with aggregate function should return error
    When I am admin
    When I do POST /api/v4/cat/metrics/aggregate:
    """json
    {
      "from": {{ parseTimeTz "23-11-2021 00:00" }},
      "to": {{ parseTimeTz "23-11-2021 00:00" }},
      "sampling": "hour",
      "filter": "test-kpi-filter-to-alarm-metrics-get",
      "parameters": [
        {
          "metric": "ratio_tickets",
          "aggregate_func": "sum"
        }
      ]
    }
    """
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "parameters.0.aggregate_func": "AggregateFunc is not empty."
      }
    }
    """

  @concurrent
  Scenario: given get request and no auth user should not allow access
    When I do POST /api/v4/cat/metrics/aggregate
    Then the response code should be 401

  @concurrent
  Scenario: given get request and auth user without permissions should not allow access
    When I am noperms
    When I do POST /api/v4/cat/metrics/aggregate
    Then the response code should be 403
