use strict;
use warnings;
use Test::More tests => 3;

use FindBin;
use File::Temp qw(tempfile);

use App::TimeClock::Weekly::Report;
use App::TimeClock::Weekly::PrinterInterface;
use App::TimeClock::Weekly::ConsolePrinter;

my $printer = App::TimeClock::Weekly::ConsolePrinter->new();

sub find_timelog {
    return "$FindBin::Bin/" . shift;
}

sub weekly_report {
    my $timelog = shift;
    my ($fh, $filename) = tempfile(UNLINK => 1);

    $printer->_set_output_fh($fh);

    my $report = App::TimeClock::Weekly::Report->new(find_timelog($timelog), $printer);
    $report->_set_report_time("2012/03/15", "16:00:00");
    $report->execute();

    seek $fh, 0, 0;
    chomp(my @report = <$fh>);
    close $fh;

    my $size = (-s $filename);

    return ($size, @report);
}

# 
#                  ======================================
#                  Weekly Report Wed Aug 13 08:33:34 2014
#                  ======================================
# 
# Weekly reporting is *not* implemented yet!
{
    my ($size, @report) = weekly_report("timelog.1day");

    is($#report, 5, "Number of lines in report");
    is($size, 212, "Size of report");
    is($report[5], "Weekly reporting is *not* implemented yet!");
}
