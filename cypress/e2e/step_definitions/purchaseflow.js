import { Given, When, Then } from "@badeball/cypress-cucumber-preprocessor";

Given("that I am on the home page", () => {
  cy.visit('/');
});
 
When('agrego un producto {string} al carrito', (productName) => {
  cy.get('.card-title').contains(productName).click();
  cy.get('.btn.btn-success').click(); // Añadir al carrito
  cy.get('.modal-footer .btn.btn-primary').click(); // Confirmar el añadido
});

When('visualizo el carrito', () => {
  cy.get('#cartur').click();
  cy.url().should('include', '/cart.html');
});

When('completo el formulario de compra', () => {
  cy.get('#totalp').click(); // Hacer clic en el botón de compra
  cy.get('#name').type('John Doe');
  cy.get('#country').type('USA');
  cy.get('#city').type('New York');
  cy.get('#card').type('1234567890123456');
  cy.get('#month').type('12');
  cy.get('#year').type('2024');
  cy.get('.btn.btn-primary').click(); // Finalizar la compra
});

Then('la compra debe ser exitosa', () => {
  cy.get('.sweet-alert').should('contain', 'Thank you for your purchase!');
});