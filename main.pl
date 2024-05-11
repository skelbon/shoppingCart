use strict;
use warnings;
use Curses;
use LWP::Simple;
use JSON;
use Time::HiRes qw(usleep);
use lib './lib';
use Product;
use Checkout;


# Init curses
initscr();


our $title = "-------- CHECKOUT V1.0 --------";

our %menu_items = (
    1 => { title => "1. Set basket items from url", handler => \&set_basket_from_url },
    2 => { title => "2. Set them from a file", handler => \&set_basket_from_file },
    3 => { title => "3. Show subtotal", handler => \&show_subtotal },
    4 => { title => "4. Exit", handler => \&handle_exit },
);

our $checkout;

our @products_data = (
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

our $title_window = newwin(1, getmaxx(), 2, 2);
our $content_window = newwin(scalar(keys %menu_items) * 2, getmaxx(), 4, 2);
our $messaging_window = newwin(2, getmaxx() - 2, scalar(keys %menu_items) * 2 + 4, 1);

sub init_checkout {
    
    my @products = ();

    # Instantiate the product objects from the products_data
    foreach my $product_data (@products_data) {
        my $product = Product->new(
            $product_data->{code},         $product_data->{unit_price},
            $product_data->{discount_qty}, $product_data->{discount_price}
        );
        push @products, $product;
    }

    $checkout = Checkout->new( \@products );
    
    return $checkout;
}

sub animate_menu {
    my $menu_items = shift;
    my $x = 0;
    my $y = 0;
    $content_window->clear();
    foreach my $menu_item_index (1..scalar(keys %$menu_items)) {
        my $title = $menu_items->{$menu_item_index}->{title};
        for my $char (split //, $title) {
            $content_window->addch($y, $x++, $char);
            $content_window->refresh();
            usleep(20000);  
        }
        $x = 0;  # Reset x 
        $y += 2;  # Next line
    }
}

sub animate_title {
    my $title = shift;
    my $x = 0;
    my $y = 0;

    foreach my $char (split //, $$title){
        foreach my $count (1..10){
            $title_window->addch($y, $x, chr(32 + int(rand(95))) );
            $title_window->refresh();
            usleep(5000);
        };

        $title_window->addch($y, $x++, $char);
        $title_window->refresh();
        usleep(150);
    }

}

sub set_basket_from_url {
    
    $content_window->clear();
    $content_window->move(0,0);
    curs_set(1);
    echo();
    $content_window->addstr("Enter url: https://");
    my $url = $content_window->getstring();  
    my $json_text = get("https://$url");
    die "Could not get $url!" unless defined $json_text;
    $checkout->set_basket_items($json_text);
    $content_window->clear(); 
   
    return 1;
}

sub render_error_message {
    my $error_message = shift;
    $messaging_window->clear();
    $messaging_window->addstr($error_message);
    $messaging_window->refresh();
    menu_setup();
}

sub await_selection {
    my $selection = $content_window->getch();
    $messaging_window->clear();
    $messaging_window->refresh();
    if (exists $menu_items{$selection}){
        $menu_items{$selection}->{handler}->();
       menu_setup();
    }else{
        my $message = "Oops, that's not an option - go again.";
        render_error_message($message);
    };
}

sub handle_exit {
    endwin();
    exit; 
}

sub menu_setup {
    
    eval {
        noecho();  
        curs_set(0);
        animate_menu(\%menu_items);
        await_selection();
    };

    if ($@){
        render_error_message($@);
    }

}

sub show_subtotal {
    $messaging_window->clear();
    $messaging_window->addstr($checkout->get_subtotal());
    $messaging_window->refresh();
    await_selection();
}

animate_title(\$title);
init_checkout();
menu_setup();
endwin();

1;
