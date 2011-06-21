=head1 NAME

SvnRepository.pm   - Checkout an SVN repository

=head1 SYNOPSIS

use SvnRepository;
my $svn_repository = SvnRepository->new(
    application => '/usr/bin/svn', 
    url => 'svn+ssh://svn.internal.sanger.ac.uk/repos/svn/pathsoft/general/trunk', 
    checkout_directory => "/tmp/123");
$svn_repository->checkout;

=cut

package SvnRepository;

use strict;
use warnings;

sub new
{
    my ($class,@args) = @_;
    my $self = @args ? {@args} : {};
    bless $self, ref($class) || $class;

    return $self;
}

sub checkout
{
  my( $self ) = @_;
  system("$self->{application} checkout $self->{url} $self->{checkout_directory}") == 0 or die "Failed to checkout";
} 

1;