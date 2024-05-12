use strict;
use warnings;
use Test::More;
use Test::Exception;
use lib "../lib";
use Product;
use Checkout;

my $basket_items_json =
'[{"code":"A","quantity":3},{"code":"B","quantity":3},{"code":"C","quantity":1},{"code":"D","quantity":2}]';

my %test_baskets_json = (
    all_good => {
        data => '[{"code":"A","quantity":3},{"code":"B","quantity":3},{"code":"C","quantity":1},{"code":"D","quantity":2}]',
        expected_result => 284
    },
    zero_quantity => {
        data => '[{"code":"A","quantity":5},{"code":"B","quantity":1},{"code":"C","quantity":0},{"code":"D","quantity":3}]',
        expected_result => 311
    },
    multiple_discounted_items => {
        data => '[{"code":"A","quantity":3},{"code":"B","quantity":4},{"code":"C","quantity":1},{"code":"D","quantity":2}]',
        expected_result => 309
    },
    aggregate_quantities => {
        data => '[{"code":"A","quantity":3},{"code":"A","quantity":2},{"code":"A","quantity":1},{"code":"D","quantity":2},{"code":"C","quantity":1}]',
        expected_result => 329
    },
    invalid_code => {
        data => '[{"code":"A","quantity":3},{"code":"E","quantity":2},{"code":"D","quantity":2},{"code":"C","quantity":2}]',
        expected_result => undef
    },
    invalid_quantity => {
        data => '[{"code":"A","quantity":"invalid"},{"code":"B","quantity":1},{"code":"D","quantity":0},{"code":"C","quantity":1}]',
        expected_result => 60
    }
);

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
    
  
    $checkout->set_basket_items( $test_baskets_json{all_good}->{data});
    is($checkout->get_subtotal(), $test_baskets_json{all_good}->{expected_result}, 'Correct subtotal calculation - all_good in the basket');

    $checkout->set_basket_items( $test_baskets_json{zero_quantity}->{data});
    is($checkout->get_subtotal(), $test_baskets_json{zero_quantity}->{expected_result}, 'Correct subtotal calculation - zero_quantity of basket item');

    $checkout->set_basket_items( $test_baskets_json{multiple_discounted_items}->{data});
    is($checkout->get_subtotal(), $test_baskets_json{multiple_discounted_items}->{expected_result}, 'Correct subtotal calculation - multiple_discounted_items in basket');

    $checkout->set_basket_items( $test_baskets_json{aggregate_quantities}->{data});
    is($checkout->get_subtotal(), $test_baskets_json{aggregate_quantities}->{expected_result}, 'Correct subtotal calculation - aggregate_quantities needed in basket of same items');

    $checkout->set_basket_items( $test_baskets_json{invalid_quantity}->{data});
    is($checkout->get_subtotal(), $test_baskets_json{invalid_quantity}->{expected_result}, 'Correct subtotal calculation - invalid_quantity in basket item');


}




    


sub test_setting_basket_items {

    my $checkout = test_constructor();
    lives_ok { $checkout->set_basket_items($test_baskets_json{all_good}->{data}) } 'Setting basket items';
    dies_ok { $checkout->set_basket_items($test_baskets_json{invalid_code}->{data}) } 'Exception thrown: basket with item not found';
    throws_ok { $checkout->set_basket_items($test_baskets_json{invalid_code}->{data})} qr/E is not found/, 'Exception thrown: Correct item in exception message';
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
