# $Id$

use Test::More tests => 3;
use HTML::FormatText::LinksAsFootnotes;

my $html = new_html();
my $f = HTML::FormatText::LinksAsFootnotes->new( leftmargin => 0, 
                                                 base => 'http://example.com/');

ok($f, 'object created');

my $text = $f->parse($html);

my $correct_text = qq!This is a mail of some sort with a [0] link.



[0] http://example.com/relative.html


!;

ok($text, 'html formatted');
is($text, $correct_text, 'html correctly formatted');

sub new_html {
return <<'HTML';
<html>
<body>
<p>
This is a mail of some sort with a <a href="/relative.html">link</a>.
</p>
</body>
</html>
HTML
}
