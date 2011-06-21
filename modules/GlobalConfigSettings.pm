=head1 NAME

GlobalConfigSettings.pm   - Return configuration settings

=head1 SYNOPSIS

use GlobalConfigSettings;
my $global_config_settings = GlobalConfigSettings->new();
my %config_settings = %{$global_config_settings->get_config_settings()};

=cut

package GlobalConfigSettings;

use strict;
use warnings;
use TimeStamp;

sub new
{
    my ($class,@args) = @_;
    my $self = @args ? {@args} : {};
    bless $self, ref($class) || $class;

    return $self;
}

sub get_config_settings
{
  my( $self ) = @_;
  my $time = TimeStamp->new();
  
  my %config_settings =
    (
      general =>
      {
        repository => {
          url     => 'svn+ssh://svn.internal.sanger.ac.uk/repos/svn/pathsoft/general/trunk',
          type    => 'svn'
        },
        directories_to_build => ['perl','java']
      },
      checkout_directory => "/tmp/$time->{formatted_time_stamp}",
      production_directories => {
        production_bin    => '/software/pathogen/internal/prod/bin',
        production_lib    => '/software/pathogen/internal/prod/lib',
        preproduction_bin => '/software/pathogen/internal/preprod/bin',
        preproduction_lib => '/software/pathogen/internal/preprod/lib',
        documentation     => '/nfs/WWWdev/INTWEB_docs/htdocs/Teams/Team81/docs'
      },
      application_locations => {
        perl         => '/usr/bin/perl',
        natural_docs => '/usr/bin/NaturalDocs',
        svn          => '/usr/bin/svn',
        make         => '/usr/bin/make',
        scp          => '/usr/bin/scp'
      }
    );
    return \%config_settings;
} 

1;
