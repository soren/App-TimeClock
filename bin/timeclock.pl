#!/usr/bin/env perl

use strict;
use warnings;

use Pod::Usage;

use App::TimeClock::PrinterInterface;
use App::TimeClock::ConsolePrinter;
use App::TimeClock::HtmlPrinter;
use App::TimeClock::CsvPrinter;
use App::TimeClock::DailyReport;

# Initialize/read configuration
{
    package Config;
    our $timelog = "$ENV{HOME}/.timelog";
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
    } elsif ($ARGV[0] eq "--html") {
        $printer = App::TimeClock::HtmlPrinter->new();
    } elsif  ($ARGV[0] eq "--csv") {
        $printer = App::TimeClock::CsvPrinter->new();
    } else {
        print "Unknown option '$ARGV[0]'\n";
        pod2usage(-verbose => 1);
    }
} elsif ($#ARGV == -1) {
    $printer = App::TimeClock::ConsolePrinter->new();
} else {
    pod2usage(-verbose => 1);
}

# Finally create and execute the daily report.
App::TimeClock::DailyReport->new($timelog, $printer)->execute();

__END__

=head1 NAME

timeclock.pl - a timeclock reporting utility

=head1 USAGE

timeclock.pl [options] [file]

Some examples:

    # Console output
    $ timeclock.pl timelog.bak

    # HTML output
    $ timeclock.pl --html > report.html

    # CSV output
    $ timeclock.pl --csv > report.csv

=head1 OPTIONS

Accepts excactly I<one> of the folowing options:

=over

=item B<--help>

Print short usages information and exits.

=item B<--man>

Displays the manual and exists.

=item B<--html>

Switches to HTML formatted output.

=item B<--csv>

Switches to CSV formatted output.

=back

=head1 DESCRIPTION

This is a simple reporting utility for timeclock, which is an Emacs time
tracking package.

=head1 CONFIGURATION

If you haven't changed your Emacs/TimeClock setup, no configuration is
needed. The script will read your timelog file from the default
location which is ~/.timelog

If you have changed the location of the timelog file (I've placed mine
in a Dropbox folder), you can create the file ~/.timeclockrc and
define the location of the timelog file there. Example:

 $timelog = "$ENV{HOME}/Dropbox/timelog";

=head1 DEPENDENCIES

=for text
=encoding utf-8
=end

=head1 AUTHOR

Søren Lund, C<< <soren at lund.org> >>

=head1 SEE ALSO

L<App::TimeClock::ConsolePrinter>,
L<App::TimeClock::HtmlPrinter>,
L<App::TimeClock::CsvPrinter>,
L<App::TimeClock::PrinterInterface>

L<http://www.gnu.org/software/emacs/>,
L<http://www.emacswiki.org/emacs/TimeClock>

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-timeclock at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-TimeClock>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 COPYRIGHT

Copyright (C) 2012 Søren Lund

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; version 2 dated June, 1991 or at your option
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

A copy of the GNU General Public License is available in the source tree;
if not, write to the Free Software Foundation, Inc.,
59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
