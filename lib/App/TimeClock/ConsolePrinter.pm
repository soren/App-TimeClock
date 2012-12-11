package App::TimeClock::ConsolePrinter;

our @ISA = qw(App::TimeClock::PrinterInterface);

use POSIX qw(strftime);

use utf8;
binmode STDOUT, ':utf8';

our $hrline =  '+' . ('-' x 62) . '+' . ('-' x 7) . '+';

=head1 NAME

App::TimeClock::ConsolePrinter

=head1 DESCRIPTION

Implements the L<App::TimeClock::PrinterInterface>. Will print a simple ASCII
format. Suitable for using in a console/terminal.

=head1 METHODS

=over

=cut

=item print_header()

Prints a header including todays date. The header is indented to be
centered above the tables printed by L</print_day()>. Example:

                 =====================================
                 Daily Report Wed Mar 14 13:39:06 2012
                 =====================================

=cut
sub print_header {
    my $self = shift;
    my $ident = ' ' x 17;
    $self->_print("\n");
    $self->_print("${ident}=====================================\n");
    $self->_print("${ident}Daily Report " . localtime() . "\n");
    $self->_print("${ident}=====================================\n\n");
};

=item print_day()

Prints all activities for a day including a total. Is printed in a ACSII
table. Example:

 * Mon 2012/03/12 (08:21:16 - 16:05:31) *
 +--------------------------------------------------------------+-------+
 | Total Daily Hours                                            |  7.73 |
 +--------------------------------------------------------------+-------+
 | Lunch                                                        |  0.57 |
 +--------------------------------------------------------------+-------+
 | MyProject:Estimation                                         |  2.90 |
 +--------------------------------------------------------------+-------+
 | AnotherProject:BugFixing                                     |  4.26 |
 +--------------------------------------------------------------+-------+

=cut
sub print_day {
    my ($self, $date, $start, $end, $work, %projects) = (@_);
    my ($year, $mon, $mday) = split(/\//, $date);
    my $wday = substr(strftime("%a", 0, 0, 0, $mday, $mon-1, $year-1900),0,3);

    $self->_print(sprintf("* %3s %s (%s - %s) *\n", $wday, $date, $start, $end));
    $self->_print("$hrline\n");
    $self->_print(sprintf("| Total Daily Hours                                            | %5.2f |\n", $work));
    $self->_print("$hrline\n");

    foreach my $k (sort keys %projects) {
        $self->_print(sprintf("| %-60s | %5.2f |\n",$k, $projects{$k}));
        $self->_print("$hrline\n");
    }
    $self->_print("\n");
};

=item print_footer()

Prints the total number of hours worked and the daily
average. Example:

 TOTAL = 291.72 hours
 PERIOD = 42 days
 AVERAGE = 7.95 hours/day

=cut
sub print_footer {
    my ($self, $work_year_to_date, $day_count) = (@_);
    $self->_print(sprintf("TOTAL = %.2f hours\n", $work_year_to_date));
    $self->_print(sprintf("PERIOD = %d days\n", $day_count));
    $self->_print(sprintf("AVERAGE = %.2f hours/day\n", $day_count > 0 ? $work_year_to_date / $day_count : 0));
};
1;

=back

=for text
=encoding utf-8
=end

=head1 AUTHOR

Søren Lund, C<< <soren at lund.org> >>

=head1 SEE ALSO

L<timeclock.pl>

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
