# We suggest to consulting the Karate Framework documentation: https://github.com/intuit/karate
@acceptanceTest
Feature: Consultar la información que contiene un grupo y productos asociados en Entitlement


  Background:
    * url urlBase
    * def oasUrl = oasUrl
    * configure headers = headers
    And set headers.channel = 'NEG'
    * def ValidatorTestUtils = Java.type('co.com.bancolombia.utils.ValidatorTestUtils')
    * ValidatorTestUtils.setContentType(headers.Accept);
    * def requestRetrieveRelationsDetail = read('retrieveInformationDetail.json')

  Scenario: Consulta exitosa
    Given path 'retrieveRelationsDetail'
    And request requestRetrieveRelationsDetail
    And set headers.channel = 'NEG'
    And set headers.aid-creator = 'A55D98270E6BE49B6AA1B31276C22B7B8'
    * set requestRetrieveRelationsDetail.data.channel.code = 'NEG'
    * set requestRetrieveRelationsDetail.data.delegate.identification.type = 'TIPDOC_FS001'
    * set requestRetrieveRelationsDetail.data.delegate.identification.number = '1029384756'
    * set requestRetrieveRelationsDetail.data.owner.identification.type = 'TIPDOC_FS001'
    * set requestRetrieveRelationsDetail.data.owner.identification.number = '1029384756'
    When method post
    Then status 200
    * string strResponse = response
    * def report = ValidatorTestUtils.validateResponseSchema(oasUrl, strResponse, 'retrieveRelationsDetail', ValidatorTestUtils.POST, 200)
    * if (report.hasErrors()) karate.fail(report.getMessages() + ' - '+ strResponse)
    And match response.data.relations.identity.AIDCreator =='A55D98270E6BE49B6AA1B31276C22B7B8'
    And match response.data.relations.identity.AID =='A55D98270E6BE49B6AA1B31276C22B7B8'
    And match response.data.relations.identifier =='REL6OMETH7A6T3Z9K8N'
    And match response.data.relations.status =='Activo'



  Scenario Outline: <ESCENARIO_DE_NEGOCIO>
    Given path 'retrieveRelationsDetail'
    And request requestRetrieveRelationsDetail
    And set headers.aid-creator = '<VALUE_HEADER_AID_CREATOR>'
    And set headers.channel = '<VALUE_HEADER_CHANNEL_CODE>'
    And set requestRetrieveRelationsDetail.data.channel.code   = '<CHANNEL_CODE>'
    And set requestRetrieveRelationsDetail.data..delegate.identification.type = '<DELEGATE_TYPE>'
    And set requestRetrieveRelationsDetail.data.delegate.identification.number = '<DELEGATE_NUMBER>'
    And set requestRetrieveRelationsDetail.data.owner.identification.type = '<OWNER_TYPE>'
    And set requestRetrieveRelationsDetail.data.owner.identification.number = '<OWNER_NUMBER>'
    When method post
    Then status <CODE_HTTP>
    * string strResponse = response
    * def report = ValidatorTestUtils.validateResponseSchema(oasUrl, strResponse, 'retrieveRelationsDetail', ValidatorTestUtils.POST, <CODE_HTTP>)
    * if (report.hasErrors()) karate.fail(report.getMessages() + ' - '+ strResponse)
    And match response.errors[0].detail == '<DETAIL>'
    And match response.errors[0].code == '<CODE_ERROR>'
    Examples:
      | ESCENARIO_DE_NEGOCIO           | DELEGATE_TYPE | DELEGATE_NUMBER | OWNER_TYPE   | OWNER_NUMBER | CHANNEL_CODE | VALUE_HEADER_AID_CREATOR          | VALUE_HEADER_CHANNEL_CODE | DETAIL                                         | CODE_ERROR  | CODE_HTTP |
      | No hay relación                | TIPDOC_FS001  | 1998244204      | TIPDOC_FS003 | 912810007    | SVN          |                                   | SVN                       | No se encuentran registros de relacionamiento. | BPER409-52  | 409       |
      | Faltan parámetros obligatorios | TIPDOC_FS001  | 65987414        | TIPDOC_FS003 | 3216547841   | PSE          |                                   | SVP                       | Faltan parámetros obligatorios del consumidor  | BPER409-118 | 409       |
      | Consumidor no autorizado       | TIPDOC_FS001  | 1998244204      | TIPDOC_FS003 | 912810007    | PSE          | A55D98270E6BE49B6AA1B31276C22B7B8 | SVP                       | Consumidor no autorizado                       | BPER409-119 | 409       |







