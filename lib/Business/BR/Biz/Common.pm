
package Business::BR::Biz::Common;

use 5;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

#our %EXPORT_TAGS = ( 'all' => [ qw() ] );
#our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
#our @EXPORT = qw();

our @EXPORT_OK = qw( _dot );

our $VERSION = '0.00_03';

sub _dot {
  my $a = shift;
  my $b = shift;
  my $s = 0;
  for ( my $i=0; $i<@$a; $i++ ) {
    $s += $a->[$i]*$b->[$i];
  }
  return $s;
}


1;

__END__

=head1 NAME

Business::BR::Biz::Common - common code used in biz-br modules

=head1 SYNOPSIS

  use Business::BR::Biz::Common qw(_dot);
  my @digits = (1, 2, 3, 3);
  my @weights = (2, 3, 2, 2);
  my $dot = _dot(\@weights, \@digits); # computes 2*1+3*2+3*2+2*3


=head1 DESCRIPTION

This module is meant to be private for biz-br distributions.
It is a common placeholder for code which is shared among
other modules of the distribution.

Actually, the only code here is the computation of the
scalar product between two array refs. In the future,
this module can disappear being more aptly named and
even leave the Business::BR namespace.

=over 4

=item B<_dot>

  $s = dot(\@a, \@b);

Computes the scalar (or dot) product of two array refs:

   sum( a[i]*b[i], i = 0..$#a )

Note that due to this definition, the second argument 
should be at least as long as the first argument.

=back

=head2 EXPORT

None by default. 

You can explicitly ask for C<_dot()> which
is a sub to compute the dot product between two array refs
(used for computing check digits).


=head1 SEE ALSO

Please reports bugs via CPAN RT, 
http://rt.cpan.org/NoAuth/Bugs.html?Dist=biz-br

=head1 AUTHOR

A. R. Ferreira, E<lt>ferreira@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by A. R. Ferreira

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.


=cut
