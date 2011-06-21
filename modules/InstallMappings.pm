=head1 NAME

InstallMappings.pm   - Return mappings between repository file locations and target location

=head1 SYNOPSIS

use InstallMappings;
my $install_mappings = InstallMappings->new(production_directories => { 
      production_bin    => '/software/pathogen/internal/prod/bin'
    });
my %repo_file_to_server_directory = %{$install_mappings->get_install_mappings()};

=cut

package InstallMappings;

use strict;
use warnings;

sub new
{
    my ($class,@args) = @_;
    my $self = @args ? {@args} : {};
    bless $self, ref($class) || $class;

    return $self;
}

sub get_install_mappings
{
  my( $self ) = @_;
  my %install_mappings =
    (
      general => {
        perl => [
                  ['cgi/map_request.pl', "$self->{production_directories}{production_bin}"],
                  ['modules/GoogleDocument.pm', "$self->{production_directories}{production_lib}"]
                ],
        java => []
      }
    );

  return \%install_mappings;
} 

1;