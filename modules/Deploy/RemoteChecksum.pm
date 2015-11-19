=head1 NAME

RemoteChecksum.pm   - SSHs into a remote machine and take the checksum of a given file

=head1 SYNOPSIS

=cut

package Deploy::RemoteChecksum;

use strict;
use warnings;
use Net::SSH qw(ssh_cmd);

sub new
{
    my ($class, $host) = @_;
    die "Must provide host parameter" unless defined $host;
    my $self = { host => $host };
    bless $self, ref($class) || $class;
    
    return $self;
}

sub checksum
{
  my( $self, $path ) = @_;
  my $checksum = ssh_cmd($self->{host},
	                 "if [ -e $path ]; then
			    md5sum $path | awk '{print \$1}';
			  else
			    echo 'File not found';
			  fi");
  chomp($checksum);
  return $checksum;
}

sub compare_mappings
{
  my ( $self, $original, $revised ) = @_;
  foreach my $path (keys %$original) {
    my $original_checksum = $original->{$path};
    my $revised_checksum = $revised->{$path};
    print "$path has changed from '$original_checksum' to '$revised_checksum'\n" unless $original_checksum eq $revised_checksum;
  }
  return 1;
}

1;
