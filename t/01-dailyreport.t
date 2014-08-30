use warnings;
use strict;

use FindBin;
use File::Temp qw(tempfile);
use Test::More tests => 15;
use Test::Exception;
use Time::Local;

use App::TimeClock::Daily::PrinterInterface;
use App::TimeClock::Daily::ConsolePrinter;

package Dummy;
sub new { bless { }, shift; }
package main;

sub find_timelog {
    return "$FindBin::Bin/" . shift;
}

BEGIN {
    use_ok('App::TimeClock::Daily::Report');
}


my $printer = App::TimeClock::Daily::ConsolePrinter->new();
my $timelog = find_timelog("timelog.empty");

dies_ok {App::TimeClock::Daily::Report->new()};
dies_ok {App::TimeClock::Daily::Report->new($timelog)};
dies_ok {App::TimeClock::Daily::Report->new($timelog, $timelog)}; # printer is not a reference
dies_ok {App::TimeClock::Daily::Report->new($timelog, \$timelog)}; # printer is not an object
dies_ok {App::TimeClock::Daily::Report->new($timelog, Dummy->new())}; # printer is not a PrinterInterface

dies_ok {App::TimeClock::Daily::Report->new("./nothing_to_find_here", $printer)};

my ($fh, $filename) = tempfile(UNLINK => 1);
chmod 0220, $filename;

dies_ok {App::TimeClock::Daily::Report->new($filename, $printer)};

chmod 0664, $filename;

{
    my $report = App::TimeClock::Daily::Report->new($filename, $printer);
    unlink $filename;
    dies_ok {$report->execute()};
}

ok(my $report = App::TimeClock::Daily::Report->new($timelog, $printer));

# private get/set report_time methods
is($report->_get_report_time(), time, "Report time is current time by default");
$report->_set_report_time("2010/01/31", "12:30:00");
is($report->_get_report_time(), timelocal(00,30,12, 31,00,2010), "Report time is set");

($fh, $filename) = tempfile(UNLINK => 1);

# private _read_lines
dies_ok {$report->_read_lines($fh)}; # prematurely end of file

open my $file, '<', find_timelog("timelog.bad3");
dies_ok {$report->_read_lines($file)}; # excepected check in
close $file;

open $file, '<', find_timelog("timelog.bad4");
dies_ok {$report->_read_lines($file)}; # excepected check out
close $file;
