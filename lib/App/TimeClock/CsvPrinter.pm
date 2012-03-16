package App::TimeClock::CsvPrinter;

our @ISA = qw(App::TimeClock::PrinterInterface);

use POSIX qw(strftime);

=head1 NAME

App::TimeClock::CsvPrinter

=head1 DESCRIPTION 

Implements the L<App::TimeClock::PrinterInterface>. Will print total
for each day in a comma separated format.

=head1 METHODS

=over

=cut

=item print_header()

There's no header when print CSV. This is an empty sub.

=cut
sub print_header {};

=item print_day()

Prints totals for each day. Five fields are printed: week day, date,
start time, end time and total hours worked. Example:

 "Mon","2012/03/12","08:21:16","16:05:31",7.732222

=cut
sub print_day {
    my ($self, $date, $start, $end, $work, %projects) = (@_);
    my ($year, $mon, $mday) = split(/\//, $date);
    my $wday = substr(strftime("%a", 0, 0, 0, $mday, $mon-1, $year-1900),0,3);

    printf '"%s","%s","%s","%s",%f' . "\n",$wday, $date, $start, $end, $work;
};

=item print_footer()

There's no footer when print CSV. This is an empty sub.

=cut
sub print_footer {};
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
