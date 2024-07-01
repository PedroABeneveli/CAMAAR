Feature: Create form template
  As an Administrator
  I want to create a form template containing the form questions
  So that I can generate evaluation forms to evaluate classes' performances

  Background: Starting on the create templates page
    Given I am logged in as the admin
    And I am on the Create Templates page

  Scenario: Creating a template with one text question (happy path)
    When I fill in "Nome do template:" with "Template #1"
    And I press "add-question-button"
    And I fill in "question-1-title" with "Questão 1?"
    And I press "create_template_button"
    Then I should be on the Templates page
    And I should see "Template criado com sucesso!"

  Scenario: Filling all correctly (happy path)
    When I fill in "Nome do template:" with "Template #2"
    And I press "add_question_button"
    And I fill in "question_1_title" with "Questão 1?"
    And I select "radio" from "question_type"
    And I press "add_alternative_button_q1"
    And I fill in "alternative_1_q1" with "Alternativa 1"
    And I press "add_alternative_button_q1"
    And I fill in "alternative_2_q1" with "Alternativa 2"
    And I press "add_alternative_button_q1"
    And I fill in "alternative_3_q1" with "Alternativa 3"
    And I press "add_question_button"
    And I fill in "question_2_title" with "Questão 2?"
    And I select "checkbox" from "question_type"
    And I press "add_alternative_button_q1"
    And I fill in "alternative_1_q2" with "Alt. 1"
    And I press "add_alternative_button_q1"
    And I fill in "alternative_2_q2" with "Alt. 2"
    And I press "create_template_button"
    Then I should be on the Templates page
    And I should see "Template criado com sucesso!"

  Scenario: No questions template (sad path)
    When I fill in "Nome do template:" with "Template #1"
    And I press "create_template_button"
    Then I should be on the Create Templates page
    And I should see "Template precisa de pelo menos uma questão!"

  Scenario: Not filled template name (sad path)
    When I press "add-question-button"
    And I fill in "question-1-title" with "Questão 1?"
    And I press "create_template_button"
    Then I should be on the Create Templates page
    And I should see "Nome do template não preenchido!"

  Scenario: Not filled question (sad path)
    When I fill in "Nome do template:" with "Template #1"
    And I press "add-question-button"
    And I press "create_template_button"
    Then I should be on the Create Templates page
    And I should see "Questão não preenchida!"