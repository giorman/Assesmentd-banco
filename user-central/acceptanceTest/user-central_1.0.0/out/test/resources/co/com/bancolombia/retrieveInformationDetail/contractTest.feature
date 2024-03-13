# We suggest to consulting the Karate Framework documentation: https://github.com/intuit/karate
@contractTest
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
    And set headers.channel = 'SVN'
    When method post
    Then status 200
    * string strResponse = response
    * def report = ValidatorTestUtils.validateResponseSchema(oasUrl, strResponse, 'retrieveRelationsDetail', ValidatorTestUtils.POST, 200)
    * if (report.hasErrors()) karate.fail(report.getMessages() + ' - '+ strResponse)
    And match response.data.relations.identity.AIDCreator =='A9C64CA09C7DE469C8160F8E308BAD057'
    And match response.data.relations.identity.AID =='A177115BA9DEA47449925BF4645770000'
    And match response.data.relations.identifier =='RELDATACAPA00000003'
    And match response.data.relations.status =='Activo'


  Scenario Outline: DADO que se desea validar el esquema del request CUANDO no se envia el header <FIELD_NAME> ENTONCES se espera un status 400 por mensaje mal formado
    Given path 'retrieveRelationsDetail'
    And remove headers.<FIELD_NAME>
    And request requestRetrieveRelationsDetail
    When method post
    Then status 400
    * string strResponse = response
    * def report = ValidatorTestUtils.validateResponseSchema(oasUrl, strResponse, 'retrieveRelationsDetail', ValidatorTestUtils.POST, 400)
    * if (report.hasErrors()) karate.fail(report.getMessages() + ' - '+ strResponse)
    And match response.errors[0].detail == '<DETAIL>'
    Examples:
      | FIELD_NAME | DETAIL                         |
      | channel    | Variable channel indefinida    |
      | message-id | Variable message-id indefinida |


  Scenario Outline: DADO que se desea validar el esquema del request CUANDO no cumple con las longitudes en el header <FIELD_NAME> ENTONCES se espera un status 400 por mensaje mal formado
    Given path 'retrieveRelationsDetail'
    And set headers.<FIELD_NAME> = '<VALUE>'
    And request requestRetrieveRelationsDetail
    When method post
    Then status 400
    * string strResponse = response
    * def report = ValidatorTestUtils.validateResponseSchema(oasUrl, strResponse, 'retrieveRelationsDetail', ValidatorTestUtils.POST, 400)
    * if (report.hasErrors()) karate.fail(report.getMessages() + ' - '+ strResponse)
    And match response.errors[0].detail == '<DETAIL>'
    Examples:
      | FIELD_NAME  | VALUE                                               | DETAIL                           |
      | aid-creator | A798ED08B09CA491AAF2670713DB410971                  | Longitud de aid-creator invalida |
      | aid-creator | A798ED08B09CA491AAF2670713DB4109                    | Longitud de aid-creator invalida |
      | channel     | SVPPPP                                              | Longitud de channel invalida     |
      | channel     |                                                     | Variable channel indefinida      |
      | message-id  |                                                     | Variable message-id indefinida   |
      | message-id  | 41ea2c08-422f-497a-8abe-9de3064539cb-8abe-9de306453 | Longitud de message-id invalida  |



   Scenario Outline: Consulta fallida cuando no se envia <FIELD_NAME> en el body
    Given path 'retrieveRelationsDetail'
    And request requestRetrieveRelationsDetail
    And remove requestRetrieveRelationsDetail.data.<FIELD_NAME>
    When method post
    Then status 400
    * string strResponse = response
    * def report = ValidatorTestUtils.validateResponseSchema(oasUrl, strResponse, 'retrieveRelationsDetail', ValidatorTestUtils.POST, 400)
    * if (report.hasErrors()) karate.fail(report.getMessages() + ' - '+ strResponse)
    And match response.errors[0].detail == '<DETAIL>'
    Examples:
      | FIELD_NAME                     | DETAIL                                             |
      | channel                        | Objecto channel requerido                          |
      | channel.code                   | Variable channel.code indefinida                   |
      | delegate                       | Objecto delegate requerido                         |
      | delegate.identification        | Objecto identification requerido                   |
      | delegate.identification.type   | Variable delegate.identification.type indefinida   |
      | delegate.identification.number | Variable delegate.identification.number indefinida |
      | owner                          | Objecto owner requerido                            |
      | owner.identification           | Objecto identification requerido                   |
      | owner.identification.type      | Variable owner.identification.type indefinida      |
      | owner.identification.number    | Variable owner.identification.number indefinida    |



  Scenario Outline: DADO que se desea validar el esquema del request CUANDO el campo <FIELD_NAME> tiene un tipo de dato incorrecto ENTONCES se espera un status 400 por parametro string o numerico invalido
    Given path 'retrieveRelationsDetail'
    And request requestRetrieveRelationsDetail
    * set requestRetrieveRelationsDetail.data.<FIELD_NAME> = <INVALID_VALUE>
    When method post
    Then status 400
    * string strResponse = response
    * def report = ValidatorTestUtils.validateResponseSchema(oasUrl, strResponse, 'retrieveRelationsDetail', ValidatorTestUtils.POST, <STATUS>)
    * if (report.hasErrors()) karate.fail(report.getMessages() + ' - '+ strResponse)
    And match response.errors[0].detail == '<DETAIL>'
    And match response.errors[0].code == '<CODE_ERROR>'
    Examples:
      | FIELD_NAME                     | INVALID_VALUE         | DETAIL                                              | CODE_ERROR | STATUS |
      | channel.code                   | 'NEG2'                | Uno o más datos no poseen un valor válido.          | SAER400-35 | 400    |
      | channel.code                   | 'NEGGGG'              | Longitud de channel.code invalida                   | SA400      | 400    |
      | channel.code                   | ''                    | Variable channel.code indefinida                    | SA400      | 400    |
      | delegate.identification.type   | 'TIPDOC_FS0022'       | Longitud de delegate.identification.type invalida   | SA400      | 400    |
      | delegate.identification.type   | ''                    | Variable delegate.identification.type indefinida    | SA400      | 400    |
      | delegate.identification.number | '1804270432132423432' | Longitud de delegate.identification.number invalida | SA400      | 400    |
      | delegate.identification.number | ''                    | Variable delegate.identification.number indefinida  | SA400      | 400    |
      | owner.identification.type      | 'TIPDOC_FS0012'       | Longitud de owner.identification.type invalida      | SA400      | 400    |
      | owner.identification.type      | ''                    | Variable owner.identification.type indefinida       | SA400      | 400    |
      | owner.identification.number    | '180427043217123123'  | Longitud de owner.identification.number invalida    | SA400      | 400    |
      | owner.identification.number    | ''                    | Variable owner.identification.number indefinida     | SA400      | 400    |


  Scenario Outline: DADO que se desea validar el esquema del request CUANDO el campo <FIELD_NAME> tiene un tipo de dato incorrecto ENTONCES se espera un status 400 por parametro string o numerico invalido
    Given path 'retrieveRelationsDetail'
    And set headers.aid-creator = 'A61E86D2CA25A41E8A23249C38D28DA1C'
    And request requestRetrieveRelationsDetail
    * set requestRetrieveRelationsDetail.data.<FIELD_NAME> = <INVALID_VALUE>
    When method post
    Then status 400
    * string strResponse = response
    * def report = ValidatorTestUtils.validateResponseSchema(oasUrl, strResponse, 'retrieveRelationsDetail', ValidatorTestUtils.POST, <STATUS>)
    * if (report.hasErrors()) karate.fail(report.getMessages() + ' - '+ strResponse)
    And match response.errors[0].detail == '<DETAIL>'
    And match response.errors[0].code == '<CODE_ERROR>'
    Examples:
      | FIELD_NAME                   | INVALID_VALUE  | DETAIL                          | CODE_ERROR | STATUS |
      | delegate.identification.type | 'TIPDOC_FS022' | Faltan parámetros obligatorios. | SAER400-03 | 400    |
      | owner.identification.type    | 'TIPDOC_FS01'  | Faltan parámetros obligatorios. | SAER400-03 | 400    |


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
      | No hay relación                | TIPDOC_FS001  | 123456          | TIPDOC_FS003 | 10000047     | NEG          |                                   | NEG                       | No se encuentran registros de relacionamiento. | BPER409-52  | 409       |
      | Faltan parámetros obligatorios | TIPDOC_FS001  | 1003290315      | TIPDOC_FS003 | 10000047     | SVP          |                                   | NEG                       | Faltan parámetros obligatorios del consumidor  | BPER409-118 | 409       |
      | Consumidor no autorizado       | TIPDOC_FS002  | 180427043217    | TIPDOC_FS002 | 180427043217 | NEG          | A9C64CA09C7DE469C8160F8E308BAD057 | SVP                       | Consumidor no autorizado                       | BPER409-119 | 409       |

