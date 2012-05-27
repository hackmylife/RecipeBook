package RecipeBook::Web;

use strict;
use warnings;
use utf8;
use Kossy;
use Google::Search;
use Data::Dumper;
use Encode qw//;
use RecipeBook::Parser::Cookpad;
use HTTP::Session;
use Cache::Memcached::Fast;

sub get_session {
    my ($self, $c) = @_;
    $self->{_session} ||= HTTP::Session->new(
        store   => HTTP::Session::Store::Memcached->new(
            memd => Cache::Memcached->new({
                servers => ['127.0.0.1:11211'],
            }),
        ),
        state   => HTTP::Session::State::Cookie->new(
            cookie_key => 'recipe_book_sid'
        ),
        request => $c->req,
    );
}


filter 'set_title' => sub {
    my $app = shift;
    sub {
        my ( $self, $c )  = @_;
        $c->stash->{site_name} = 'RecipeBook';
        $app->($self,$c);
    }
};

get '/' => [qw/set_title/] => sub {
    my ( $self, $c )  = @_;
    $c->render('index.tx', { });
};

get '/search' => [qw/set_title/] => sub {
    my ( $self, $c )  = @_;
    my $result = $c->req->validator([
        'word' => {
            rule => [
                ['NOT_NULL','empty word'],
            ],
        },
    ]);
    if ( $result->has_error ) {
        return $c->render_json({ error => 1, messages => $result->errors });
    }
    my $search = Google::Search->Web( query => $result->valid('word') . ' site:cookpad.com' );

    my @recipes;
    my $count = 0;
    while ( my $result = $search->next ) {
        next unless $result->uri =~ m|http://cookpad.com/recipe/|;
        my $item = RecipeBook::Parser::Cookpad->parse( $result->uri );
        push @recipes, $item;
        $count++;
        last if $count >= 2;
    }
    $c->render('index.tx', { recipes => \@recipes });
};

get '/json' => sub {
    my ( $self, $c )  = @_;
    my $result = $c->req->validator([
        'q' => {
            default => 'Hello',
            rule => [
                [['CHOICE',qw/Hello Bye/],'Hello or Bye']
            ],
        }
    ]);
    $c->render_json({ greeting => $result->valid->get('q') });
};

1;

