=head1 NAME

RemoteChecksum.pm   - SSHs into a remote machine and take the checksum of a given file

=head1 SYNOPSIS

my $remote = Deploy::RemoteChecksum->new('my_server.example.com');
my $checksum = $remote->checksum('/home/foo/bar');
my $original = { '/home/foo/bar' => 'd41d8cd98f00b204e9800998ecf8427e' };
my $revised = { '/home/foo/bar' => 'bea8252ff4e80f41719ea13cdf007273' };
$remote->compare_mappings($original, $revised);
$remote->write_logfile('/home/foo/checksums.log', $revised);

=cut

package Deploy::RemoteChecksum;

use strict;
use warnings;
use Net::SSH qw(ssh_cmd);

sub new
{
  my ($class, $host, $user) = @_;
  die "Must provide host parameter" unless defined $host;
  die "Must provide user parameter" unless defined $user;
  my $self = { host => $host, user => $user };
  bless $self, ref($class) || $class;

  return $self;
}

sub _cmd
{
  my ($self, $cmd) = @_;
  my $host = $self->{host};
  my $user = $self->{user};
  my $response = ssh_cmd("$user\@$host", $cmd);
  return $response;
}

sub checksum
{
  my( $self, $path ) = @_;
  my $checksum = $self->_cmd(
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
}

sub write_logfile
{
  my ( $self, $remote_log_path, $checksums ) = @_;
  my $log_output = "";

  foreach my $file_path ( sort keys %$checksums ) {
    my $checksum = $checksums->{$file_path};
    $log_output .= "$checksum  $file_path\n";
  }
  chomp($log_output);

  my $response = $self->_cmd("echo '$log_output' > $remote_log_path");
}

1;
