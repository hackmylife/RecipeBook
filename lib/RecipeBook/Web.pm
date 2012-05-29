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
use HTTP::Session::Store::Memcached;
use HTTP::Session::State::Cookie;
use Digest::SHA qw//;
use Cache::Memcached::Fast;

our $EXPIRE = 60 * 60 * 24; #1day

sub get_session {
    my ($self, $c) = @_;
    $self->{_session} ||= HTTP::Session->new(
        store   => HTTP::Session::Store::Memcached->new(
            memd => Cache::Memcached::Fast->new({
                servers => ['127.0.0.1:11211'],
            }),
        ),
        state   => HTTP::Session::State::Cookie->new(
            cookie_key => 'recipe_book_sid'
        ),
        request => $c->req,
    );
}

sub cache {
    my ($self) = @_;
    $self->{_cache} ||= new Cache::Memcached::Fast({
      servers => ['localhost:11211'],
    });
}

filter 'set_title' => sub {
    my $app = shift;
    sub {
        my ( $self, $c )  = @_;
        my $session = $self->get_session($c);
        my $id = $session->get("list_id");
        $c->stash->{list_id} = $id;
        $c->stash->{site_name} = 'RecipeBook';
        $app->($self,$c);
    }
};

get '/' => [qw/set_title/] => sub {
    my ( $self, $c )  = @_;
    $c->render('index.tx', {});
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
    my $cache = $self->cache;
    while ( my $result = $search->next ) {
        next unless $result->uri =~ m|http://cookpad.com/recipe/|;
        my $key = substr Digest::SHA::sha1_hex( $result->uri ), 0, 16;
        my $item = $cache->get($key);
        unless ( $item ) {
            $item = RecipeBook::Parser::Cookpad->parse( $result->uri );
            $cache->set($key, $item, $EXPIRE); #1day
        }
        push @recipes, $item;
        $count++;
        last if $count >= 2;
    }
    $c->render('index.tx', { recipes => \@recipes });
};

post '/add' => [qw/set_title/] => sub {
    my ( $self, $c ) = @_;
    my $result = $c->req->validator([
        'uri' => {
            rule => [
                ['NOT_NULL', 'empty uri'],
            ],
        }
    ]);
    if ( $result->has_error ) {
        return $c->render_json({ error => 1, messages => $result->errors });
    };
    my $session = $self->get_session($c);
    my $id = $session->get("list_id") ||
             substr Digest::SHA::sha1_hex( time() . rand(1000) ), 0, 16;
    my $cache = $self->cache;
    my $list = $cache->get($id) || ();
    push @$list, $result->valid('uri');
    $list = $cache->set($id, $list, $EXPIRE);
    $session->set("list_id", $id);
    $c->render_json({ error => 0, messages => 'stored', location => $c->req->uri_for("/list/")->as_string() });
};

post '/remove' => [qw/set_title/] => sub {
    my ( $self, $c ) = @_;
    my $result = $c->req->validator([
        'uri' => {
            rule => [
                ['NOT_NULL', 'empty uri'],
            ],
        }
    ]);
    if ( $result->has_error ) {
        return $c->render_json({ error => 1, messages => $result->errors });
    };
    my $session = $self->get_session($c);
    my $id = $session->get("list_id") ||
             substr Digest::SHA::sha1_hex( time() . rand(1000) ), 0, 16;
    my $cache = $self->cache;
    my $list = $cache->get($id) || ();
    my @new_list = grep { $_ ne $result->valid('uri') } @$list;
    $list = $cache->set($id, \@new_list, $EXPIRE);
    $session->set("list_id", $id);
    $c->render_json({ error => 0, messages => 'stored', location => $c->req->uri_for("/list/")->as_string() });
};

get '/list/' => [qw/retrieve_list/] => sub {
    my ( $self, $c ) = @_;
    $c->render('list.tx');
};

get '/list/{id}' => [qw/retrieve_list/] => sub {
    my ( $self, $c ) = @_;
    $c->render('list.tx');
};

filter 'retrieve_list' => sub {
    my $app = shift;
    sub {
        my ( $self, $c ) = @_;
        my $id = $c->args->{id};
        unless ($id) {
            my $session = $self->get_session($c);
            $id = $session->get("list_id");
        }
        my $cache = $self->cache;
        my $list = $cache->get($id);
        my @recipes;
        foreach my $uri ( @$list ) {
            my $key = substr Digest::SHA::sha1_hex( $uri ), 0, 16;
            my $item = $cache->get($key);
            unless ( $item ) {
                $item = RecipeBook::Parser::Cookpad->parse( $uri );
                $cache->set($key, $item, 60 * 60 * 24); #1day
            }
            push @recipes, $item;
        }
        $c->stash->{ recipes } = \@recipes;
        $c->stash->{ list_id } = $id;
        $app->($self, $c);
    };
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

