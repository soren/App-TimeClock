#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use File::Basename qw(basename);
use Pod::Usage;

use App::TimeClock;
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
    } elsif ($ARGV[0] eq "--version") {        
        printf "\nThis is %s version %s\n", basename($0), App::TimeClock->VERSION();
        print "\nCopyright (C) 2012-2015 Søren Lund\n";
        print "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.\n";
        print "This is free software: you are free to change and redistribute it.\n";
        print "There is NO WARRANTY, to the extent permitted by law.\n";
        print "\nWritten by Søren Lund.\n";

        exit 0;
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

Displays the manual and exits.

=item B<--version>

Displays the version number and copyright information and exits.

=item B<--html>

Switches to HTML formatted output.

=item B<--csv>

Switches to CSV formatted output.

=back

=head1 DESCRIPTION

This is a simple reporting utility for timeclock, which is a time
tracking package for GNU Emacs.

You will use timeclock from GNU Emacs to I<check in> and I<check out>
of projects during your workday.

Then at the end of the week you can run L<timeclock.pl> to get a daily
report of your work time.

=head1 CONFIGURATION

If you haven't changed your Emacs/TimeClock setup, no configuration is
needed. The script will read your timelog file from the default
location which is ~/.timelog

If you have changed the location of the timelog file (I've placed mine
in a Dropbox folder), you can create the file ~/.timeclockrc and
define the location of the timelog file there. Example:

 $timelog = "$ENV{HOME}/Dropbox/timelog";

=head2 Emacs Integration

You could add the following to you .emacs file to integrate
L<timeclock.pl> into Emacs:
 
 (defun timeclock-show-daily-report()
   "Creates and displays a daily report of timeclock entries."
   (interactive)
   (let ((process-connection-type nil)   ; Use a pipe.
         (command-name "timeclock")
         (buffer-name "*timeclock daily report*")
         (script-name "timeclock.pl"))
     (when (get-buffer buffer-name)
       (progn
         (set-buffer buffer-name)
         (set-buffer-modified-p nil)
         (erase-buffer)))
     (set-buffer (get-buffer-create buffer-name))
     (start-process command-name buffer-name "perl" "-S" script-name)
     (switch-to-buffer buffer-name)))

And the use C<M-x timeclock-show-daily-report RET> to display the
report.

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

Copyright (C) 2012-2015 Søren Lund

This file is part of App::TimeClock.

App::TimeClock is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

App::TimeClock is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with App::TimeClock.  If not, see <http://www.gnu.org/licenses/>.
