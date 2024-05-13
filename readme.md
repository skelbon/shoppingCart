# Checkout Application Documentation

This document provides an overview of the Checkout application, including documentation for the main script (`main.pl`), the `Product` module (`Product.pm`), and the `Checkout` module (`Checkout.pm`).

Further documentation can be found in POD format within the module files.

## Table of Contents

- [Main Script (main.pl)](#main-script-mainpl)
- [Product Module (Product.pm)](#product-module-productpm)
- [Checkout Module (Checkout.pm)](#checkout-module-checkoutpm)

## Main Script (main.pl)

### Overview

The `main.pl` script serves as the entry point for the Checkout application. It utilizes the Curses library to create a text-based interface for managing checkout operations.

### Features

- Set basket items from a URL.
- Show subtotal of the basket.
- Exit the application.

### Usage

To run the script, after installing the depenedencies in the cpanfile, while in the root directory execute `perl main.pl` in the terminal.

### Error Handling

The script catches warnings and exceptions, displaying error messages in the interface.

### Interface

The script provides a simple interface using the Curses library, allowing users to interact with the application through terminal-based menus and messages.

### Script Structure

The script is structured into functions responsible for different aspects of the application, such as initializing the checkout, setting basket items, calculating the subtotal, and handling user input.

## Product Module (Product.pm)

### Overview

The `Product.pm` module represents products in the checkout system. It provides methods for creating new products, setting and retrieving product information, and managing discount schemes.

### Methods

- `new($item_code, $unit_price, $discount_qty, $discount_price)`: Creates a new Product object.
- `get_item_code()`: Returns the item code of the product.
- `set_item_code(item_code)`: Sets a new item code for the product.
- `get_unit_price()`: Returns the unit price of the product.
- `set_unit_price($new_unit_price)`: Sets a new unit price for the product.
- `get_discount_qty()`: Returns the discount quantity of the product.
- `get_discount_price()`: Returns the discount price for $discount_qty * the product.
- `set_discount_qty_and_price($new_discount_qty, $new_discount_price)`: Sets new discount quantity and price for the product.

### Usage

The module can be used to create and update Product objects consumed by the Checkout class/module.

## Checkout Module (Checkout.pm)

### Overview

The `Checkout.pm` module provides functionality to manage aspects of the checkout process. It allows users to set the product inventory, basket items and calculate the subtotal based the Product object's attributes.

### Methods

- `new(\@products)`: Creates a new Checkout object with a product db as an array of Product objects.
- `set_basket_items($basket_items_json)`: Sets the basket items for the checkout process.
- `get_basket_items()`: Returns the basket items set for the checkout process.
- `has_basket_items()`: Returns true if the basket has any items.
- `get_subtotal()`: Calculates and returns the subtotal of all items in the basket.

### Usage

The module can be used alongside the Product module to manage the checkout process, including setting basket items, calculating the subtotal, and retrieving basket information.

## Author

Joe Gibson
