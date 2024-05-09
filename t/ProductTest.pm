use strict;
use warnings;
use Test::More;
use Test::Exception;
use lib '../lib';
use Product;

# Test constructor
sub test_constructor {
    
    # Test with valid attributes
    my $product = Product->new('A', 50, 3, 140);
    
    # Check if the object was created successfully
    isa_ok($product, 'Product', 'Succesful object creation');
    
    # Check attributes 
    is($product->get_item_code(), 'A', 'Item code');
    is($product->get_unit_price(), 50, 'Unit price');
    is($product->get_discount_qty(), 3, 'Discount quantity');
    is($product->get_discount_price(), 140, 'Discount price');
}

# Test getters and setters
sub test_getters_and_setters {
    my $product = Product->new('B', 35, 2, 60);
    
    # Test getters
    is($product->get_item_code(), 'B', 'Get item code');
    is($product->get_unit_price(), 35, 'Get unit price');
    is($product->get_discount_qty(), 2, 'Get discount quantity');
    is($product->get_discount_price(), 60, 'Get discount price');
    
    # Test setters
    $product->set_item_code('C');
    is($product->get_item_code(), 'C', 'Set item code');
    
    $product->set_unit_price(40);
    is($product->get_unit_price(), 40, 'Set unit price');
    
    $product->set_discount_qty_and_price(4, 120);
    is($product->get_discount_qty(), 4, 'Set discount quantity');
    is($product->get_discount_price(), 120, 'Set discount price');
}

sub test_input_validation {

    # Test invalid item code
    throws_ok { Product->new('', 50, 3, 140) } qr/Invalid code/, 'Invalid item code';

    # Test invalid unit price
    throws_ok {Product->new('B', 'abc', 3, 140) } qr/Invalid unit price/, 'Invalid unit price';

    # Test invalid unit price
    throws_ok { Product->new('B', -10, 3, 140) } qr/non-negative/, 'Negative unit price';

    # Test invalid discount scheme
    throws_ok { Product->new('C', 50, 3) } qr/Invalid discount scheme/, 'Invalid discount scheme';

    # Test invalid discount scheme
    throws_ok { Product->new('C', 50, 3, -140) } qr/non-negative integers/, 'Negative price in discount scheme';

}


test_constructor();
test_getters_and_setters();
test_input_validation();

done_testing();