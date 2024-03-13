# We suggest to consulting the Karate Framework documentation: https://github.com/intuit/karate
@accceptanceTest
Feature: Consultar lo clientes con los productos que se ajustan a su perfil

  Background:
    * url urlBase
    * def oasUrl = oasUrl
    * configure headers = headers
    * def ValidatorTestUtils = Java.type('co.com.unit.utils.ValidatorTestUtils')
    * ValidatorTestUtils.setContentType(headers.accept);
    * def requestRetrieve = read('retrieve.json')
    * def requestRetrieveList = read('retrieveList.json')

  Scenario: Consulta un cliente con los productos que se ajustan a su perfil
    Given path 'retrieve'
    And request requestRetrieve
    When method post
    Then status 200
    * string strResponse = response
    * string strRequest = requestRetrieve
    * def report = ValidatorTestUtils.validateSchema(oasUrl,strRequest, strResponse, 'retrieve', ValidatorTestUtils.POST, 200)
    * if (report.hasErrors()) karate.fail(report.getMessages()+ ' - '+ strRequest + ' - '+ strResponse)


  Scenario: Consulta una lista de clientes con los productos que se ajustan a su perfil
    Given path 'retrieveList'
    And request requestRetrieveList
    When method post
    Then status 200
    * string strResponse = response
    * string strRequest = requestRetrieveList
    * def report = ValidatorTestUtils.validateSchema(oasUrl,strRequest, strResponse, 'retrieveList', ValidatorTestUtils.POST, 200)
    * if (report.hasErrors()) karate.fail(report.getMessages()+ ' - '+ strRequest + ' - '+ strResponse)


