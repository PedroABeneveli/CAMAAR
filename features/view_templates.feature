Feature: View created templates
  As an Administrator
  I want to visualize the created templates
  So that I can edit and/or delete a created template

  Scenario: Two templates were created (happy path)
    Given I have created two templates "Template #1" and "Template #2"
    And I am on the Templates page
    Then I should see "Template #1"
    And I should see "Template #2"

  Scenario: One template was deleted (sad path)
    Given I have created two templates "Teste 1" and "Teste 2"
    And I have deleted template "Teste 1"
    And I am on the Templates page
    Then I should not see "Teste 1"
    And I should see "Teste 2"