
package Business::BR::CNPJ;

use 5;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

#our %EXPORT_TAGS = ( 'all' => [ qw() ] );
#our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
#our @EXPORT = qw();

our @EXPORT_OK = qw( flatten_cnpj format_cnpj parse_cnpj );
our @EXPORT = qw( test_cnpj );

our $VERSION = '0.00_03';

use Scalar::Util qw(looks_like_number); 

use Business::BR::Biz::Common qw(_dot);

sub flatten_cnpj {
  my $cnpj = shift;
  if (looks_like_number($cnpj) && int($cnpj)==$cnpj) {
	  return sprintf('%014s', $cnpj)
  }
  $cnpj =~ s/\D//g;
  return $cnpj;
}   

# there is a subtle difference here between the return for
# for an input which is not 14 digits long (undef)
# and one that does not satisfy the check equations (0).
# Correct CNPJ numbers return 1.
sub test_cnpj {
  my $cnpj = flatten_cnpj shift;
  return undef if length $cnpj != 14;
  my @cnpj = split '', $cnpj;
  my $s1 = _dot([5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], \@cnpj) % 11;
  my $s2 = _dot([6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2, 1], \@cnpj) % 11;
  unless ($s1==0 || $s1==1 && $cnpj[12]==0) {
    return 0;
  }
  return ($s2==0 || $s2==1 && $cnpj[13]==0) ? 1 : 0;
}


sub format_cnpj {
  my $cnpj = flatten_cnpj shift;
  $cnpj =~ s|^(..)(...)(...)(....)(..).*|$1.$2.$3/$4-$5|;
  return $cnpj;
}

sub parse_cnpj {
  my $cnpj = flatten_cnpj shift;
  my ($base, $filial, $dv) = $cnpj =~ /(\d{8})(\d{4})(\d{2})/;
  if (wantarray) {
    return ($base, $filial, $dv);
  }
  return { base => $base, filial => $filial, dv => $dv };
}


1;

__END__

=head1 NAME

Business::BR::CNPJ - Perl module to test for correct CNPJ numbers

=head1 SYNOPSIS

  use Business::BR::CNPJ; 

  print "ok " if test_cnpj('90.117.749/7654-80'); # prints 'ok '
  print "bad " unless test_cnpj('88.222.111/0001-10'); # prints 'bad '

=head1 DESCRIPTION

The CNPJ number is an identification number of Brazilian companies
emitted by the Brazilian Ministry of Revenue, which is called
"Minist�rio da Fazenda".

CNPJ stands for "Cadastro Nacional de Pessoa Jur�dica" (literally,
national juridical person registration) as opposed to the CPF number 
for natural persons. Sometime ago, it was called CGC ("Cadastro Geral
de Contribuinte" or general taxpayer registration).

The CNPJ is comprised of a base of 8 digits, a 4-digits radical 
and 2 check digits. It is usually written like '11.111.111/0001-55' 
so as to be more human-readable.

This module provides C<test_cnpj> for checking that a CNPJ number
is I<correct>. Here a I<correct CNPJ number> means

=over 4

=item *

it is 14 digits long

=item *

it satisfies the two check equations mentioned below

=back

Before checking, any non-digit letter is stripped, making it
easy to test formatted entries like '11.111.111/0001-55' and
entries with extra blanks like '   11.111.111/0001-55  '.

=over 4

=item B<test_cnpj>

  test_cnpj('999.444.333-55') # incorrect CPF, returns 0
  test_cnpj(' 263.946.533-30 ') # is ok, returns 1
  test_cnpj('888') # nope, returns undef

Tests whether a CNPJ number is correct. Before testing,
any non-digit character is stripped. Then it is
expected to be 14 digits long and to satisfy two
check equations which validate the last two check digits.
See L</"THE CHECK EQUATIONS">.

The policy to get rid of '.', '/' and '-' is very liberal. 
It indeeds discards anything that is not a digit (0, 1, ..., 9).
That is handy for discarding spaces as well. 

  test_cpf(' 263.946.533-30 ') # is ok, returns 1

But extraneous inputs like '#333%444*2a3s2z~00' are
also accepted. If you are worried about this kind of input,
just check against a regex:

  warn "bad CPF: only digits (14) expected" 
    unless ($cpf =~ /^\d{14}$/);

  warn "bad CPF: does not match mask '__.___.___/____-__'" 
    unless ($cpf =~ /^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}$/);

