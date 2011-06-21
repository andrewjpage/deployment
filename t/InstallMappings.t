#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, '../modules') }
BEGIN {
    use Test::Most tests => 5;
    use_ok('InstallMappings');
}

ok my $install_mappings = InstallMappings->new(production_directories => { 
      production_bin    => '/bin',
      production_lib    => '/lib'
    });
isa_ok $install_mappings, 'InstallMappings';

is $install_mappings->{production_directories}{production_bin}, '/bin', 'passed in hash accessible';

ok my %repo_file_to_server_directory = %{$install_mappings->get_install_mappings()};
