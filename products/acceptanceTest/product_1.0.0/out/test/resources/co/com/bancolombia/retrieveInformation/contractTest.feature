# We suggest to consulting the Karate Framework documentation: https://github.com/intuit/karate
@contractTest
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
    And set headers.channel = 'NEG'
    When method post
    Then status 200
    * string strResponse = response
    * def report = ValidatorTestUtils.validateResponseSchema(oasUrl, strResponse, 'retrieveRelationsDetail', ValidatorTestUtils.POST, 200)
    * if (report.hasErrors()) karate.fail(report.getMessages() + ' - '+ strResponse)
    And match response.data == read('retrieveInformation200.json').data




  Scenario Outline: DADO que se desea validar el esquema del request CUANDO no cumple con las longitudes en el header <FIELD_NAME> ENTONCES se espera un status 400 por mensaje mal formado
    Given path 'retrieveRelations'
    And set headers.<FIELD_NAME> = '<VALUE>'
    And request requestRetrieveInformation
    When method post
    Then status 400
    * string strResponse = response
    * def report = ValidatorTestUtils.validateResponseSchema(oasUrl, strResponse, 'retrieveRelations', ValidatorTestUtils.POST, 400)
    * if (report.hasErrors()) karate.fail(report.getMessages() + ' - '+ strResponse)
    And match response.errors[0].detail == '<DETAIL>'
    Examples:
      | FIELD_NAME | VALUE                                               | DETAIL                          |
      | channel    | SVPPPP                                              | Longitud de channel invalida    |
      | channel    |                                                     | Variable channel indefinida     |
      | message-id |                                                     | Variable message-id indefinida  |
      | message-id | 41ea2c08-422f-497a-8abe-9de3064539cb-8abe-9de306453 | Longitud de message-id invalida |


  Scenario Outline: DADO que se desea validar el esquema del request CUANDO el campo <FIELD_NAME> tiene un tipo de dato incorrecto ENTONCES se espera un status 400 por parametro string o numerico invalido
    Given path 'retrieveRelations'
    And request requestRetrieveInformation
    * set requestRetrieveInformation.data.<FIELD_NAME> = <INVALID_VALUE>
    When method post
    Then status 400
    * string strResponse = response
    * def report = ValidatorTestUtils.validateResponseSchema(oasUrl, strResponse, 'retrieveRelations', ValidatorTestUtils.POST, 400)
    * if (report.hasErrors()) karate.fail(report.getMessages() + ' - '+ strResponse)
    And match response.errors[0].detail == '<DETAIL>'
    And match response.errors[0].code == '<CODE_ERROR>'
    Examples:
      | FIELD_NAME     | INVALID_VALUE | DETAIL                          | CODE_ERROR |
      | identity.alias | '***'         | Parametro String alias invalido | SA400      |
      | identity.AID   | '+++'         | Parametro String AID invalido   | SA400      |


  Scenario Outline: DADO que se desea validar el esquema del request CUANDO el campo <FIELD_NAME> tiene una longitud  incorrecta ENTONCES se espera un status 400 por parametro string o numerico invalido
    Given path 'retrieveRelations'
    And request requestRetrieveInformation
    * set requestRetrieveInformation.data.<FIELD_NAME> = <INVALID_VALUE>
    When method post
    Then status 400
    * string strResponse = response
    * def report = ValidatorTestUtils.validateResponseSchema(oasUrl, strResponse, 'retrieveRelations', ValidatorTestUtils.POST, 400)
    * if (report.hasErrors()) karate.fail(report.getMessages() + ' - '+ strResponse)
    And match response.errors[0].detail == '<DETAIL>'
    And match response.errors[0].code == '<CODE_ERROR>'
    Examples:
      | FIELD_NAME     | INVALID_VALUE                                         | DETAIL                     | CODE_ERROR |
      | identity.alias | 'asdasdassdsadiuwhwqjkdskjasdkasbdjkqwhdjqbwdkjqnwdq' | Longitud de alias invalida | SA400      |
      | identity.AID   | 'qeqweasdasdqwdasdwqdqwdqwdqwdqwdqwqwsdwqd'           | Longitud de AID invalida   | SA400      |


  Scenario: Consulta fallida cuando no se envia identity en el body
    Given path 'retrieveRelations'
    And request requestRetrieveInformation
    And remove requestRetrieveInformation.data.identity
    When method post
    Then status 400
    * string strResponse = response
    * def report = ValidatorTestUtils.validateResponseSchema(oasUrl, strResponse, 'retrieveRelationsDetail', ValidatorTestUtils.POST, 400)
    * if (report.hasErrors()) karate.fail(report.getMessages() + ' - '+ strResponse)
    And match response.errors[0].detail == 'Objecto identity requerido'


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
      | ESCENARIO_DE_NEGOCIO                  | ALIAS | AID                               | VALUE_HEADER_CHANNEL_CODE | DETAIL                                         | CODE_ERROR | CODE_HTTP |
      | Identidad no existe                   |       | A14B95A1FF68D415DAE998F6BACA3C832 | SVP                       | Registro no encontrado.                        | BPER409-51 | 409       |
      | No hay relación                       |       | A14B95A1FF68D415DAE998F6BACA3C832 | SUID                      | No se encuentran registros de relacionamiento. | BPER409-52 | 409       |
      | Faltan parámetros                     |       |                                   | SUID                      | Faltan parámetros obligatorios.                | BPER400-03 | 400       |
      | Consumidor no se encuentra registrado |       |                                   | S                         | El consumidor no se encuentra registrado.      | BPER409-36 | 409       |