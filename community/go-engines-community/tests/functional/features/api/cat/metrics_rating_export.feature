Feature: Export metrics rating
  I need to be able to export metrics rating
  Only admin should be able to export metrics rating

  Scenario: given export request should return metrics
    When I am admin
    When I do POST /api/v4/cat/metrics-export/rating?metric=created_alarms&criteria=2&from={{ parseTimeTz "20-11-2021 00:00" }}&to={{ parseTimeTz "23-11-2021 00:00" }}&filter=test-kpi-filter-to-metrics-rating-get
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
    label,value
    test-entity-to-metrics-rating-get-1,3
    test-entity-to-metrics-rating-get-2,1
    test-entity-to-metrics-rating-get-3,1

    """

  Scenario: given export with filter by entity infos request should return metrics
    When I am admin
    When I do POST /api/v4/cat/metrics-export/rating?metric=created_alarms&criteria=1&from={{ parseTimeTz "20-11-2021 00:00" }}&to={{ parseTimeTz "23-11-2021 00:00" }}&filter=test-kpi-filter-to-metrics-rating-get-by-entity-infos
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
    label,value
    test-entity-to-metrics-rating-get-2,1

    """

  Scenario: given export request with invalid query params should return bad request
    When I am admin
    When I do POST /api/v4/cat/metrics-export/rating
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "criteria": "Criteria is missing.",
        "from": "From is missing.",
        "metric": "Metric is missing.",
        "to": "To is missing."
      }
    }
    """
    When I do POST /api/v4/cat/metrics-export/rating?metric=not-exist&from={{ nowDateTz }}&to={{ nowDateTz }}&criteria=1
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "metric": "Metric doesn't exist."
      }
    }
    """
    When I do POST /api/v4/cat/metrics-export/rating?criteria=1000000&metric=created_alarms&from={{ nowDateTz }}&to={{ nowDateTz }}
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "criteria": "Criteria doesn't exist."
      }
    }
    """
    When I do POST /api/v4/cat/metrics-export/rating?filter=not-exist&from={{ nowDateTz }}&to={{ nowDateTz }}&metric=created_alarms&criteria=1
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "filter": "Filter doesn't exist."
      }
    }
    """
    When I do POST /api/v4/cat/metrics-export/rating?metric=created_alarms&criteria=3&from={{ nowDateTz }}&to={{ nowDateTz }}
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "criteria": "Criteria doesn't exist."
      }
    }
    """
    When I do POST /api/v4/cat/metrics-export/rating?metric=total_user_activity&criteria=1&from={{ nowDateTz }}&to={{ nowDateTz }}
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "criteria": "Criteria doesn't exist."
      }
    }
    """
    When I do POST /api/v4/cat/metrics-export/rating?metric=total_user_activity&filter=test-kpi-filter-to-metrics-rating-get&criteria=3&from={{ nowDateTz }}&to={{ nowDateTz }}
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "filter": "Filter is not empty."
      }
    }
    """

  Scenario: given export request and no auth user should not allow access
    When I do POST /api/v4/cat/metrics-export/rating
    Then the response code should be 401

  Scenario: given export request and auth user without permissions should not allow access
    When I am noperms
    When I do POST /api/v4/cat/metrics-export/rating
    Then the response code should be 403
