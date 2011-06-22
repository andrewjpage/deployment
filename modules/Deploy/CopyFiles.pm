=head1 NAME

CopyFiles.pm   - Copy files using scp

=head1 SYNOPSIS

use Deploy::CopyFiles;
my $copy_files = Deploy::CopyFiles->new(
    application => '/usr/bin/scp',
    user        => 'my_user',
    server      => 'localhost'
  );

$copy_files->copy('myfile', '/tmp');

=cut

package Deploy::CopyFiles;

use strict;
use warnings;

sub new
{
    my ($class,@args) = @_;
    my $self = @args ? {@args} : {};
    bless $self, ref($class) || $class;
    
    die "Application must be specified" unless defined $self->{application};
    die "User must be specified" unless defined $self->{user};
    die "Server must be specified" unless defined $self->{server};

    return $self;
}

sub copy
{
  my( $self, $source_file, $destination_directory ) = @_;
  
  die "Source file must be specified" unless defined $source_file;
  die "Destination directory must be specified" unless defined $destination_directory;
  
  system("$self->{application} $source_file $self->{user}@$self->{server}:$destination_directory")
}

1;