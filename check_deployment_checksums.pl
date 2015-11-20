#!/usr/bin/env perl

=head1 NAME

check_checksums.pl

=head1 SYNOPSIS

check_deployment_checksums.pl CHECKSUM_FILE

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
use JSON qw(to_json);
use Data::Dumper;

my $CHECKSUM_PATH = pop @ARGV;
my $OUTPUT_JSON;

GetOptions ('output-json|j' => \$OUTPUT_JSON);

sub die_usage
{
  die <<USAGE;
Usage: $0 [OPTIONS] CHECKSUM_PATH
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
  my ( $differences_tuples, $checksum_path ) = @_;
  my @differences_hashes = ();
  foreach my $difference (@$differences_tuples) {
    my ($path, $old_checksum, $current_checksum) = @$difference;
    push (@differences_hashes, { path => $path, 
		                 old_checksum => $old_checksum,
				 current_checksum => $current_checksum });
  }
  my $json_output = to_json( { differences => \@differences_hashes,
                               according_to => $checksum_path } );
  print "$json_output\n";
  return 1;
}

my $out_func = defined $OUTPUT_JSON ? \&output_json : \&output_text;
$out_func->(\@differences, $CHECKSUM_PATH);
