package Product;

use strict;
use warnings;

#constructor
sub new {
    my ($class, $item_code, $unit_price, $discount_qty, $discount_price) = @_;
    my $self = {
        item_code => $item_code,
        unit_price => $unit_price,
        discount_qty => $discount_qty,
        discount_price => $discount_price
    };
    bless $self, $class;
    return $self
}

sub get_code {
    my ($self, $code) = @_;
    $self->{$code};
}

sub set_code {
    my ($self) = @_;
    $self->{code}=
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
sub set_discount_qty {
    my ($self, $discount_qty) = @_;
    $self->{discount_qty} = $discount_qty;
}

sub get_discount_price {
    my ($self) = @_;
    return $self->{discount_price};
}

sub set_discount_price {
    my ($self, $discount_price) = @_;
    $self->{discount_price} = $discount_price;
}


1;
