
use Test::More tests => 3;
BEGIN { use_ok('Business::BR::Biz::Common', '_dot') };

my @a = (1,1,1,1);
my @b = (1,1,1,1);

is(_dot(\@a, \@b), 4, "_dot works");

my @c = (1,1,1,1,1);
is(_dot(\@a, \@c), 4, "_dot works for \@a < \@b");

#my @d = (1,1,1);
#is(_dot(\@a, \@d), 3, "_dot complains but works for \@a > \@b");

