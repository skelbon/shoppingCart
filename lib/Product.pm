package Product;

use strict;
use warnings;

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

        if (defined $discount_qty && ($discount_qty !~ /^\d+$/) || $discount_price !~ /^\d+$/){
            die "Invalid discount quantity: Discount quantities must be non-negative integers";
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
