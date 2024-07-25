Feature: Gestionar Mascotas en la API Pet Store

  Background:
    * url 'https://petstore.swagger.io/v2'
    * def data = read('../json/data.json')
    * def id = data.id


  Scenario: Adicionar, Verificar, Modificar y Eliminar una mascota
    Given path '/pet'
    And request data.post
    When method post
    Then status 200

    Given path '/pet/',id
    When method get
    Then status 200
    And match response.name == data.post.name
    * karate.log('id: ',id)

    Given path '/pet'
    And request data.put
    When method put
    Then status 200

    Given path '/pet/1'
    When method get
    Then status 200
    And match response.name == data.put.name

    Given path '/pet', id
    When method delete
    Then status 200
