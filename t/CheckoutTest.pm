use strict;
use warnings;
use Test::More;
use Test::Exception;
use lib "../lib";
use Product;
use Checkout;
use Data::Dumper;

my $basket_items_json =
'[{"code":"A","quantity":3},{"code":"B","quantity":3},{"code":"C","quantity":1},{"code":"D","quantity":2}]';

my %test_baskets_json = {
    1 => { data => '[{"code":"A","quantity":3},{"code":"B","quantity":3},{"code":"C","quantity":1},{"code":"D","quantity":2}]', expected_result => 284}, 
    2 => { data => '[{"code":"A","quantity":5},{"code":"B","quantity":1},{"code":"C","quantity":0},{"code":"D","quantity":3}]', expected_result => 284}, 
    3 => { data => '[{"code":"A","quantity":3},{"code":"A","quantity":2},{"code":"A","quantity":1},{"code":"D","quantity":2},{"code":"C","quantity":1}]', expected_result => 284}, 
};

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
    throws_ok {$checkout->get_subtotal()} qr /no items in the basket/, 'Exception thrown: no items in basket when subtotal called';
    $checkout->set_basket_items($basket_items_json);
    is($checkout->get_subtotal(), 284, 'Correct subtotal calculation');


    
}

sub test_setting_basket_items {

    my $checkout = test_constructor();
    lives_ok { $checkout->set_basket_items($basket_items_json) } 'Setting basket items';
    dies_ok { $checkout->set_basket_items('[{"code":"E","quantity":1}]') } 'Exception thrown: basket with item not found';
    throws_ok { $checkout->set_basket_items('[{"code":"E","quantity":1}]') } qr/E is not found/, 'Exception thrown: Correct item in exception message';
    $checkout->set_basket_items($basket_items_json);
    my $basket_items_ref = $checkout->get_basket_items();
    
    my %basket_items;
    
    foreach my $item (@{$basket_items_ref}) {
        $basket_items{$item->{'code'}} = $item->{'quantity'};
    }

    is($basket_items{'A'}, 3, 'Correct quantity of item A in basket');
    is($basket_items{'B'}, 3, 'Correct quantity of item B in basket');
    is($basket_items{'C'}, 1, 'Correct quantity of item C in basket');
    is($basket_items{'D'}, 2, 'Correct quantity of item D in basket');

}

test_constructor();
test_subtotal_method();
test_setting_basket_items();

done_testing();
