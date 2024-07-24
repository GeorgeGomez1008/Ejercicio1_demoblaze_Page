import { Given, When, Then } from "@badeball/cypress-cucumber-preprocessor";
import { webelements } from "../../support/ui/elementsWebPagDemoblaze.js"

require('cypress-xpath')


Given("that I am on the home page", () => {
  cy.visit('/');
});
 
When("I add two products to the cart {string} {string}", (product1, product2) => {
  cy.get('.card-title').contains(product1).click();
  cy.get('.btn.btn-success').click();
  cy.xpath(webelements.NAVLINKHOME).should('contain.text', 'Home').click();
  cy.get('.card-title').contains(product2).click();
  cy.get('.btn.btn-success').click();
});

When('I see the cart', () => {
  cy.xpath(webelements.NAVLINKCART).should('contain.text', 'Cart').click();
  cy.xpath(webelements.BUTTONPLACEORDER).should('contain.text', 'Place Order').click();
});

When('complete the purchase form {string} {string} {string} {string} {string} {string}', (name, country, city, card, month, year) => {
  cy.xpath(webelements.MODALPLACEORDER).should('be.visible');
  cy.xpath(webelements.INPUTNAME).type(name);
  cy.get('#country').type(country);
  cy.get('#city').type(city);
  cy.get('#card').type(card);
  cy.get('#month').type(month);
  cy.get('#year').type(year);
  cy.xpath(webelements.BUTTONPURCHASE).click();
});

Then('the purchase should be successful', () => {
  cy.get('.sweet-alert').should('contain', 'Thank you for your purchase!');
});