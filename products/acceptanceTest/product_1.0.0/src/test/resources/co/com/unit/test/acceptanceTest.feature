# We suggest to consulting the Karate Framework documentation: https://github.com/intuit/karate
@acceptanceTest
Feature: Consultar y gestionar los productos o servicios

  Background:
    * url urlBase
    * def oasUrl = oasUrl
    * def oasUrl2 = oasUrl2
    * configure headers = headers
    * def ValidatorTestUtils = Java.type('co.com.unit.utils.ValidatorTestUtils')
    * ValidatorTestUtils.setContentType(headers.accept);
    * def requestRetrieve = read('retrieve.json')
    * def requestRetrieveList = read('retrieveList.json')
    * def requestCreate = read('create.json')
    * def requestModify = read('modify.json')
    * def requestDelete = read('delete.json')

  Scenario: Consulta un producto o servicio
    Given path 'product-information/retrieve'
    And request requestRetrieve
    When method post
    Then status 200
    * string strResponse = response
    * string strRequest = requestRetrieve
    * def report = ValidatorTestUtils.validateSchema(oasUrl,strRequest, strResponse, 'retrieve', ValidatorTestUtils.POST, 200)
    * if (report.hasErrors()) karate.fail(report.getMessages()+ ' - '+ strRequest + ' - '+ strResponse)


  Scenario: Consulta una lista de productos o servicios
    Given path 'product-information/retrieveList'
    And request requestRetrieveList
    When method post
    Then status 200
    * string strResponse = response
    * string strRequest = requestRetrieveList
    * def report = ValidatorTestUtils.validateSchema(oasUrl,strRequest, strResponse, 'retrieveList', ValidatorTestUtils.POST, 200)
    * if (report.hasErrors()) karate.fail(report.getMessages()+ ' - '+ strRequest + ' - '+ strResponse)


  Scenario: Crea un producto o servicio
    Given path 'product-management/create'
    And request requestCreate
    When method post
    Then status 201
    * string strResponse = response
    * string strRequest = requestCreate
    * def report = ValidatorTestUtils.validateSchema(oasUrl2,strRequest, strResponse, 'create', ValidatorTestUtils.POST, 201)
    * if (report.hasErrors()) karate.fail(report.getMessages()+ ' - '+ strRequest + ' - '+ strResponse)
    And match response.data.description == 'El producto fue creado'


  Scenario: Modifica un producto o servicio
    Given path 'product-management/modify'
    And request requestModify
    When method post
    Then status 200
    * string strResponse = response
    * string strRequest = requestModify
    * def report = ValidatorTestUtils.validateSchema(oasUrl2,strRequest, strResponse, 'modify', ValidatorTestUtils.POST, 200)
    * if (report.hasErrors()) karate.fail(report.getMessages()+ ' - '+ strRequest + ' - '+ strResponse)
    And match response.data.description == 'El producto fue modificado'


  Scenario: Elimina un producto o servicio
    Given path 'product-management/delete'
    And request requestDelete
    When method post
    Then status 200
    * string strResponse = response
    * string strRequest = requestDelete
    * def report = ValidatorTestUtils.validateSchema(oasUrl2,strRequest, strResponse,'delete', ValidatorTestUtils.POST, 200)
    * if (report.hasErrors()) karate.fail(report.getMessages()+ ' - '+ strRequest + ' - '+ strResponse)
    And match response.data.description == 'El producto fue eliminado'

