#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, '../modules') }
BEGIN {
    use Test::Most tests => 6;
    use_ok('InstallMappings');
}

ok my $install_mappings = InstallMappings->new(production_directories => { 
      production_bin    => '/software/pathogen/internal/prod/bin'
    });
isa_ok $install_mappings, 'InstallMappings';

is $install_mappings->{production_directories}{production_bin}, '/software/pathogen/internal/prod/bin', 'passed in hash accessible';

ok my %repo_file_to_server_directory = %{$install_mappings->get_install_mappings()};
is @{$repo_file_to_server_directory{general}{'perl'}}->[0][1], '/software/pathogen/internal/prod/bin', 'passed in variables used correctly';

