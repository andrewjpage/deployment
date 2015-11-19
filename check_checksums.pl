#!/usr/bin/env perl

=head1 NAME

check_checksums.pl

=head1 SYNOPSIS

check_checksums.pl CHECKSUM_FILE

=head1 DESCRIPTION

This will check that the files listed in the CHECKSUM_FILE
have not been modified.

=head1 CONTACT

path-help@sanger.ac.uk

=head1 METHODS

=cut
package Deploy;

BEGIN { unshift(@INC, './modules') }
use strict;
use warnings;
use Getopt::Long;
use Digest::MD5::File qw(file_md5_hex);
use Data::Dumper;

my $CHECKSUM_PATH = pop @ARGV;
my $OUTPUT_JSON;

GetOptions ('output-json|j' => \$OUTPUT_JSON);

sub die_usage
{
  die <<USAGE;
Usage: $0 CHECKSUM_PATH
Chech that the files listed in CHECKSUM_PATH haven't changed

 Options:
   --output-json    Output to stdout in JSON

USAGE
;
}

$CHECKSUM_PATH or die_usage();

my @differences = ();

open (my $checksum_file, '<', $CHECKSUM_PATH) or die_usage();
while (my $row = <$checksum_file>) {
  chomp($row);
  my ($old_checksum, $path) = split('  ', $row);
  my $current_checksum;
  if ( -e $path ) {
    $current_checksum = file_md5_hex($path);
  } else {
    $current_checksum = 'File not found';
  }
  if ( $old_checksum ne $current_checksum ) {
    my @difference = ($path, $old_checksum, $current_checksum);
    push (@differences, \@difference);
  }
}

sub output_text
{
  my ( $differences ) = @_;
  foreach my $difference (@$differences) {
    my ($path, $old_checksum, $current_checksum) = @$difference;
    print "'$path' has been modified: '$old_checksum' => '$current_checksum'\n";
  }
  return 1;
}

sub output_json
{
  my ( $differences ) = @_;
  foreach my $difference (@$differences) {
    my ($path, $old_checksum, $current_checksum) = @$difference;
    print "'$path' has been modified: '$old_checksum' => '$current_checksum'\n";
  }
  return 1;
}

print Dumper(\@differences);
output_text(\@differences);
