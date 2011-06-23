=head1 NAME

GlobalConfigSettings.pm   - Return configuration settings

=head1 SYNOPSIS

use GlobalConfigSettings;
my %config_settings = %{Deploy::GlobalConfigSettings->new(environment => 'test')->get_config_settings()};

=cut

package Deploy::GlobalConfigSettings;

use strict;
use warnings;
use Deploy::TimeStamp;
use File::Slurp;
use YAML::XS;

sub new
{
    my ($class,@args) = @_;
    my $self = @args ? {@args} : {};
    bless $self, ref($class) || $class;
    
    $self->{environment} = 'test' unless defined $self->{environment};

    return $self;
}

sub get_config_settings
{
  my( $self ) = @_;
  my %config_settings = %{ Load( scalar read_file("config/".$self->{environment}."/global.yml"))};

  my $time = Deploy::TimeStamp->new();
  $config_settings{checkout_directory} = $config_settings{checkout_directory}."/".$time->{formatted_time_stamp};
  $config_settings{formatted_time_stamp} = $time->{formatted_time_stamp};

  return \%config_settings;
} 

1;
