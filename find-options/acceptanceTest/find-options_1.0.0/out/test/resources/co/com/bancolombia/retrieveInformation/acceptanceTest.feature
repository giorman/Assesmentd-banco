# We suggest to consulting the Karate Framework documentation: https://github.com/intuit/karate
@acceptanceTest
Feature: Consultar los grupos de productos asociados por cliente para Entitlement


  Background:
    * url urlBase
    * def oasUrl = oasUrl
    * configure headers = headers
    And set headers.channel = 'SVP'
    * def ValidatorTestUtils = Java.type('co.com.bancolombia.utils.ValidatorTestUtils')
    * ValidatorTestUtils.setContentType(headers.Accept);
    * def requestRetrieveInformation = read('retrieveInformation.json')

  Scenario: Consulta exitosa
    Given path 'retrieveRelations'
    And request requestRetrieveInformation
    And set headers.channel = 'SVP'
    * set requestRetrieveInformation.data.identity.alias = 'TESTAPICPR357AZV'
    * set requestRetrieveInformation.data.identity.AID = 'A074A2E33025949D8905902DDD618A059'
    When method post
    Then status 200
    * string strResponse = response
    * def report = ValidatorTestUtils.validateResponseSchema(oasUrl, strResponse, 'retrieveRelations', ValidatorTestUtils.POST, 200)
    * if (report.hasErrors()) karate.fail(report.getMessages() + ' - '+ strResponse)
    And match response.data == read('retrieveInformationqa200.json').data

  Scenario Outline: <ESCENARIO_DE_NEGOCIO>
    Given path 'retrieveRelations'
    And request requestRetrieveInformation
    And set headers.channel = '<VALUE_HEADER_CHANNEL_CODE>'
    And set requestRetrieveInformation.data.identity.alias   = '<ALIAS>'
    And set requestRetrieveInformation.data.identity.AID = '<AID>'
    When method post
    Then status <CODE_HTTP>
    * string strResponse = response
    * def report = ValidatorTestUtils.validateResponseSchema(oasUrl, strResponse, 'retrieveRelations', ValidatorTestUtils.POST, <CODE_HTTP>)
    * if (report.hasErrors()) karate.fail(report.getMessages() + ' - '+ strResponse)
    And match response.errors[0].detail == '<DETAIL>'
    And match response.errors[0].code == '<CODE_ERROR>'
    Examples:
      | ESCENARIO_DE_NEGOCIO | ALIAS           | AID                               | VALUE_HEADER_CHANNEL_CODE | DETAIL                                         | CODE_ERROR | CODE_HTTP |
      | Identidad no existe  | TESTAPICPR26FJK | AQ12A6030965464099F930965464099F9 | SVP                       | Registro no encontrado.                        | BPER409-51 | 409       |
      | No hay relación      | MAGRS18DE13     | A1019291F70174874AD68D7164F63A0A5 | SVP                       | No se encuentran registros de relacionamiento. | BPER409-52 | 409       |