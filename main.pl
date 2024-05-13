use strict;
use warnings;
use Curses;
use LWP::Simple;
use JSON;
use Time::HiRes qw(usleep);
use lib './lib';
use Product;
use Checkout;

=head1 NAME

Checkout Application - Text-based checkout application using Curses. Example usage of Checkout and Product modules. 

=head1 SYNOPSIS

This Perl script implements a text-based checkout application using the Curses library for the interface. It allows users to interactively manage a shopping basket, fetch product data from a URL, calculate subtotal, and exit the application.

=head1 DESCRIPTION

The script provides a menu-driven interface where users can perform various actions such as setting basket items from a URL, displaying the subtotal of the basket, and exiting the application gracefully. Error handling is implemented to catch warnings and errors and display descriptive messages to the user.

=head1 FEATURES

=over 4

=item * Set basket items from a URL

=item * Display subtotal of the basket

=item * Clean exit option

=back

=head1 USAGE

=head2 Set Basket Items from URL

Select option 1 from the menu.

Enter the URL containing JSON-formatted product data when prompted.

The application fetches product data from the URL and sets basket items accordingly.

=head2 Show Subtotal

Select option 2 from the menu.

The application calculates and displays the subtotal of the basket.

=head2 Exit Application

Select option 3 from the menu.

The application exits gracefully.

=head1 ERROR HANDLING

Error messages are displayed in the messaging window.

The application catches warnings and errors using eval blocks.

If an error occurs, the application provides a descriptive error message and continues execution.

=head1 INTERFACE

The application features a title window at the top and a content window for menu options.

Error messages and status updates are displayed in a separate messaging window at the bottom.

=head1 SCRIPT STRUCTURE

=over 4

=item * Initialization: Initializes the Curses interface, sets up error handling, and defines menu options.

=item * Main Loop: Continuously awaits user input and handles selected options until the application is exited.

=item * Functions: Includes functions for initializing checkout, animating menu, setting basket from URL, rendering error messages, awaiting user selection, handling application exit, and setting up menu.

=back

=head1 DEPENDENCIES

=over 4

=item * Curses: Used for creating a text-based interface.

=item * LWP::Simple: Required for fetching data from URLs.

=item * JSON: Used for parsing JSON-formatted data.

=item * Time::HiRes: Provides high-resolution time delays.

=back

=head1 AUTHOR

Joe Gibson

=cut

# Init curses
initscr();

# catch warnings 
$SIG{__WARN__} = sub {
    my $warning = shift;
    # Print warning in Curses window
    render_error_message($warning);
    return;
};

my $title = "-------- CHECKOUT V1.0 --------";
my $first_render = 1;

my %menu_items = (
    1 => { title => "1. Set basket items from url", handler => \&set_basket_from_url },
    2 => { title => "2. Show subtotal", handler => \&show_subtotal },
    3 => { title => "3. Exit", handler => \&handle_exit },
);

my $checkout;

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

# define window areas
my $title_window = newwin(1, getmaxx(), 2, 2);
my $content_window = newwin(scalar(keys %menu_items) * 2, getmaxx(), 4, 2);
my $messaging_window = newwin(4, getmaxx() - 2, scalar(keys %menu_items) * 2 + 4, 2);

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
            usleep($first_render ? 10000 : 0);  
        }
        $x = 0;  # Reset x 
        $y += 2;  # Next line
    }
    $first_render = 0; # gets annoying!
}

sub animate_title {
    my $title = shift;
    my $x = 0;
    my $y = 0;

    foreach my $char (split //, $$title){
        foreach my $count (1..10){
            $title_window->addch($y, $x, chr(32 + int(rand(95))) );
            $title_window->refresh();
            usleep(3000);
        };

        $title_window->addch($y, $x++, $char);
        $title_window->refresh();
        usleep(150);
    }
}

sub set_basket_from_url {
    
    $checkout->set_basket_items('[]'); # reset the basket
    $content_window->clear();
    $content_window->move(0,0);
    curs_set(1);
    echo();
    $content_window->addstr("Enter url: ");
    
    my $url = $content_window->getstring();  
    
    my $json_text = get($url);
    die "Could not fetch from that url. ($url)!" unless defined $json_text;
    
    eval{
        $checkout->set_basket_items($json_text);
    };
    if ($@){render_error_message($@);}
    if ( $checkout->has_basket_items()) {
        $messaging_window->addstr('There are items in the basket')
    };
    $messaging_window->refresh();
    $content_window->clear(); 
   
    return;
}

sub render_error_message {
    my ($x,$y);
    my $error_message = shift;
    $messaging_window->addstr($error_message);
    getyx($messaging_window, $y, $x);
    move($y + 1, $x);
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
    echo();
    curs_set(1);
    endwin();
    exit; 
}

sub menu_setup {
        noecho();  
        curs_set(0);
        animate_menu(\%menu_items);
        return;
}

sub show_subtotal {
    $messaging_window->clear();
    my $subtotal = $checkout->get_subtotal();
    $messaging_window->addstr("The subtotal is: $subtotal");
    $messaging_window->refresh();
    return;
}

animate_title(\$title);
init_checkout();
menu_setup();
while(1){
    eval {
        await_selection();
    };
    if ($@){
        render_error_message($@);
    }
}
endwin();

1;
