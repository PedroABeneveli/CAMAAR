Feature: create a class evaluation form
  As an administrator
  I want to create a form based in a template for the classes I will choose
  So that I can evaluate classes' performances in the current semester

  Background: Starting on the Send Forms page
    Given I am logged in as the admin
    And I have started template "Template1"
    And There are classes "c1" and "c2"
    And I am on the Send Forms page

  Scenario: Sending a form to one class successfully (happy path)
    When I select "Template1" from "template"
    And I check class "c2"
    And I press "send_forms_button"
    Then I should be on the Gerenciamento page
    And I should see "Formulário enviado com sucesso!"

#  Scenario: Not selecting a template or class (sad path)
#    When I press "Enviar"
#    Then I should see "Erro: campos não preenchidos"
