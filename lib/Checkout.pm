package Checkout;

use strict;
use warnings;
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

    # Check if the basket has any items
    if ($checkout->has_basket_items()) {
        print "Basket has items.\n";
    } else {
        print "Basket is empty.\n";
    }

    # Get subtotal
    my $subtotal = $checkout->get_subtotal();

=head1 DESCRIPTION

The Checkout module provides functionality to manage some aspects of a checkout process. It allows users to set basket items, calculate the subtotal, retrieve basket items, and check if the basket has any items. This module relies on the Product module to handle product information.

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

=head2 has_basket_items()

Returns true if the basket has any items.

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
        basket   => [], 
    };

    bless $self, $class;
    return $self;
}

sub set_basket_items {
    my ( $self, $basket_items ) = @_;
    my $decoded_json;

    eval {
        $decoded_json = decode_json($basket_items);
    };
    if ($@){
        die "This doesn't look like a valid data source.";
    }

     
    my %basket_quantities;

    # verify and validate items 
    foreach my $basket_item (@$decoded_json) {
    
        # no such product
        if ( !defined $self->{products}->{$basket_item->{code}} ) {
            $self->{basket} = [];
            die "Invalid Basket, item with code: $basket_item->{code} is not found - check and try again"; 
            last;
        }
        
        # bad quantity values
        if ($basket_item->{quantity} !~ /^\d+$/ || $basket_item->{quantity} <= 0) {      
            warn "Warning: Basket item with code: $basket_item->{code} has invalid quantity - it was removed from the basket";
            next;
        }

        # its a good one
        $basket_quantities{$basket_item->{code}} += $basket_item->{quantity};
    }
    
    my @aggregated_valid_items;
    # maybe change this for foreach my $key etc...
    while ( my ($code, $quantity) = each %basket_quantities){
        push @aggregated_valid_items, { code => $code, quantity => $quantity}
    }
    $self->{basket} = \@aggregated_valid_items;
    return;
}

sub has_basket_items {
    my ($self) = @_;
    return scalar(@{ $self->{basket} }) > 0;
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

sub get_discounted_subtotal {

    my ($self) = @_;
    $self->_calculate_subtotal(1);
    return $self->{subtotal};
}

sub _calculate_subtotal {
    my ($self, $discount) = @_;
    $self->{subtotal} = 0;
    $discount //= 0;

    if (!$self->has_basket_items() ){
        die 'There are no items in the basket.';
    }

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
        if ($discount){
            $self->{subtotal} = $self->{subtotal} * 0.9;
        }

    }

}

1;
