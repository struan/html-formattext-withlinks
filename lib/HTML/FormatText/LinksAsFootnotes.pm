package HTML::FormatText::LinksAsFootnotes;

# $Id$

use strict;
use URI::WithBase;
use HTML::TreeBuilder;
use base qw(HTML::FormatText);
use vars qw($VERSION);

$VERSION = '0.01';

sub configure {

    my ($self, $hash) = @_;

    # a base uri so we can resolve relative uris
    $self->{base} = $hash->{base};
    delete $hash->{base};
    $self->{base} =~ s#(.*?)/[^/]*$#$1/# if $self->{base};

    $self->SUPER::configure($hash);

}

# we need to do this as if you pass an HTML fragment without any
# containing block level markup (e.g. a p tag) then no indentation
# takes place so we grab out inital cursor position and then if
# no indentation has taken place when we hit text we indent and then
# carry on as normal
sub start {
    my $self = shift;
    $self->{start_pos} = $self->{cur_pos};
    $self->SUPER::start(@_);
}

sub textflow {
    my $self = shift;
    $self->goto_lm unless defined $self->{cur_pos} 
                   and $self->{cur_pos} > $self->{start_pos};
    $self->SUPER::textflow(@_);
}

sub a_start {

    my $self = shift;
    my $node = shift;
    # local urls are no use so we have to make them absolute
    my $href = $node->attr('href') || '';
    if ($href =~ m#^http:|^mailto:#) {
        push @{$self->{_links}}, $href;
    } else {
        my $u = URI::WithBase->new($href, $self->{base});
        push @{$self->{_links}}, $u->abs();
    }
    $self->out( '[' . $#{$self->{_links}} .'] ' );
    $self->SUPER::a_start();

}

# print out our links
sub html_end {

    my $self = shift;
    if ( $self->{_links} ) {
        $self->nl; $self->nl; # be tidy
        $self->goto_lm;
        for (0 .. $#{$self->{_links}}) {
            $self->goto_lm;
            $self->out("[$_] ". $self->{_links}->[$_]);
            $self->nl;
        }
    }
    $self->SUPER::end();

}

sub parse {

    my $self = shift;
    my $text = shift;

    my $tree = HTML::TreeBuilder->new->parse( $text );

    unless ( $tree ) {
        $self->error("HTML::TreeBuilder problem" . $! ? ": $!" : '');
        return undef;
    }

    return $self->format( $tree );

}

sub parse_file {

    my $self = shift;
    my $file = shift;

    unless (-e $file and -f $file) {
        $self->error("$file not found or not a regular file");
        return undef;
    }

    my $tree = HTML::TreeBuilder->new->parse_file( $file );
    
    unless ( $tree ) {
        $self->error("HTML::TreeBuilder problem" . $! ? ": $!" : '');
        return undef;
    }

    return $self->format( $tree );

}

sub error {
    my $self = shift;
    if (@_) {
        $self->{error} = shift;
    }
    return $self->{error};
}

1;

__END__

=head1 NAME 

HTML::FormatText::LinksAsFootnotes - HTML to text conversion with links as footnotes

=head1 SYNOPSIS

    use HTML::FormatText::LinksAsFootnotes

    my $f = HTML::FormatText::LinksAsFootnotes->new();

    my $html = qq(
    <html>
    <body>
    <p>
        Some html with a <a href="http://example.com/">link</a>
    </p>
    </body>
    </html>
    );

    my $text = $f->parse($html);

    print $text;

    # results in something like

    Some html with a [0] link

    [0] http://example.com/

=head1 DESCRIPTION

HTML::FormatText::LinksAsFootnotes takes HTML and turns it into plain text
but prints all the links in the HTML as footnotes. Essentially it attempts
to mimic the format of the lynx text based web browser's --dump option.

=head1 METHODS

=head2 new

    my $f = HTML::FormatText::LinksAsFootnotes->new( %options );

Returns a new instance. It accepts all the options of HTML::FormatText plus
a base option. This should be set to a URI which will be used to turn any 
relative URIs on the HTML to absolute ones.

=head2 parse

    my $text = $f->parse($html);

Takes some HTML and returns it as text. Returns undef on error.

=head2 parse_file

    my $text = $f->parse_file($filename);

Takes a filename and returns the contents of the file as plain text.
Returns undef on error.

=head2 error

    $f->error();

Returns the last error that occured. In practice this is likely to be 
either a warning that parse_file couldn't find the file or that
HTML::TreeBuilder failed.

=head1 CAVEATS

When passing HTML fragments the results may be a little unpredictable. 
I've tried to work round the most egregious of the issues but any 
unexpected results are welcome. 

=head1 AUTHOR

Struan Donald. E<lt>struan@cpan.orgE<gt>

L<http://www.exo.org.uk/code/>

Comments, the two parse routines and the required nudge to release all 
this came from Ian Malpass E<lt>ian@indecorous.comE<gt>.

=head1 COPYRIGHT

Copyright (C) 2003 Struan Donald. All rights reserved.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

perl(1), HTML::Formatter.

=cut