NOTE. Integer numbers like 9999811299 (or 99_998_112_99) 
with fewer than 14 digits will be normalized (eg. to
99_999_999_9999_99) before testing.

=item B<flatten_cnpj>

  flatten_cnpj(99); # returns '00000000099'
  flatten_cnpj('999.999.999-99'); # returns '99999999999'

Flattens a candidate for a CNPJ number. In case,
the argument is an integer, it is formatted to at least
fourteen digits. Otherwise, it is stripped of any non-digit
characters and returned as it is.

=item B<format_cnpj>

  format_cnpj('00 000 000 0000 00'); # returns '00.000.000/0000-00'

Formats its input into '00.000.000/0000-00' mask.
First, the argument is flattened and then
dots, slash and hyphen are added to the first
14 digits of the result.

=item B<parse_cnpj>

  ($base, $filial, $dv) = parse_cnpj($cpf);
  $hashref = parse_cnpj('11.222.333/4444-00'); # { base => '11222333', filial => '4444' dv => '00' }

Splits a candidate for CNPJ number into base, radical and check
digits (dv - d�gitos de verifica��o). It flattens
the argument before splitting it into 8-, 4- and 2-digits
parts. In a list context,
returns a three-element list with the base, the radical and the check
digits. In a scalar context, returns a hash ref
with keys 'base', 'filial' and 'dv' and associated values.

=back

=head2 EXPORT

C<test_cnpj> is exported by default. C<flatten_cnpj>, C<format_cnpj>,
and C<parse_cnpj> can be exported on demand.


=head1 THE CHECK EQUATIONS

A correct CNPJ number has two check digits which are computed
from the 12 first digits. Consider the CNPJ number 
written as 14 digits

  c[1] c[2] c[3] c[4] c[5] c[6] c[7] c[8] c[9] c[10] c[11] c[12] dv[1] dv[2]

To check whether a CNPJ is correct or not, it has to satisfy 
the check equations:

  5*c[1]+4*c[2]+3*c[3]+2*c[4]+9*c[5]+
  8*c[6]+7*c[7]+6*c[8]+5*c[9]+4*c[10]+
                      3*c[11]+2*c[12]+dv[1] = 0 (mod 11) or
                                            = 1 (mod 11) (if dv[1]=0)

and 

  6*c[1]+5*c[2]+4*c[3]+3*c[4]+2*c[5]+
  9*c[6]+8*c[7]+7*c[8]+6*c[9]+5*c[10]+
              4*c[11]+3*c[12]+2*dv[1]+dv[2] = 0 (mod 11) or
                                            = 1 (mod 11) (if dv[2]=0)

=head1 BUGS

I heard that there are exceptions of CNPJ numbers which don't
obey the check equations and are still authentic. I have never found
one of them. 

=head1 SEE ALSO

To make sure this module works, one can try the results obtained against 
those found with  "Emiss�o de Comprovante de Inscri��o e de Situa��o Cadastral
de Pessoa Jur�dica", 
a web page which the Brazilian Ministry of Revenue provides for public 
consultation on regularity status of the taxpayer.
This page tells if the CNPJ number is a correct entry (14-digits-long with verified
check digits), if it references a real company and if it is regular
with the government body. 

Given a bad CNPJ, the after-submit page tells "O n�mero do CNPJ n�o � v�lido"
(the CNPJ number is not valid).
If the CNPJ is a good one but does not reference a real company,
it says "CNPJ n�o existe em nossa base de dados" (CNPJ does not exist
in our database). Otherwise, it shows a details form for the identified
taxpayer.

Note that this module only tests correctness.
It doesn't enter the merit whether the CNPJ number actually exists
at the Brazilian government databases. 

As you might have guessed, this is not the first Perl module
to approach this kind of functionality. Take a look at

  http://search.cpan.org/search?module=Brasil::Checar::CGC

Please reports bugs via CPAN RT, 
http://rt.cpan.org/NoAuth/Bugs.html?Dist=biz-br
By doing so, the author will receive your reports and patches, 
as well as the problem and solutions will be documented.

=head1 AUTHOR

A. R. Ferreira, E<lt>ferreira@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by A. R. Ferreira

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.


=cut
