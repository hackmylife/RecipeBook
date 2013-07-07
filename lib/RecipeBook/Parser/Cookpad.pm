package RecipeBook::Parser::Cookpad;

use strict;
use Web::Scraper::LibXML;
use Web::Scraper;
use URI;
use Encode qw//;
use Data::Dumper;
use LWP::UserAgent;
use Coro;
use AnyEvent::HTTP::LWP::UserAgent;


HTML::TreeBuilder::LibXML->replace_original();

sub parse {
    my ($self, $urls) = @_;
    #my $ua = LWP::UserAgent->new;
    my $ua = AnyEvent::HTTP::LWP::UserAgent->new;
    my @coro = map {
        my $uri = $_;
        async {
            my $recipe = scraper {
                process ".recipe-title", title => "TEXT";
                process "#main-photo img", image => '@src';
                process "#description", description => "TEXT";
                process "div#ingredients .ingredient_row", "ingredients[]" => scraper {
                    process ".ingredient_category", category => "TEXT",
                    process ".ingredient_name", name => "TEXT",
                    process ".ingredient_quantity", quantity => "TEXT",
                }
            };

            my $response = $ua->get($uri);
            my $html = $response->decoded_content;
            $html =~ s!</html>.*!</html>!s;
            my $res = $recipe->scrape( \$html );

            my @ingredients;
            foreach my $item (@{$res->{ingredients}}) {
                push @ingredients, {
                    category => _trim_space( $item->{category}) || '',
                    name => _trim_space( $item->{name}) || '',
                    quantity => _trim_space( $item->{quantity}) || '',
                }
            };

            terminate +{
                title => _trim_space( $res->{title}),
                uri   => $uri,
                image => $res->{image},
                description => _trim_space( $res->{description} ),
                ingredients => \@ingredients,
            }
        }
    }  @$urls;
    my @result;
    push @result, $_->join for @coro;
    return \@result;
}

sub _trim_space {
    my $str = shift;
    $str =~ s/^\s*//g;
    $str =~ s/\s*$//g;
    $str =~ s/\n//g;
    $str =~ s/\s+/ /g;
    return $str;
}

1;
