Feature: simple requests

Scenario: simple sequence
Given url 'https://httpbin.org/anything'
And request { myKey: 'Hola' }
When method post
Then status 200
And match response contains { json: { myKey: 'Hola' } }
