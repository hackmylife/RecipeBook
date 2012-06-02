use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'RecipeBook',
    VERSION_FROM  => 'lib/RecipeBook.pm',
    PREREQ_PM     => {
        'Kossy' =>  '0.09',
        'Google::Search' => 0,
        'HTTP::Session' => 0,
        'HTTP::Session' => 0,
        'Digest::SHA' => 0,
        'Cache::Memcached::Fast' => 0,
        'HTTP::Session::Store::Memcached' => 0,
        'HTTP::Session::State::Cookie' => 0,
        'Web::Scraper' => 0,
        'Web::Scraper::LibXML' => 0,
        'HTML::TreeBuilder::LibXML' => 0,
    },
    MIN_PERL_VERSION => '5.008001'
);

