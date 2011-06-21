#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, '../modules') }
BEGIN {
    use Test::Most tests => 4;
    use Time::Mock;
    use_ok('TimeStamp');
    
    Time::Mock->set("2010-09-08 07:06:05");
}

ok my $time = TimeStamp->new();
isa_ok $time, 'TimeStamp';
is $time->{formatted_time_stamp}, '20100908070605', 'formatted timestamp matches'
