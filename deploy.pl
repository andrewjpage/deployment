#!/software/bin/perl

=head1 NAME

deploy.pl

=head1 SYNOPSIS

deploy

=head1 DESCRIPTION

This will deploy a given repository into production. It checks out a clean copy, compiles the code and runs the tests.
If everything is okay, it installs the code to production and updates the documentation.  
It assumes that each subdirectory to be built has a makefile in the root and the tests directory.

=head1 CONTACT

path-help@sanger.ac.uk

=head1 METHODS

=cut
package Deploy;

BEGIN { unshift(@INC, './modules') }
use strict;
use warnings;
use GlobalConfigSettings;
use InstallMappings;
use SvnRepository;

# initialise settings
my %config_settings = %{GlobalConfigSettings->new()->get_config_settings()};
my %repo_file_to_server_directory = %{InstallMappings->new(
    production_directories => $config_settings{production_directories}
  )->get_install_mappings()};

# checkout local copy of code
SvnRepository->new(
  application        => $config_settings{application_locations}{svn}, 
  url                => $config_settings{general}{repository}{url}, 
  checkout_directory => $config_settings{checkout_directory})->checkout;


foreach my $directory (@{$config_settings{general}{directories_to_build}}) {
  # make
  system("$config_settings{application_locations}{make} -C $config_settings{checkout_directory}/$directory") == 0 or die "Failed to compile";
  # make test
  system("$config_settings{application_locations}{make} -C $config_settings{checkout_directory}/$directory test ") == 0 or die "Tests failed";
}

# install code
foreach my $directory (@{$config_settings{general}{directories_to_build}}) {
  for my $mappings (@{$repo_file_to_server_directory{general}{$directory}})
  {
    # Need a test system before using this since it could overwrite production files
    #system("$config_settings{application_locations}{scp} $config_settings{checkout_directory}/$directory/$mappings->[0] pathinfo@pcs4:$mappings->[1]")
  }
}

# Create documentation
system("$config_settings{application_locations}{perl} $config_settings{application_locations}{natural_docs} -i $config_settings{checkout_directory} -o HTML $config_settings{production_directories}{documentation} -p $config_settings{checkout_directory}/docs/nd/ -s PathStyle")
