package Checkout;

use strict;
use warnings;
use Data::Dumper;
use JSON;

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

    # Add some error handling for bad data scenario
    my $decoded_json = decode_json($basket_items);

    #verify items exist
    foreach my $basket_item ( @$decoded_json ) {

        if ( !defined $self->{products}->{$basket_item->{code}} ) {
            die 'Basket item with code: $basket_item->{code} is not found';
        }
    }

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
