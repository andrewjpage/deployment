#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 10;
    use Test::Exception;
    use_ok('Deploy::InstallMappings');
}

dies_ok{ my $install_mappings = Deploy::InstallMappings->new(environment => 'test');} 'should die if no directories passed in';

ok my $install_mappings = Deploy::InstallMappings->new(environment => 'some_enviroment', directories => { 
      test_bin    => '/bin'
    });
is $install_mappings->{environment}, 'some_enviroment', 'specific environment passed in';

ok $install_mappings = Deploy::InstallMappings->new(directories => { 
      test_bin     => '/bin',
      test_java    => '/java_directory'
    });
isa_ok $install_mappings, 'Deploy::InstallMappings';
is $install_mappings->{environment}, 'test', 'test config settings loaded by default';
is $install_mappings->{directories}{test_bin}, '/bin', 'passed in hash accessible';

ok my %repo_file_to_server_directory = %{$install_mappings->get_install_mappings()};
is $repo_file_to_server_directory{general}{java}->[0][1], '/java_directory';





