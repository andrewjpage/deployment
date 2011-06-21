#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, '../modules') }
BEGIN {
    use Test::Most tests => 5;
    use Time::Mock;
    use_ok('GlobalConfigSettings');
    
    Time::Mock->set("2010-09-08 07:06:05");
}

ok my $global_config_settings = GlobalConfigSettings->new(), 'initialization';
isa_ok $global_config_settings, 'GlobalConfigSettings';

ok my %settings = %{$global_config_settings->get_config_settings()}, 'settings hash';
is $settings{checkout_directory}, '/tmp/20100908070605', 'timestamped checkout directory';
