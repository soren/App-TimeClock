=head2 CsvPrinter

Implements the L</App::TimeClock::PrinterInterface>. Will print total for each day in a
comma separated format.

=head3 Methods

=over

=cut
package App::TimeClock::CsvPrinter;
our @ISA = qw(App::TimeClock::PrinterInterface);
use POSIX qw(strftime);

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

=item print_header()

There's no footer when print CSV. This is an empty sub.

=cut
sub print_footer {};
1;

=back
