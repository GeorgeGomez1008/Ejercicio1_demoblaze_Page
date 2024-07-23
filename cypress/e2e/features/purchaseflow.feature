Feature: Purchase flow in Demoblaze

Scenario: Add two products to the cart, view the cart, complete the form and complete the purchase
    Given that I am on the home page
    When I add a product "Samsung galaxy s6" to cart
    And I add a product "Nokia lumia 1520" to the cart
    And I see the cart
    And complete the purchase form
    Then the purchase should be successful