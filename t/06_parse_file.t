# $Id$

use Test::More tests => 3;
use HTML::FormatText::LinksAsFootnotes;

my $f = HTML::FormatText::LinksAsFootnotes->new( leftmargin => 0 );

ok($f, 'object created');

my $text = $f->parse_file('t/file.html');

my $correct_text = qq!This is a mail of some sort with a [0] link.



[0] http://example.com/


!;

ok($text, 'html formatted');
is($text, $correct_text, 'html correctly formatted');
