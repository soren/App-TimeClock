use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'App::TimeClock',
    license             => 'GPL_3',
    dist_author         => q{Søren Lund <soren@lund.org>},
    dist_version_from   => 'lib/App/TimeClock.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'perl' => 5.006,
    },
    add_to_cleanup      => [ 'App-TimeClock-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
