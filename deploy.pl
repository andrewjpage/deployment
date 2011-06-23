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
use Net::SCP;
use Git::Repository;
use Deploy::GlobalConfigSettings;
use Deploy::InstallMappings;
use Deploy::Repository;
use Deploy::Make;
use Deploy::Documentation;

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

# checkout a local copy and tag last commit with timestamp
Git::Repository->run( clone => $config_settings{general}{repository}{url}, $config_settings{checkout_directory} );
my $repository = Git::Repository->new( work_tree => $config_settings{checkout_directory} );
$repository->run( checkout => $config_settings{general}{repository}{branch} );
$repository->run( tag => $ENVIRONMENT."_".$config_settings{formatted_time_stamp} );
$repository->run( push => origin => '--tags' );


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
my $scp_connection = Net::SCP->new( { host => $config_settings{deployment}{server}, user => $config_settings{deployment}{user}, interactive => 0 } ); 
for my $directory (@{$config_settings{general}{directories_to_build}}) {
  for my $mappings (@{$repo_file_to_server_directory{general}{$directory}})
  {
    $scp_connection->cwd($mappings->[1]);
    $scp_connection->put("$config_settings{checkout_directory}/$directory/$mappings->[0]") or die $scp_connection->{errstr};
  }
}

# cleanup working directories

