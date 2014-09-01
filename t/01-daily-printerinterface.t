use warnings;
use strict;

use Test::More tests => 5;
use Test::Exception;
use Time::Local;

use App::TimeClock::Daily::PrinterInterface;

BEGIN {
    use_ok('App::TimeClock::Daily::PrinterInterface');
}

ok(my $interface = App::TimeClock::Daily::PrinterInterface->new());

# Methods that must be implemented
dies_ok {$interface->print_header()};
dies_ok {$interface->print_day()};
dies_ok {$interface->print_footer()};

