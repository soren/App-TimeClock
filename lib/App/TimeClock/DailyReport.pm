package App::TimeClock::DailyReport;

=head1 NAME

App::TimeClock::DailyReport

=head1 DESCRIPTION

Can parse the timelog and generate a report using an instance of a
L<App::TimeClock::PrinterInterface>.

=head2 METHODS

=over

=item new($timelog, $printer)

Initializes a new L<App::TimeClock::DailyReport> object.

Two parameters are required:

=over

=item B<$timelog>

Must point to a timelog file. Will die if not.

=item B<$printer>

An object derived from L<App::TimeClock::PrinterInterface>. Will die if not.

=back

=cut
sub new {
    my $class = shift;
    my $self = {
        timelog => shift,
        printer => shift,
    };
    die "timelog ($self->{timelog}) does not exist" unless -f $self->{timelog} and -r $self->{timelog};
    die "printer is not a PrinterInterface" unless $self->{printer}->isa("App::TimeClock::PrinterInterface");
    bless $self, $class;
};

=item execute()

Opens the timelog file starts parsing it, looping over each day and
calling print_day() for each.

=cut
sub execute {
    use Time::Local;
    use POSIX qw(difftime);

    my $self = shift;

    open FILE, '<', $self->{timelog} or die "$!\n";

    my %projects;
    my ($current_project, $current_date, $work, $work_total, $start, $end);
    my ($start_time, $end_time);
    my ($work_year_to_date, $day_count) = (0,0);

    $current_date = "";
    $work_total = 0;

    $self->{printer}->print_header;

    while(<FILE>) {

        # Split the line, it should contain:
        #
        # - state is either 'i' - check in or 'o' - check out.
        # - date is formatted as YYYY/MM//DD
        # - time is formatted as HH:MM:SS
        # - project is then name of the project/task and is only required when checking in.
        #
        my ($state, $date, $time, $project) = split(/ /, $_, 4);

        if ($current_project) {
            chomp($current_project);
            $current_project=~tr/\r//d;
        }

        chomp($date);

        chomp($time); $time=~tr/\r//d;

        my ($hours, $min, $sec ) = split(/:/, $time);

        my ($year, $mon, $mday) = split(/\//, $date);

        if ($state eq 'i') {
            if (!length($current_date)) {
                $current_date = $date;
                $start_time = $time;
            } elsif (!($current_date eq $date)) {
                $self->{printer}->print_day($current_date, $start_time, $end_time, $work_total, %projects);

                $work_year_to_date += $work_total;
                $day_count++;

                $work_total = 0;
                $current_date = $date;
                $start_time = $time;
                %projects = ();
                $end_time = "";
            }

            $current_project = $project;
            $start = timelocal($sec,$min,$hours,$mday,$mon-1,$year);

        } elsif ($state eq 'o') {
            $end = timelocal($sec,$min,$hours,$mday,$mon-1,$year);
            $work = difftime($end, $start) / 60 / 60;
            $work_total += $work;
            $end_time = $time;
            $projects{$current_project} += $work;
        }
    }

    if (length($current_date)) {
	$self->{printer}->print_day($current_date, $start_time, $end_time, $work_total, %projects);
	$work_year_to_date += $work_total;
	$day_count++;
    }

    $self->{printer}->print_footer($work_year_to_date, $day_count);
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
