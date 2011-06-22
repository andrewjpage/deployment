=head1 NAME

Documentation.pm   - Create documentation and push to website

=head1 SYNOPSIS

use Deploy::Documentation;
documenation = Deploy::Documentation->new(
    perl                                  => '/usr/bin/perl',
    natural_docs                          => '/usr/bin/natural_docs',
    checkout_directory                    => '/tmp/123',
    output_directory                      => '/www/public_html',
    documentation_configuration_directory => '/tmp123/docs/nd/'
  );
documenation->create_and_install();

=cut

package Deploy::Documentation;

use strict;
use warnings;

sub new
{
    my ($class,@args) = @_;
    my $self = @args ? {@args} : {};
    bless $self, ref($class) || $class;

    die "Perl location must be specified" unless defined $self->{perl};
    die "Natural docs location must be specified" unless defined $self->{natural_docs};
    die "Checkout directory must be specified" unless defined $self->{checkout_directory};
    die "Output documentation directory must be specified" unless defined $self->{output_directory};
    die "Documentation configuration files directory must be specified" unless defined $self->{documentation_configuration_directory};

    return $self;
}

sub create_and_install
{
  my( $self ) = @_;
  system("$self->{perl} $self->{natural_docs} -i $self->{checkout_directory} -o HTML $self->{output_directory} -p $self->{documentation_configuration_directory} -s PathStyle") or die "Couldnt build documentation";
}

1;