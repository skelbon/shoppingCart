# Checkout System

This repository contains Perl modules for managing a checkout system, including product representation (`Product` module) and checkout functionality (`Checkout` module).

## Modules

### Product Module

The `Product` module represents products in the checkout system. It allows users to create new products with item codes, unit prices, and optional discount schemes. Users can also retrieve and update product information using getter and setter methods.

### Checkout Module

The `Checkout` module provides functionality to manage a checkout process in the system. It allows users to set basket items, calculate the subtotal, and retrieve basket items. This module relies on the `Product` module to handle product information.

## Usage

To use these modules in your Perl project:

1. Clone the repository:


2. Include the required modules in your Perl scripts:

```perl
use Product;
use Checkout;
```

3. Follow the documentation provided in each module for usage instructions and examples.

