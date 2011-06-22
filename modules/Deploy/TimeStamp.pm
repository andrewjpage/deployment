=head1 NAME

TimeStamp.pm   - A formatted timestamp which allows for easy sorting when used as part of a filename or directory

=head1 SYNOPSIS

use TimeStamp;
my $time = TimeStamp->new();
$time->{formatted_time_stamp};

=cut

package Deploy::TimeStamp;

use strict;
use warnings;
use POSIX qw/strftime/;

sub new
{
    my ($class,@args) = @_;
    my $self = @args ? {@args} : {};
    bless $self, ref($class) || $class;
    $$self{formatted_time_stamp} = long_date_time();

    return $self;
}

sub long_date_time
{
  strftime('%Y%m%d%H%M%S',localtime);
}

1;
