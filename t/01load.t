# $Id$

use Test::More tests => 2;

use_ok('HTML::FormatText::WithLinks');

my $f = HTML::FormatText::WithLinks->new();

ok($f, 'objected created');
