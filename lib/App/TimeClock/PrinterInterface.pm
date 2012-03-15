package App::TimeClock::PrinterInterface;

=head1 NAME

App::TimeClock::PrinterInterface

=head1 DESCRIPTION

Interface class. All printer objects given to
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
