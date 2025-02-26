Feature: Export alarm metrics
  I need to be able to export alarm metrics
  Only admin should be able to export alarm metrics

  Scenario: given export request should return metrics
    When I am admin
    When I do POST /api/v4/cat/metrics-export/alarm:
    """json
    {
      "parameters": [
        {"metric": "created_alarms"}
      ],
      "filter": "test-kpi-filter-to-alarm-metrics-get",
      "sampling": "day",
      "from": {{ parseTimeTz "20-11-2021 00:00" }},
      "to": {{ parseTimeTz "24-11-2021 00:00" }}
    }
    """
    Then the response code should be 200
    When I save response exportID={{ .lastResponse._id }}
    When I do GET /api/v4/cat/metrics-export/{{ .exportID }} until response code is 200 and body contains:
    """json
    {
       "status": 1
    }
    """
    When I do GET /api/v4/cat/metrics-export/{{ .exportID }}/download
    Then the response code should be 200
    Then the response raw body should be:
    """csv
    metric,timestamp,value
    created_alarms,{{ parseTimeTz "20-11-2021 00:00" }},0
    created_alarms,{{ parseTimeTz "21-11-2021 00:00" }},1
    created_alarms,{{ parseTimeTz "22-11-2021 00:00" }},3
    created_alarms,{{ parseTimeTz "23-11-2021 00:00" }},3
    created_alarms,{{ parseTimeTz "24-11-2021 00:00" }},0

    """

  Scenario: given export request with empty interval should return metrics with zeros
    When I am admin
    When I do POST /api/v4/cat/metrics-export/alarm:
    """json
    {
      "parameters": [
        {"metric": "created_alarms"}
      ],
      "filter": "test-kpi-filter-to-alarm-metrics-get",
      "sampling": "day",
      "from": {{ parseTimeTz "06-09-2020 00:00" }},
      "to": {{ parseTimeTz "08-09-2020 00:00" }}
    }
    """
    Then the response code should be 200
    When I save response exportID={{ .lastResponse._id }}
    When I do GET /api/v4/cat/metrics-export/{{ .exportID }} until response code is 200 and body contains:
    """json
    {
       "status": 1
    }
    """
    When I do GET /api/v4/cat/metrics-export/{{ .exportID }}/download
    Then the response code should be 200
    Then the response raw body should be:
    """csv
    metric,timestamp,value
    created_alarms,{{ parseTimeTz "06-09-2020 00:00" }},0
    created_alarms,{{ parseTimeTz "07-09-2020 00:00" }},0
    created_alarms,{{ parseTimeTz "08-09-2020 00:00" }},0

    """

  Scenario: given export request with filter by entity infos should return metrics
    When I am admin
    When I do POST /api/v4/cat/metrics-export/alarm:
    """json
    {
      "parameters": [
        {"metric": "created_alarms"}
      ],
      "filter": "test-kpi-filter-to-alarm-metrics-get-by-entity-infos",
      "sampling": "day",
      "from": {{ parseTimeTz "20-11-2021 00:00" }},
      "to": {{ parseTimeTz "24-11-2021 00:00" }}
    }
    """
    Then the response code should be 200
    When I save response exportID={{ .lastResponse._id }}
    When I do GET /api/v4/cat/metrics-export/{{ .exportID }} until response code is 200 and body contains:
    """json
    {
       "status": 1
    }
    """
    When I do GET /api/v4/cat/metrics-export/{{ .exportID }}/download
    Then the response code should be 200
    Then the response raw body should be:
    """csv
    metric,timestamp,value
    created_alarms,{{ parseTimeTz "20-11-2021 00:00" }},0
    created_alarms,{{ parseTimeTz "21-11-2021 00:00" }},0
    created_alarms,{{ parseTimeTz "22-11-2021 00:00" }},3
    created_alarms,{{ parseTimeTz "23-11-2021 00:00" }},2
    created_alarms,{{ parseTimeTz "24-11-2021 00:00" }},0

    """

  Scenario: given export request with invalid query params should return bad request
    When I am admin
    When I do POST /api/v4/cat/metrics-export/alarm
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "from": "From is missing.",
        "parameters": "Parameters is missing.",
        "sampling": "Sampling is missing.",
        "to": "To is missing."
      }
    }
    """
    When I do POST /api/v4/cat/metrics-export/alarm:
    """json
    {
      "filter": "not-exist",
      "parameters": [
        {"metric": "created_alarms"}
      ],
      "sampling": "day",
      "from": {{ nowDateTz }},
      "to": {{ nowDateTz }}
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
    When I do POST /api/v4/cat/metrics-export/alarm:
    """json
    {
      "parameters": [
        {"metric": "not-exist"}
      ],
      "sampling": "day",
      "from": {{ nowDateTz }},
      "to": {{ nowDateTz }}
    }
    """
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "parameters.0.metric": "Metric doesn't exist."
      }
    }
    """
    When I do POST /api/v4/cat/metrics-export/alarm:
    """json
    {
      "parameters": [
        {"metric": "total_user_activity"}
      ],
      "sampling": "day",
      "from": {{ nowDateTz }},
      "to": {{ nowDateTz }}
    }
    """
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "parameters.0.metric": "Metric doesn't exist."
      }
    }
    """
    When I do POST /api/v4/cat/metrics-export/alarm:
    """json
    {
      "sampling": "not-exist",
      "parameters": [
        {"metric": "created_alarms"}
      ],
      "from": {{ nowDateTz }},
      "to": {{ nowDateTz }}
    }
    """
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "sampling": "Sampling must be one of [hour day week month]."
      }
    }
    """

  Scenario: given export request and no auth user should not allow access
    When I do POST /api/v4/cat/metrics-export/alarm
    Then the response code should be 401

  Scenario: given export request and auth user without permissions should not allow access
    When I am noperms
    When I do POST /api/v4/cat/metrics-export/alarm
    Then the response code should be 403

  Scenario: given export request with all parameters should return all metrics
    When I am admin
    When I do POST /api/v4/cat/metrics-export/alarm:
    """json
    {
      "parameters": [
        {"metric": "created_alarms"},
        {"metric": "active_alarms"},
        {"metric": "non_displayed_alarms"},
        {"metric": "instruction_alarms"},
        {"metric": "pbehavior_alarms"},
        {"metric": "correlation_alarms"},
        {"metric": "ack_alarms"},
        {"metric": "cancel_ack_alarms"},
        {"metric": "ack_active_alarms"},
        {"metric": "ticket_active_alarms"},
        {"metric": "without_ticket_active_alarms"},
        {"metric": "ratio_correlation"},
        {"metric": "ratio_instructions"},
        {"metric": "ratio_tickets"},
        {"metric": "ratio_non_displayed"},
        {"metric": "average_ack"},
        {"metric": "average_resolve"}
      ],
      "filter": "test-kpi-filter-to-all-alarm-metrics-get",
      "sampling": "day",
      "from": {{ parseTimeTz "22-11-2021 00:00" }},
      "to": {{ parseTimeTz "24-11-2021 00:00" }}
    }
    """
    Then the response code should be 200
    When I save response exportID={{ .lastResponse._id }}
    When I do GET /api/v4/cat/metrics-export/{{ .exportID }} until response code is 200 and body contains:
    """json
    {
       "status": 1
    }
    """
    When I do GET /api/v4/cat/metrics-export/{{ .exportID }}/download
    Then the response code should be 200
    Then the response raw body should be:
    """csv
    metric,timestamp,value
    created_alarms,{{ parseTimeTz "22-11-2021 00:00" }},0
    created_alarms,{{ parseTimeTz "23-11-2021 00:00" }},3
    created_alarms,{{ parseTimeTz "24-11-2021 00:00" }},0
    active_alarms,{{ parseTimeTz "22-11-2021 00:00" }},0
    active_alarms,{{ parseTimeTz "23-11-2021 00:00" }},3
    active_alarms,{{ parseTimeTz "24-11-2021 00:00" }},3
    non_displayed_alarms,{{ parseTimeTz "22-11-2021 00:00" }},0
    non_displayed_alarms,{{ parseTimeTz "23-11-2021 00:00" }},1
    non_displayed_alarms,{{ parseTimeTz "24-11-2021 00:00" }},0
    instruction_alarms,{{ parseTimeTz "22-11-2021 00:00" }},0
    instruction_alarms,{{ parseTimeTz "23-11-2021 00:00" }},1
    instruction_alarms,{{ parseTimeTz "24-11-2021 00:00" }},0
    pbehavior_alarms,{{ parseTimeTz "22-11-2021 00:00" }},0
    pbehavior_alarms,{{ parseTimeTz "23-11-2021 00:00" }},1
    pbehavior_alarms,{{ parseTimeTz "24-11-2021 00:00" }},0
    correlation_alarms,{{ parseTimeTz "22-11-2021 00:00" }},0
    correlation_alarms,{{ parseTimeTz "23-11-2021 00:00" }},1
    correlation_alarms,{{ parseTimeTz "24-11-2021 00:00" }},0
    ack_alarms,{{ parseTimeTz "22-11-2021 00:00" }},0
    ack_alarms,{{ parseTimeTz "23-11-2021 00:00" }},2
    ack_alarms,{{ parseTimeTz "24-11-2021 00:00" }},0
    cancel_ack_alarms,{{ parseTimeTz "22-11-2021 00:00" }},0
    cancel_ack_alarms,{{ parseTimeTz "23-11-2021 00:00" }},1
    cancel_ack_alarms,{{ parseTimeTz "24-11-2021 00:00" }},0
    ack_active_alarms,{{ parseTimeTz "22-11-2021 00:00" }},0
    ack_active_alarms,{{ parseTimeTz "23-11-2021 00:00" }},1
    ack_active_alarms,{{ parseTimeTz "24-11-2021 00:00" }},1
    ticket_active_alarms,{{ parseTimeTz "22-11-2021 00:00" }},0
    ticket_active_alarms,{{ parseTimeTz "23-11-2021 00:00" }},1
    ticket_active_alarms,{{ parseTimeTz "24-11-2021 00:00" }},1
    without_ticket_active_alarms,{{ parseTimeTz "22-11-2021 00:00" }},0
    without_ticket_active_alarms,{{ parseTimeTz "23-11-2021 00:00" }},2
    without_ticket_active_alarms,{{ parseTimeTz "24-11-2021 00:00" }},2
    ratio_correlation,{{ parseTimeTz "22-11-2021 00:00" }},0
    ratio_correlation,{{ parseTimeTz "23-11-2021 00:00" }},33.33
    ratio_correlation,{{ parseTimeTz "24-11-2021 00:00" }},33.33
    ratio_instructions,{{ parseTimeTz "22-11-2021 00:00" }},0
    ratio_instructions,{{ parseTimeTz "23-11-2021 00:00" }},33.33
    ratio_instructions,{{ parseTimeTz "24-11-2021 00:00" }},33.33
    ratio_tickets,{{ parseTimeTz "22-11-2021 00:00" }},0
    ratio_tickets,{{ parseTimeTz "23-11-2021 00:00" }},33.33
    ratio_tickets,{{ parseTimeTz "24-11-2021 00:00" }},33.33
    ratio_non_displayed,{{ parseTimeTz "22-11-2021 00:00" }},0
    ratio_non_displayed,{{ parseTimeTz "23-11-2021 00:00" }},33.33
    ratio_non_displayed,{{ parseTimeTz "24-11-2021 00:00" }},33.33
    average_ack,{{ parseTimeTz "22-11-2021 00:00" }},0
    average_ack,{{ parseTimeTz "23-11-2021 00:00" }},500
    average_ack,{{ parseTimeTz "24-11-2021 00:00" }},0
    average_resolve,{{ parseTimeTz "22-11-2021 00:00" }},0
    average_resolve,{{ parseTimeTz "23-11-2021 00:00" }},1000
    average_resolve,{{ parseTimeTz "24-11-2021 00:00" }},0

    """
