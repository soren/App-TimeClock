use warnings;
use strict;

use FindBin;
use File::Temp qw(tempfile);
use Test::More tests => 8;
use Test::Exception;

use App::TimeClock::Weekly::PrinterInterface;
use App::TimeClock::Weekly::ConsolePrinter;

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
dies_ok {App::TimeClock::Weekly::Report->new($timelog, $timelog)};
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
