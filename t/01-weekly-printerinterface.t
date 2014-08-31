use warnings;
use strict;

use Test::More tests => 5;
use Test::Exception;
use Time::Local;

use App::TimeClock::Weekly::PrinterInterface;

BEGIN {
    use_ok('App::TimeClock::Weekly::PrinterInterface');
}

ok(my $interface = App::TimeClock::Weekly::PrinterInterface->new());

# Methods that must be implemented
dies_ok {$interface->print_header()};
dies_ok {$interface->print_week()};
dies_ok {$interface->print_footer()};

