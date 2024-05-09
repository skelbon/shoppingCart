package Checkout;

use strict;
use warnings;

#constructor
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

1;