=head1 NAME

Repository.pm   - Checkout a repository

=head1 SYNOPSIS

use Repository;
my $repository = Repository->new(
    application => '/usr/bin/svn', 
    url => 'svn+ssh://svn.internal.sanger.ac.uk/repos/svn/pathsoft/general/trunk', 
    checkout_directory => "/tmp/123");
$svn_repository->checkout;

Replace with Git::Repository

=cut

package Deploy::Repository;

use strict;
use warnings;

sub new
{
    my ($class,@args) = @_;
    my $self = @args ? {@args} : {};
    bless $self, ref($class) || $class;

    return $self;
}

sub clone
{
  my( $self ) = @_;
  system("$self->{application} clone $self->{url} $self->{checkout_directory}") == 0 or die "Failed to clone";
}

sub checkout
{
  my( $self ) = @_;
  system("cd $self->{checkout_directory} && $self->{application} checkout $self->{branch}") == 0 or die "Failed to checkout";
}

1;