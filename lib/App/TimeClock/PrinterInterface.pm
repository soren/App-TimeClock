=head1 NAME

PrinterInterface - Interface class. All printer objects given to
L<App::TimeClock::DailyReport> constructor must be derived from
PrinterInterface.

=head1 SYNOPSIS

 package App::TimeClock::MyPrinter;
 our @ISA = qw(App::TimeClock::PrinterInterface);
 ...
 sub print_header {
     ...
 }
 sub print_day {
     ...
 }
 sub print_footer {
     ...
 }

=head1 METHODS

=over

=cut
package App::TimeClock::PrinterInterface;

=item new()

Creates a new object.

=cut
sub new {
    bless { }, shift;
}

=item print_header()

Called once at the start of a report.

=cut
sub print_header { shift->_must_implement; };

=item print_day()

Called for each day in the report.

=cut
sub print_day { shift->_must_implement; };

=item print_footer()

Called once at the end of a report.

=cut
sub print_footer { shift->_must_implement; };

sub _must_implement {
    (my $name = (caller(1))[3]) =~ s/^.*:://;
    my ($filename, $line) = (caller(0))[1..2];
    die "You must implement $name() method at $filename line $line";
}
1;

=back
