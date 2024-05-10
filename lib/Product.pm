package Product;

use strict;
use warnings;
=head1 NAME

Product - A module for representing products in a checkout system.

=head1 SYNOPSIS

    use Product;
    use Checkout;

    # Create a new product
    my $product = Product->new($item_code, $unit_price, $discount_qty, $discount_price);

    # Getters and setters
    my $item_code = $product->get_item_code();
    $product->set_item_code($new_item_code);

    my $unit_price = $product->get_unit_price();
    $product->set_unit_price($new_unit_price);

    my $discount_qty = $product->get_discount_qty();
    my $discount_price = $product->get_discount_price();
    $product->set_discount_qty_and_price($new_discount_qty, $new_discount_price);

=head1 DESCRIPTION

The Product module represents products in a checkout system. It allows users to create new products with item codes, unit prices, and optional discount schemes. Users can also retrieve and update product information using getter and setter methods. This module can be used in conjunction with the Checkout module to facilitate the checkout process.

=head1 METHODS

=head2 new($item_code, $unit_price, $discount_qty, $discount_price)

Creates a new Product object.

=over 4

=item * $item_code - The code of the product.

=item * $unit_price - The unit price of the product.

=item * $discount_qty - (Optional) The quantity at which a discount applies.

=item * $discount_price - (Optional) The discounted price for the specified quantity.

=back

=head2 get_item_code()

Returns the item code of the product.

=head2 set_item_code($new_item_code)

Sets a new item code for the product.

=head2 get_unit_price()

Returns the unit price of the product.

=head2 set_unit_price($new_unit_price)

Sets a new unit price for the product.

=head2 get_discount_qty()

Returns the discount quantity of the product.

=head2 get_discount_price()

Returns the discount price of the product.

=head2 set_discount_qty_and_price($new_discount_qty, $new_discount_price)

Sets new discount quantity and price for the product.

=head1 AUTHOR

Joe Gibson

=cut

sub new {
    my ($class, $item_code, $unit_price, $discount_qty, $discount_price) = @_;

    # input validation

    _validate_discount_scheme_input($discount_qty, $discount_price);

    if (!defined $item_code || $item_code eq ''){
        die "Invalid code: You must provide a product code"
    }
    if (!defined $unit_price || $unit_price !~ /^\d+(\.\d+)?$/){
        die "Invalid unit price: Unit price must be non-negative";
    }

    # ------------

    my $self = {
        item_code => $item_code,
        unit_price => $unit_price,
        discount_qty => $discount_qty,
        discount_price => $discount_price
    };
    bless $self, $class;
    return $self
}

sub _validate_discount_scheme_input {

    my ($discount_qty, $discount_price) = @_;

    if ((!defined $discount_qty && defined $discount_price) || (defined $discount_qty && !defined $discount_price)) {
        die "Invalid discount scheme: Both discount quantity and price must be set together if a scheme is to be set"
    }
    if (defined $discount_price){

        if (defined $discount_qty && ($discount_qty !~ /^\d+$/) || $discount_qty < 2){
            die "Invalid discount quantity: Discount quantities must be an integer not less than 2";
        }
        if (defined $discount_price && ($discount_price !~/^\d+(\.\d+)?$/) || $discount_price <= 0 ){
            die "Invalid discount price: discount price must be a positive numeric value"
        }
    }
}

#getters/setters
sub get_item_code {
    my ($self) = @_;
    return $self->{item_code};
}

sub set_item_code {
    my ($self, $item_code) = @_;
    $self->{item_code}= $item_code;
}

sub get_unit_price {
    my ($self) = @_;
    return $self->{unit_price};
}

sub set_unit_price {
    my ($self, $unit_price) = @_;
    $self->{unit_price} = $unit_price;
}

sub get_discount_qty {
    my ($self) = @_;
    return $self->{discount_qty};
}

sub get_discount_price {
    my ($self) = @_;
    return $self->{discount_price};
}

sub set_discount_qty_and_price {
    my ($self, $discount_qty, $discount_price) = @_;
    _validate_discount_scheme_input($discount_qty, $discount_price);
    $self->{discount_qty} = $discount_qty;
    $self->{discount_price} = $discount_price;
}

1;
