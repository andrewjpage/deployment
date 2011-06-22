#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 6;
    use Test::Exception;
    use_ok('Deploy::Make');
}

dies_ok{ my $make = Deploy::Make->new();} 'should die if no parameters passed in';
dies_ok{ my $make = Deploy::Make->new(application => 'abc');} 'should die if no directory passed in';
dies_ok{ my $make = Deploy::Make->new(directory => 'abc');} 'should die if no application passed in';

ok my $make = Deploy::Make->new(directory => 'abc', application => 'abc');
isa_ok $make, 'Deploy::Make';


