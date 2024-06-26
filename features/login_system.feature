Feature: Login System
  As a system user
  I want to access the system using an e-mail or enrollment number and a registered password
  So that I can answer forms or manage the system

  Background: Starting on the login page
    Given I am on the login page
    And There is a user with email "teste@email.com" and matricula "123456789" and password "123456"

  Scenario: Correct information with email (happy path)
    When I log in with "teste@email.com" as the login and "123456" as a password
    Then I should be on the Avaliacoes page
    
  Scenario: Correct information with enrollment number (happy path)
    When I log in with "123456789" as the login and "123456" as a password
    Then I should be on the Avaliacoes page

  Scenario: No information (sad path)
    When I press "Entrar"
    Then I should be on the login page
    And I should see "Login ou senha inválida."
    
  Scenario: Wrong password (sad path)
    When I log in with "teste@gmail.com" as the login and "654321" as a password
    Then I should be on the login page
    And I should see "Login ou senha inválida."
    
  Scenario: Non-registered user (sad path)
    When I log in with "etset@gmail.com" as the login and "123456" as a password
    Then I should be on the login page
    And I should see "Login ou senha inválida."