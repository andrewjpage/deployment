=head1 NAME

InstallMappings.pm   - Return mappings between repository file locations and target location

=head1 SYNOPSIS

use InstallMappings;
my $install_mappings = InstallMappings->new(
   environment => 'test',
   directories => { 
      production_bin    => '/software/pathogen/internal/prod/bin'
    });
my %repo_file_to_server_directory = %{$install_mappings->get_install_mappings()};

=cut

package Deploy::InstallMappings;

use strict;
use warnings;
use File::Slurp;
use YAML::XS;

sub new
{
    my ($class,@args) = @_;
    my $self = @args ? {@args} : {};
    bless $self, ref($class) || $class;
    
    $self->{environment} = 'test' unless defined $self->{environment};
    die "References to directories must be passed in" unless defined $self->{directories};

    return $self;
}

sub get_install_mappings
{
  my( $self ) = @_;
  my %install_mappings = %{ Load( scalar read_file("config/".$self->{environment}."/mappings.yml"))};
  
  # replace references to directories with explicit paths
  foreach my $directory (keys %{$install_mappings{general}}) {
    for my $mappings ( @{$install_mappings{general}{$directory}})
    {
      $mappings->[1] = $self->{directories}{$mappings->[1]};
    }
  }

  return \%install_mappings;
}


1;