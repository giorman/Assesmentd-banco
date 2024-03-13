# We suggest to consulting the Karate Framework documentation: https://github.com/intuit/karate
@acceptanceTest
Feature: Validar y gestionar los usuarios.

  Background:
    * url urlBase
    * def oasUrl = oasUrl
    * configure headers = headers
    * def ValidatorTestUtils = Java.type('co.com.unit.utils.ValidatorTestUtils')
    * ValidatorTestUtils.setContentType(headers.accept);
    * def requestAccess = read('access.json')
    * def requestValidate = read('validate.json')
    * def requestCreate = read('create.json')
    * def requestModify = read('modify.json')
    * def requestDelete = read('delete.json')

  Scenario:  Valida las credenciales de un usuario
    Given path 'access'
    And request requestAccess
    When method post
    Then status 200
    * string strResponse = response
    * string strRequest = requestAccess
    * def report = ValidatorTestUtils.validateSchema(oasUrl,strRequest, strResponse, 'access', ValidatorTestUtils.POST, 200)
    * if (report.hasErrors()) karate.fail(report.getMessages()+ ' - '+ strRequest + ' - '+ strResponse)
    And match response.data.description == 'Autenticacion Exitosa'

  Scenario: Valida si un cliente tiene un usuario asociado
    Given path 'validate'
    And request requestValidate
    When method post
    Then status 200
    * string strResponse = response
    * string strRequest = requestValidate
    * def report = ValidatorTestUtils.validateSchema(oasUrl,strRequest, strResponse, 'validate', ValidatorTestUtils.POST, 200)
    * if (report.hasErrors()) karate.fail(report.getMessages()+ ' - '+ strRequest + ' - '+ strResponse)
    And match response.data.description == 'Validacion Exitosa'

  Scenario:  Crear un usuario
    Given path 'create'
    And request requestCreate
    When method post
    Then status 201
    * string strResponse = response
    * string strRequest = requestCreate
    * def report = ValidatorTestUtils.validateSchema(oasUrl,strRequest, strResponse, 'create', ValidatorTestUtils.POST, 201)
    * if (report.hasErrors()) karate.fail(report.getMessages()+ ' - '+ strRequest + ' - '+ strResponse)
    And match response.data.description == 'El usuario fue creado'

  Scenario: Modificar un usuario
    Given path 'modify'
    And request requestModify
    When method post
    Then status 200
    * string strResponse = response
    * string strRequest = requestModify
    * def report = ValidatorTestUtils.validateSchema(oasUrl,strRequest, strResponse, 'modify', ValidatorTestUtils.POST, 200)
    * if (report.hasErrors()) karate.fail(report.getMessages()+ ' - '+ strRequest + ' - '+ strResponse)
    And match response.data.description == 'La contraseña fue modificada'

  Scenario: Eliminar un usuario
    Given path 'delete'
    And request requestDelete
    When method post
    Then status 200
    * string strResponse = response
    * string strRequest = requestDelete
    * def report = ValidatorTestUtils.validateSchema(oasUrl,strRequest, strResponse, 'delete', ValidatorTestUtils.POST, 200)
    * if (report.hasErrors()) karate.fail(report.getMessages()+ ' - '+ strRequest + ' - '+ strResponse)
    And match response.data.description == 'El usuario fue eliminado'

