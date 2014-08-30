use warnings;
use strict;

use FindBin;
use File::Temp qw(tempfile);
use Test::More tests => 10;
use Test::Exception;

use App::TimeClock::Weekly::PrinterInterface;
use App::TimeClock::Weekly::ConsolePrinter;

package Dummy;
sub new { bless { }, shift; }
package main;

sub find_timelog {
    return "$FindBin::Bin/" . shift;
}

BEGIN {
    use_ok('App::TimeClock::Weekly::Report');
}


my $printer = App::TimeClock::Weekly::ConsolePrinter->new();
my $timelog = find_timelog("timelog.empty");

ok(my $report = App::TimeClock::Weekly::Report->new($timelog, $printer));

dies_ok {App::TimeClock::Weekly::Report->new()};
dies_ok {App::TimeClock::Weekly::Report->new($timelog)};
dies_ok {App::TimeClock::Weekly::Report->new($timelog, $timelog)}; # printer is not a reference
dies_ok {App::TimeClock::Weekly::Report->new($timelog, \$timelog)}; # printer is not an object
dies_ok {App::TimeClock::Daily::Report->new($timelog, Dummy->new())}; # printer is not a PrinterInterface

dies_ok {App::TimeClock::Weekly::Report->new("./nothing_to_find_here", $printer)};

my ($fh, $filename) = tempfile(UNLINK => 1);
chmod 0220, $filename;

dies_ok {App::TimeClock::Weekly::Report->new($filename, $printer)};

chmod 0664, $filename;

{
    my $report = App::TimeClock::Weekly::Report->new($filename, $printer);
    unlink $filename;
    dies_ok {$report->execute()};
}
