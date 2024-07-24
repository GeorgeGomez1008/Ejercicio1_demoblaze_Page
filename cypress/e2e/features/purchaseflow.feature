Feature: Purchase flow in Demoblaze

Scenario Outline: Add two products to the cart, view the cart, complete the form and complete the purchase
    Given that I am on the home page
    When I add two products to the cart "<product1>" "<product2>"
    And I see the cart
    And complete the purchase form "<name>" "<country>" "<city>" "<card>" "<month>" "<year>"
    Then the purchase should be successful

    Examples:
        | product1          | product2         | name        | country | city     | card        | month | year |
        | Samsung galaxy s6 | Nokia lumia 1520 | Jorge Gomez | USA     | New York | 12345678901 | 12    | 2024 |