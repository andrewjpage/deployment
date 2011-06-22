#!/usr/bin/env perl

=head1 NAME

deploy.pl

=head1 SYNOPSIS

deploy -e [test|production]

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
use Getopt::Long;
use Deploy::GlobalConfigSettings;
use Deploy::InstallMappings;
use Deploy::Repository;
use Deploy::Make;
use Deploy::Documentation;
use Deploy::CopyFiles;

my $ENVIRONMENT;

GetOptions ('environment|e=s'    => \$ENVIRONMENT);  
	   
$ENVIRONMENT or die <<USAGE;
Usage: $0 [options]
Build, test, create documentation and install files.

 Options:
     --environment		   The configuration settings you wish to use (test|production)

USAGE
;


# initialise settings
my %config_settings = %{Deploy::GlobalConfigSettings->new(environment => $ENVIRONMENT)->get_config_settings()};
my %repo_file_to_server_directory = %{Deploy::InstallMappings->new(
    environment => $ENVIRONMENT,
    directories => $config_settings{directories}
  )->get_install_mappings()};

# checkout local copy of code
my $repository = Deploy::Repository->new(
  application        => $config_settings{application_locations}{source_control}, 
  url                => $config_settings{general}{repository}{url},
  branch             => $config_settings{general}{repository}{branch},
  checkout_directory => $config_settings{checkout_directory});
$repository->clone();
$repository->checkout();

# build and test 
for my $directory (@{$config_settings{general}{directories_to_build}}) {
  my $make = Deploy::Make->new(
    application => $config_settings{application_locations}{make},
    directory => "$config_settings{checkout_directory}/$directory"
  );
  $make->build;
  $make->test;
}

# create and install documenation
my $documenation = Deploy::Documentation->new(
    perl                                  => $config_settings{application_locations}{perl},
    natural_docs                          => $config_settings{application_locations}{natural_docs},
    checkout_directory                    => $config_settings{checkout_directory},
    output_directory                      => $config_settings{directories}{documentation},
    documentation_configuration_directory => $config_settings{checkout_directory}."/docs/nd/"
  );
$documenation->create_and_install(); 

# install code by copying to remote server
my $copy_files = Deploy::CopyFiles->new(
    application => $config_settings{application_locations}{scp},
    user        => $config_settings{deployment}{user},
    server      => $config_settings{deployment}{server}
  );
foreach my $directory (@{$config_settings{general}{directories_to_build}}) {
  for my $mappings (@{$repo_file_to_server_directory{general}{$directory}})
  {
    $copy_files->copy($config_settings{checkout_directory}/$directory/$mappings->[0], $mappings->[1]);
  }
}

