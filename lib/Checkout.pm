package Checkout;

use strict;
use warnings;

#constructor
sub new {

    my($class, $products) = @_;

    my $self = {
        products => { map { $_->get_item_code => $_ @$products}},
        subtotal => 0,
        basket = {}
    }

    bless $self, $class;
    return $self;
}

1;