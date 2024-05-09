package Checkout;

use strict;
use warnings;


sub new {
    my($class, $products) = @_;

    my $self = {
        # map products to product code keys
        products => { map { $_->get_item_code => $_ @$products}},
        subtotal => 0,
        basket = {}
    }

    bless $self, $class;
    return $self;
}

sub add_basket_items {
    my ($self, $basket_items);
    $self->{basket} = $basket_items;
    # TODO Make a hash of these items so we can add to the quantity 
    # if more items are added

}

sub _calculate_subtotal {

}
1;