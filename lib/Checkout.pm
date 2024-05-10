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

sub add_basket_items {
    my ( $self, $basket_items ) = @_;

    my $decoded_json = decode_json($basket_items);

    $self->{subtotal} += 10;
    $self->{basket} = $decoded_json;

    $self->_calculate_subtotal();

}

sub get_subtotal {
    my ($self) = @_;
    return $self->{subtotal};
}

sub _calculate_subtotal {
    my ($self) = @_;

    foreach my $basket_item ( @{ $self->{basket} } ) {

        my $product = $self->{products}->{ $basket_item->{code} };

        if ( !defined $product ) {
            die 'Basket item with code: $basket_item->{code} is not found';
        }

    }
}

1;
