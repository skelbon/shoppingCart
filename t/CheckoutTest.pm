use strict;
use warnings;
use Test::More;
use Test::Exception;
use lib "../lib";
use Product;
use Checkout;
use Data::Dumper;

our $basket_items =
'[{"code":"A","quantity":3},{"code":"B","quantity":3},{"code":"C","quantity":1},{"code":"D","quantity":2}]';

sub test_constructor {

    my @products_data = (
        {
            code           => 'A',
            unit_price     => 50,
            discount_qty   => 3,
            discount_price => 140
        },
        {
            code           => 'B',
            unit_price     => 35,
            discount_qty   => 2,
            discount_price => 60
        },
        { code => 'C', unit_price => 25 },
        { code => 'D', unit_price => 12 }
    );

    my @products = ();

    # Instantiate the product objects from the products_data
    foreach my $product_data (@products_data) {
        my $product = Product->new(
            $product_data->{code},         $product_data->{unit_price},
            $product_data->{discount_qty}, $product_data->{discount_price}
        );
        push @products, $product;
    }

    my $checkout = Checkout->new( \@products );
    isa_ok( $checkout, 'Checkout', 'Successful object creation' );

    return $checkout;
}

sub test_subtotal_method {
    my $checkout = test_constructor();
    my $sub      = $checkout->get_subtotal();
    return $sub;
}

sub test_adding_basket_items {

    my $checkout = test_constructor();
    $checkout->add_basket_items($basket_items);
    return $checkout;
}

my $subtotal        = test_subtotal_method();
my $filled_checkout = test_adding_basket_items();

print Dumper($subtotal);

done_testing();
