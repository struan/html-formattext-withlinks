# $Id$

use Test::More tests => 2;

use_ok('HTML::FormatText::LinksAsFootnotes');

my $f = HTML::FormatText::LinksAsFootnotes->new();

ok($f, 'objected created');
