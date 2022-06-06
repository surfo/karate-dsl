Feature: simple requests

Scenario: simple sequence
Given url 'https://httpbin.org/anything'
And request { myKey: 'Hola' }
When method post
Then status 200
And match response contains { json: { myKey: 'Hola' } }


Scenario Outline: simple sequence desde tabla
    Given url 'https://httpbin.org/anything'
    And request { myKey: "<data_Input>" }
    When method post
    Then status 200
    And match response contains { json: { myKey: "<data_Output>" } }

Examples:
| data_Input     |  data_Output  |
| Buen dia       | Buen dia      |
| Buenas tardes  | Buenas tardes |
| Buenas noches  | Buenas noches |