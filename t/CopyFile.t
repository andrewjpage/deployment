#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 7;
    use Test::Exception;
    use_ok('Deploy::CopyFiles');
}

dies_ok{ my $make = Deploy::CopyFiles->new();} 'should die if no parameters passed in';
dies_ok{ my $make = Deploy::CopyFiles->new(application => 'abc', user => 'efg');} 'should die if no server passed in';
dies_ok{ my $make = Deploy::CopyFiles->new(server => 'abc', user => 'efg');} 'should die if no application passed in';
dies_ok{ my $make = Deploy::CopyFiles->new(application => 'abc', server => 'efg');} 'should die if no user passed in';

ok my $make = Deploy::CopyFiles->new(server => 'abc', application => 'abc', user => 'efg');
isa_ok $make, 'Deploy::CopyFiles';


