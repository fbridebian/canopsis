Feature: Update a user
  I need to be able to update a user
  Only admin should be able to update a user

  Scenario: given update request should update user
    When I am admin
    Then I do PUT /api/v4/users/test-user-to-update-1:
    """json
    {
      "name": "test-user-to-update-1-updated",
      "firstname": "test-user-to-update-1-firstname-updated",
      "lastname": "test-user-to-update-1-lastname-updated",
      "email": "test-user-to-update-1-email-updated@canopsis.net",
      "roles": [
        "test-role-to-user-edit-2",
        "test-role-to-user-edit-1"
      ],
      "ui_language": "fr",
      "ui_theme": "canopsis",
      "ui_groups_navigation_type": "top-bar",
      "enable": true,
      "defaultview": "test-view-to-edit-user"
    }
    """
    Then the response code should be 200
    Then the response body should be:
    """json
    {
      "_id": "test-user-to-update-1",
      "authkey": "5ez4e3jj-7e1e-5c2g-0e91-e079f72o6424",
      "defaultview": {
        "_id": "test-view-to-edit-user",
        "title": "test-view-to-edit-user-title"
      },
      "email": "test-user-to-update-1-email-updated@canopsis.net",
      "enable": true,
      "external_id": "",
      "firstname": "test-user-to-update-1-firstname-updated",
      "lastname": "test-user-to-update-1-lastname-updated",
      "name": "test-user-to-update-1-updated",
      "display_name": "test-user-to-update-1-updated test-user-to-update-1-firstname-updated test-user-to-update-1-lastname-updated test-user-to-update-1-email-updated@canopsis.net",
      "roles": [
        {
          "_id": "test-role-to-user-edit-2",
          "name": "test-role-to-user-edit-2",
          "defaultview": {
            "_id": "test-view-to-edit-user",
            "title": "test-view-to-edit-user-title"
          }
        },
        {
          "_id": "test-role-to-user-edit-1",
          "name": "test-role-to-user-edit-1",
          "defaultview": {
            "_id": "test-view-to-edit-user",
            "title": "test-view-to-edit-user-title"
          }
        }
      ],
      "source": "",
      "ui_groups_navigation_type": "top-bar",
      "ui_language": "fr",
      "ui_theme": "canopsis"
    }
    """

  Scenario: given update request with password should auth user by base auth
    When I am admin
    Then I do PUT /api/v4/users/test-user-to-update-2:
    """json
    {
      "password": "test-password-updated",
      "name": "test-user-to-update-2",
      "firstname": "test-user-to-update-2-firstname-updated",
      "lastname": "test-user-to-update-2-lastname-updated",
      "email": "test-user-to-update-2-email-updated@canopsis.net",
      "roles": [
        "test-role-to-user-edit-1"
      ],
      "ui_language": "fr",
      "ui_theme": "canopsis",
      "ui_groups_navigation_type": "top-bar",
      "enable": true,
      "defaultview": "test-view-to-edit-user"
    }
    """
    When I am authenticated with username "test-user-to-update-2" and password "test-password-updated"
    When I do GET /api/v4/account/me
    Then the response code should be 200
    Then the response body should contain:
    """json
    {
      "_id": "test-user-to-update-2",
      "name": "test-user-to-update-2"
    }
    """

  Scenario: given get request and no auth user should not allow access
    When I do PUT /api/v4/users/test-user-to-update
    Then the response code should be 401

  Scenario: given get request and auth user by api key without permissions should not allow access
    When I am noperms
    When I do PUT /api/v4/users/test-user-to-update
    Then the response code should be 403

  Scenario: given invalid update request should return errors
    When I am admin
    When I do PUT /api/v4/users/test-user-to-update:
    """json
    {
      "roles": [
        "test-role-to-user-edit-1",
        "not-exist"
      ],
      "defaultview": "not-exist"
    }
    """
    Then the response code should be 400
    Then the response body should be:
    """json
    {
      "errors": {
        "defaultview": "DefaultView doesn't exist.",
        "email": "Email is missing.",
        "enable": "IsEnabled is missing.",
        "name": "Name is missing.",
        "roles": "Roles doesn't exist."
      }
    }
    """

  Scenario: given update request with not exist id should return not found error
    When I am admin
    When I do PUT /api/v4/users/test-user-not-found:
    """json
    {
      "name": "test-user-to-update-name",
      "firstname": "test-user-to-update-firstname-updated",
      "lastname": "test-user-to-update-lastname-updated",
      "email": "test-user-to-update-email-updated@canopsis.net",
      "roles": [
        "test-role-to-user-edit-1"
      ],
      "ui_language": "fr",
      "ui_theme": "canopsis",
      "groups_navigation_type": "top-bar",
      "enable": true,
      "defaultview": "test-view-to-edit-user"
    }
    """
    Then the response code should be 404
    Then the response body should be:
    """json
    {
      "error": "Not found"
    }
    """

  Scenario: given create request with already exists name should return error
    When I am admin
    When I do PUT /api/v4/users/notexit:
    """json
    {
      "name": "test-user-to-check-unique-name-name"
    }
    """
    Then the response code should be 400
    Then the response body should contain:
    """json
    {
      "errors": {
          "name": "Name already exists."
      }
    }
    """

  Scenario: given create request with already exists id should return error
    When I am admin
    When I do PUT /api/v4/users/notexit:
    """json
    {
      "name": "test-user-to-check-unique-name"
    }
    """
    Then the response code should be 400
    Then the response body should contain:
    """json
    {
      "errors": {
          "name": "Name already exists."
      }
    }
    """

  Scenario: given update request with source and external_id shouldn't update these fields
    When I am admin
    Then I do PUT /api/v4/users/test-user-to-update-3:
    """json
    {
      "name": "test-user-to-update-3-updated",
      "firstname": "test-user-to-update-3-firstname-updated",
      "lastname": "test-user-to-update-3-lastname-updated",
      "email": "test-user-to-update-3-email-updated@canopsis.net",
      "roles": [
        "test-role-to-user-edit-1"
      ],
      "ui_language": "fr",
      "ui_groups_navigation_type": "top-bar",
      "enable": true,
      "defaultview": "test-view-to-edit-user",
      "source": "ldap",
      "external_id": "ldap_id"
    }
    """
    Then the response code should be 200
    Then the response body should be:
    """json
    {
      "_id": "test-user-to-update-3",
      "authkey": "5ez4e3jj-7e1e-5c2g-0e91-e079f72o6424",
      "defaultview": {
        "_id": "test-view-to-edit-user",
        "title": "test-view-to-edit-user-title"
      },
      "email": "test-user-to-update-3-email-updated@canopsis.net",
      "enable": true,
      "firstname": "test-user-to-update-3-firstname-updated",
      "lastname": "test-user-to-update-3-lastname-updated",
      "name": "test-user-to-update-3-updated",
      "display_name": "test-user-to-update-3-updated test-user-to-update-3-firstname-updated test-user-to-update-3-lastname-updated test-user-to-update-3-email-updated@canopsis.net",
      "roles": [
        {
          "_id": "test-role-to-user-edit-1",
          "name": "test-role-to-user-edit-1",
          "defaultview": {
            "_id": "test-view-to-edit-user",
            "title": "test-view-to-edit-user-title"
          }
        }
      ],
      "ui_theme": "",
      "ui_groups_navigation_type": "top-bar",
      "ui_language": "fr",
      "source": "saml",
      "external_id": "saml_id"
    }
    """

  Scenario: given update request with bad password should return error
    When I am admin
    Then I do PUT /api/v4/users/test-user-to-update-4:
    """json
    {
      "name": "test-user-to-update-4-updated",
      "firstname": "test-user-to-update-4-firstname-updated",
      "lastname": "test-user-to-update-4-lastname-updated",
      "email": "test-user-to-update-4-email-updated@canopsis.net",
      "roles": [
        "test-role-to-user-edit-1"
      ],
      "ui_language": "fr",
      "ui_groups_navigation_type": "top-bar",
      "enable": true,
      "defaultview": "test-view-to-edit-user",
      "password": "123"
    }
    """
    Then the response code should be 400
    Then the response body should contain:
    """json
    {
      "errors": {
          "password": "Password should be 8 or more."
      }
    }
    """
