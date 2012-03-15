=head2 ConsolePrinter

Implements the L<App:TimeClock::PrinterInterface>. Will print a simple ASCII
format. Suitable for using in a console/terminal.

=head3 Methods

=over

=cut
package App::TimeClock::ConsolePrinter;
our @ISA = qw(App::TimeClock::PrinterInterface);
our $hrline =  '+' . ('-' x 62) . '+' . ('-' x 7) . '+';
use POSIX qw(strftime);

=item print_header()

Prints a header including todays date. The header is indented to be
centered above the tables printed by L</print_day()>. Example:

                 =====================================
                 Daily Report Wed Mar 14 13:39:06 2012
                 =====================================

=cut
sub print_header {
    my $ident = ' ' x 17;
    print "${ident}=====================================\n";
    print "${ident}Daily Report " . localtime() . "\n";
    print "${ident}=====================================\n\n";
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

    printf("* %3s %s (%s - %s) *\n", $wday, $date, $start, $end);
    print("$hrline\n");
    printf("| Total Daily Hours                                            | %5.2f |\n", $work);
    print("$hrline\n");

    foreach my $k (sort keys %projects) {
        printf("| %-60s | %5.2f |\n",$k, $projects{$k});
        print("$hrline\n");
    }
    printf("\n");
};

=item print_day()

Prints the total number of hours worked and the daily
average. Example:

 TOTAL = 291.72 hours
 PERIOD = 42 days
 AVERAGE = 7.95 hours/day

=cut
sub print_footer {
    my ($self, $work_year_to_date, $day_count) = (@_);
    printf "TOTAL = %.2f hours\n", $work_year_to_date;
    printf "PERIOD = %d days\n", $day_count;
    printf "AVERAGE = %.2f hours/day\n", $work_year_to_date / $day_count;
};
1;

=back
