Feature: Create form template
  As an Administrator
  I want to create a form template containing the form questions
  So that I can generate evaluation forms to evaluate classes' performances

  Background: Starting on the create templates page
    Given I am logged in as the admin
    And I am on the Create Templates page

  Scenario: Creating a template with one text question (happy path)
    When I fill in "Nome do template:" with "Template #1"
    And I press "add_question_button"
    And I fill in "question_1_title" with "Questão 1?"
    And I press "create_template_button"
    Then I should be on the Templates page
    And I should see "Template criado com sucesso!"

  Scenario: Filling all correctly (happy path)
    When I fill in "Nome do template:" with "Temp Teste"
    And I press "add_question_button"
    And I fill in "question_1_title" with "Questão 1?"
    And I select "radio" from "question_type"
    And I press "Add Alternative"
    And I fill in "alternative_1_1" with "Alt 1"
    When I create a text question with the question "quest2?"
    Then I should see "Questão 2"
    When I press "Criar"
    Then I should be on the Templates page
    And I should see "Temp Teste"

  Scenario: Not filling a field (sad path)
    When I press "Criar"
    Then I should be on the Templates page
    And I should see "Erro: campos nao preenchidos"