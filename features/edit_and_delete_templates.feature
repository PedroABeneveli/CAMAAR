Feature: Edit/Delete Template
  As an Administrator
  I want to edit and/or delete a template that I created without affecting already created forms
  So that I can organize the existing templates

  Background: Starting on the templates management page
    Given I am logged in as the admin
    And I have started template "Template #1"
    And I am on the Edit Templates page

  Scenario: Edit name (happy path)
    When I fill in "template_name" with "Template #2"
    And I press "save_template_name"
    Then I should be on the Edit Templates page
    And I should have a template with name "Template #2"
    And I should see "Template atualizado com sucesso!"

  Scenario: Add question (happy path)
    When I press "add_question_button"
    And I fill in "Q1." with "Q1?"
    And I press "save_question_1"
    Then I should be on the Edit Templates page
    And I should have a template with name "Template #1"
    And I should have a template with question "Q1?"
    And I should see "Template atualizado com sucesso!"

  Scenario: Successful deletion (happy path)
    Given I am on the Templates page
    When I press "delete_template_1"
    Then I should be on the Templates page
    And I should see "Template deletado com sucesso!"
    And I should have a hidden template "Template #1"

  Scenario: Edit with empty field (sad path)
    When I fill in "template_name" with ""
    And I press "save_template_name"
    Then I should be on the Edit Templates page
    And I should have a template with name "Template #1"
    And I should see "Nome do template em branco!"
