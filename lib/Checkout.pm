package Checkout;

use strict;
use warnings;
use Data::Dumper;
use JSON;
=head1 NAME

Checkout - A simple module for managing some aspects of a checkout process.

=head1 SYNOPSIS

    use Checkout;
    use Product;

    # Initialize product objects
    my @products = (
        Product->new(...),
        Product->new(...),
        ...
    );

    # Initialize checkout with product objects
    my $checkout = Checkout->new(\@products);

    # Set basket items
    $checkout->set_basket_items($basket_items_json);

    # Get basket items
    my $basket_items = $checkout->get_basket_items();

    # Get subtotal
    my $subtotal = $checkout->get_subtotal();

=head1 DESCRIPTION

The Checkout module provides functionality to manage some aspects of a checkout process. It allows users to set basket items, calculate the subtotal, and retrieve basket items. This module relies on the Product module to handle product information.

=head1 METHODS

=head2 new(\@products)

Creates a new Checkout object.

=over 4

=item * \@products - An array reference containing product objects obtained from the Product module.

=back

=head2 set_basket_items($basket_items_json)

Sets the basket items for the checkout process.

=over 4

=item * $basket_items_json - A JSON string representing the basket items.

=back

=head2 get_basket_items()

Returns the basket items set for the checkout process.

=head2 get_subtotal()

Calculates and returns the subtotal of all items in the basket.

=head1 AUTHOR

Joe Gibson

=cut

sub new {
    my ( $class, $products ) = @_;

    my $self = {

        # map products to product code keys
        products => { map { $_->get_item_code => $_ } @$products },
        subtotal => 0,
        basket   => {}
    };

    bless $self, $class;
    return $self;
}

sub set_basket_items {
    my ( $self, $basket_items ) = @_;

    # TODO Add some error handling for bad data scenario
    my $decoded_json = decode_json($basket_items);

    # verify items exist
    foreach my $basket_item ( @$decoded_json ) {

        if ( !defined $self->{products}->{$basket_item->{code}} ) {
          
            die "Basket item with code: $basket_item->{code} is not found";
        }
    }
    # TODO validate this data
    $self->{basket} = $decoded_json;

}

sub get_basket_items {
    my ($self) = @_;
    return $self->{basket};
}

sub get_subtotal {
    my ($self) = @_;
    $self->_calculate_subtotal();
    return $self->{subtotal};
}

sub _calculate_subtotal {
    my ($self) = @_;
    $self->{subtotal} = 0;
    foreach my $basket_item ( @{ $self->{basket} } ) {

        my $product = $self->{products}->{ $basket_item->{code} };
        my $dicounted_total = 0;
        my $non_discounted_total = 0;

        if (defined $product->{discount_qty}){
            $dicounted_total = int($basket_item->{quantity} / $product->{discount_qty}) * $product->{discount_price};
            $non_discounted_total = ($basket_item->{quantity} % $product->{discount_qty}) * $product->{unit_price};
        }else {
            $non_discounted_total = $basket_item->{quantity}  * $product->{unit_price};
        }
   
        $self->{subtotal} += $non_discounted_total + $dicounted_total;
    }

}

1;
