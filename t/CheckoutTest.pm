use strict;
use warnings;
use Test::More;
use Test::Exception;
use lib '../lib';
use Checkout;
use Product;


sub test_constructor{

my @products_data = (
    { code => 'A', unit_price => 50, discount_qty => 3, discount_price => 140 },
    { code => 'B', unit_price => 35, discount_qty => 2, discount_price => 60 },
    { code => 'C', unit_price => 25 },
    { code => 'D', unit_price => 12 }
);

    my @products = ();
    #instantiate the product objects from the products_data
    foreach my $product_data (@products_data){
        my $product = Product->new(
        $product_data->{code},
        $product_data->{unit_price},
        $product_data->{discount_qty},
        $product_data->{discount_price}
    );
    push @products, $product;
    }

    my $checkout = Checkout->new(@products);
    isa_ok($checkout , 'Checkout', 'Successful object creation');
}


test_constructor();
done_testing();