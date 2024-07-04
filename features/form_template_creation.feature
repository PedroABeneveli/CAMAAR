Feature: Create form template
  As an Administrator
  I want to create a form template containing the form questions
  So that I can generate evaluation forms to evaluate classes' performances

  Background: Starting on the create templates page
    Given I am logged in as the admin
    And I am on the Create Templates page

  Scenario: Creating a template (happy path)
    When I fill in "Nome do template:" with "Template #1"
    And I press "start_template_button"
    Then I should have a template created with name "Template #1"
    And I should be on the Edit Templates page
    And I should see "Template iniciado com sucesso!"

  Scenario: Leaving blank (sad path)
    When I press "start_template_button"
    Then I should be on the Create Templates page
    And I should see "Nome do template em branco!"
