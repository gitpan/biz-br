
use Test::More tests => 5;
BEGIN { use_ok('Business::BR::CPF', 'flatten_cpf') };

is(flatten_cpf(99), '00000000099', 'amenable to ints');
is(flatten_cpf('999.999.999-99'), '99999999999', 'discards formatting');

is(flatten_cpf(111_222_333_444), '111222333444', 'too long ints pass through');
is(flatten_cpf('111_222_333_444'), '111222333444', 'as well as other too long inputs');

