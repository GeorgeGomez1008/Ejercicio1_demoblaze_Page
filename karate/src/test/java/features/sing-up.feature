Feature: Validate the registration and login functionalities of the demoblaze.com page

  Scenario: Register new user
    Given url baseUrl
    * def validateRequest = read('classpath:request/requestSingUp.json')
    And path '/signup'
    And request validateRequest
    When method post
    Then status 200
    * def actualResponse = response
    * def expectedResponse = ""
    * karate.match(actualResponse, expectedResponse)

  Scenario: Register user has been created
    Given url baseUrl
    * def validateRequest = read('classpath:request/requestSingUp.json')
    And path '/signup'
    And request validateRequest
    When method post
    Then status 200
    And match response.errorMessage == "This user already exist."

  Scenario: Log in with correct username and password
    Given url baseUrl
    * def validateRequest = read('classpath:request/requestSingUp.json')
    And path '/login'
    And request validateRequest
    When method post
    Then status 200
    And match response.errorMessage == null

  Scenario: Log in with incorrect username and password
    Given url baseUrl
    * def validateRequest = read('classpath:request/BadRequestSingUp.json')
    And path '/login'
    And request validateRequest
    When method post
    Then status 200
    And match response.errorMessage == "User does not exist."