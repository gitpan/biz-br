
package Business::BR;

use 5;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

#our %EXPORT_TAGS = ( 'all' => [ qw() ] );
#our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
#our @EXPORT = qw();

our @EXPORT_OK = qw( _dot );

our $VERSION = '0.00_01';

# my $s = dot(\@a, \@b);
#
# computes the scalar product of two array refs
#
#   sum( a[i]*b[i], i = 0..$#a )
#
# Note that because of this definition, the
# second argument should be at least as long
# as the first argument.
#
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

Business::BR - base for other Business::BR modules

=head1 SYNOPSIS

  use Business::BR::CPF; # no public interface on Business::BR by now
  print "ok " if test_cpf('390.533.447-05'); 

  # used in Business::BR::* modules (don't rely on this for the future)
  use Business::BR qw(_dot);
  my @digits = (1, 2, 3, 3);
  my @weights = (2, 3, 2, 2);
  my $dot = _dot(\@weights, \@digits); # computes 2*1+3*2+3*2+2*3


=head1 DESCRIPTION

This module is meant to provide a root for other Business::BR
modules. By now, it doesn't provide any public interface, but 
it will.

If you want to see the action, take a look at Business::BR::CPF.

=head2 EXPORT

None by default. 

You can explicitly ask for C<_dot()> which
is a sub to compute the dot product between two array refs
(used for computing check digits).

=head1 TESTING CORRECTNESS

Among the functionalities to be made available in this distribution,
we'll have tests for correctness of typical identification numbers
and codes.

I<To be correct> will mean here to satisfy certain easily computed
rules. For example, a CPF number is correct if it is 11-digits-long
and satisfy two check equations which validate the check digits.

The modules C<Business::BB::*> will provide subroutines C<test_*>
for testing the correctness of such concepts. 

To be I<correct> does not mean that an identification number or code
had been I<verified> to stand for some real entry, like an actual 
Brazilian paytaxer citizen in the case of CPF. This would require
access to government databases which may or may not be available
in a public basis. And besides, to I<verify> something
will not be I<easily computed> in general, implying access to
databases and applying specialized rules.

Here we'll be trying to stick to a consistent terminology
and 'correct' will always be used for validity against syntactical
forms and shallow semantics. In turn, 'verified' will be used 
for telling if an entity really makes sense in the real world. 
This convention is purely arbitrary and for the sake of
being formal in some way. Terms like 'test', 'verify', 'check',
'validate', 'correct', 'valid' are often used interchangeably
in colloquial prose.

=head1 EXAMPLES

As a rule, the documentation and tests choose correct
identification codes which are verified to be invalid by the time
of the distribution update. That is, in Business::BR::CPF,
the mentioned correct CPF number '390.533.447-05' is correct,
but doesn't actually exist in government databases.


=head1 SEE ALSO

As you might have guessed, this is not the first Perl distribution
to approach this kind of functionality. Take a look at

  http://search.cpan.org/search?module=Brasil::Checar::CPF
  http://search.cpan.org/search?module=Brasil::Checar::CNPJ

The namespace has been chosen based on similar modules
for other countries, like Business::FR::SSN which tests
the French "Numéro de Sécurité Sociale" and 
the Business::AU::* modules.

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
