#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 8;
    use Time::Mock;
    use_ok('Deploy::GlobalConfigSettings');
    
    Time::Mock->set("2010-09-08 07:06:05");
}

ok my $global_config_settings = Deploy::GlobalConfigSettings->new(environment => 'some_environment'), 'initialization';
is $global_config_settings->{environment}, 'some_environment', 'some_environment loaded by default';

ok $global_config_settings = Deploy::GlobalConfigSettings->new(), 'initialization';
is $global_config_settings->{environment}, 'test', 'test environment loaded by default';
isa_ok $global_config_settings, 'Deploy::GlobalConfigSettings';

ok my %settings = %{$global_config_settings->get_config_settings()}, 'settings hash';
is $settings{checkout_directory}, '/tmp/20100908070605', 'timestamped checkout directory';
