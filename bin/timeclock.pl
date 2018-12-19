#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use File::Basename qw(basename);
use Pod::Usage;

use App::TimeClock;
use App::TimeClock::Daily::PrinterInterface;
use App::TimeClock::Daily::ConsolePrinter;
use App::TimeClock::Daily::HtmlPrinter;
use App::TimeClock::Daily::CsvPrinter;
use App::TimeClock::Daily::Report;
use App::TimeClock::Weekly::PrinterInterface;
use App::TimeClock::Weekly::ConsolePrinter;
use App::TimeClock::Weekly::Report;

# Initialize/read configuration
{
    package Config;
    our $timelog = "$ENV{HOME}/.emacs.d/timelog";
    $timelog = "$ENV{HOME}/.timelog" unless -f $timelog;
    do "$ENV{HOME}/.timeclockrc";
}

# Parse command line arguments (yes I'm doing this by hand, in this case
# I think it is easier).

# The timelog file to read from. Either get value from configurtion or
# if specified the command line arguments. It should be the only
# non-option argument, if used.
my $timelog;

if ($#ARGV == 1 || $#ARGV == 0 && $ARGV[0] !~ /^--/) {
    $timelog = pop @ARGV;
} else {
    $timelog = $Config::timelog;
}

# The printer to use (this would be an instance of subclass to
# PrinterInterface). Which one to instansiate depends on the command
# line options given.
my $printer;

if ($#ARGV == 0) {
    if ($ARGV[0] eq "--help") {
        pod2usage(-verbose => 1);
    } elsif ($ARGV[0] eq "--man") {
        pod2usage(-verbose => 2);
    } elsif ($ARGV[0] eq "--version") {        
        printf "\nThis is %s version %s\n", basename($0), App::TimeClock->VERSION();
        print "\nCopyright (C) 2012-2018 Søren Lund\n";
        print "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.\n";
        print "This is free software: you are free to change and redistribute it.\n";
        print "There is NO WARRANTY, to the extent permitted by law.\n";
        print "\nWritten by Søren Lund.\n";

        exit 0;
    } elsif ($ARGV[0] eq "--html") {
        $printer = App::TimeClock::Daily::HtmlPrinter->new();
    } elsif  ($ARGV[0] eq "--csv") {
        $printer = App::TimeClock::Daily::CsvPrinter->new();
    } else {
        print "Unknown option '$ARGV[0]'\n";
        pod2usage(-verbose => 1);
    }
} elsif ($#ARGV == -1) {
    $printer = App::TimeClock::Daily::ConsolePrinter->new();
} else {
    pod2usage(-verbose => 1);
}

# Finally create and execute the daily report.
App::TimeClock::Daily::Report->new($timelog, $printer)->execute();
