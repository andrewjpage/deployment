=head1 NAME

Make.pm   - Execute make files

=head1 SYNOPSIS

use Deploy::Make;
make = Deploy::Make->new(
  application => '/usr/bin/make',
  directory => "/home/user/my_project"
);
make->build;
make->test;

=cut

package Deploy::Make;

use strict;
use warnings;

sub new
{
    my ($class,@args) = @_;
    my $self = @args ? {@args} : {};
    bless $self, ref($class) || $class;
    
    die "Application must be specified" unless defined $self->{application};
    die "Working directory must be specified" unless defined $self->{directory};

    return $self;
}

sub build
{
  my( $self ) = @_;
  system("$self->{application} -C $self->{directory}") == 0 or die "Failed to compile";
}

sub test
{
  my( $self ) = @_;
  system("$self->{application} -C $self->{directory} test") == 0 or die "Tests failed";
}


1;