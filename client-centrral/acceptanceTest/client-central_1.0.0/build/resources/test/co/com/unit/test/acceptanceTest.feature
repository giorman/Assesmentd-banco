# We suggest to consulting the Karate Framework documentation: https://github.com/intuit/karate
@acceptanceTest
Feature: Consultar y gestionar los clientes

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

  Scenario: Consulta un cliente
    Given path 'client-central-information/retrieve'
    And request requestRetrieve
    When method post
    Then status 200
    * string strResponse = response
    * string strRequest = requestRetrieve
    * def report = ValidatorTestUtils.validateSchema(oasUrl,strRequest, strResponse, 'retrieve', ValidatorTestUtils.POST, 200)
    * if (report.hasErrors()) karate.fail(report.getMessages()+ ' - '+ strRequest + ' - '+ strResponse)


  Scenario: Consulta una lista de clientes
    Given path 'client-central-information/retrieveList'
    And request requestRetrieveList
    When method post
    Then status 200
    * string strResponse = response
    * string strRequest = requestRetrieveList
    * def report = ValidatorTestUtils.validateSchema(oasUrl,strRequest, strResponse, 'retrieveList', ValidatorTestUtils.POST, 200)
    * if (report.hasErrors()) karate.fail(report.getMessages()+ ' - '+ strRequest + ' - '+ strResponse)


  Scenario: Crea un cliente
    Given path 'client-central-management/create'
    And request requestCreate
    When method post
    Then status 201
    * string strResponse = response
    * string strRequest = requestCreate
    * def report = ValidatorTestUtils.validateSchema(oasUrl2,strRequest, strResponse, 'create', ValidatorTestUtils.POST, 201)
    * if (report.hasErrors()) karate.fail(report.getMessages()+ ' - '+ strRequest + ' - '+ strResponse)
    And match response.data.description == 'El cliente fue creado'


  Scenario: Modifica un cliente
    Given path 'client-central-management/modify'
    And request requestModify
    When method post
    Then status 200
    * string strResponse = response
    * string strRequest = requestModify
    * def report = ValidatorTestUtils.validateSchema(oasUrl2,strRequest, strResponse, 'modify', ValidatorTestUtils.POST, 200)
    * if (report.hasErrors()) karate.fail(report.getMessages()+ ' - '+ strRequest + ' - '+ strResponse)
    And match response.data.description == 'El cliente fue modificado'



