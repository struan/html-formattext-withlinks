# $Id$

use Test::More tests => 5;
use HTML::FormatText::WithLinks;

my $html = new_html();
my $f = HTML::FormatText::WithLinks->new( leftmargin => 0, 
            before_link => "[%n] ",
            footnote => "[%n] %l");

ok($f, 'object created');

my $text = $f->parse($html);

my $correct_text = qq!This is a mail of some sort with a [1] link.



[1] http://example.com/


!;

ok($text, 'html formatted');
is($text, $correct_text, 'html correctly formatted');

$f = HTML::FormatText::WithLinks->new( leftmargin => 0, 
            before_link => "[%n] ",
            footnote    =>  '');

$text = $f->parse($html);

$correct_text = qq!This is a mail of some sort with a [1] link.

!;

ok($text, 'html formatted');
is($text, $correct_text, 'html formatted with no footnotes');

sub new_html {
return <<'HTML';
<html>
<body>
<p>
This is a mail of some sort with a <a href="http://example.com/">link</a>.
</p>
</body>
</html>
HTML
}
