use strict;
use warnings;
use utf8;
use YAML;
use Test::More;
use Text::Diff;

use Data::Dumper;

use_ok $_ for qw(
    RecipeBook::Parser::Cookpad
);

my $got = RecipeBook::Parser::Cookpad->parse(["http://cookpad.com/recipe/816359"]);
$got = YAML::Dump( $got );
my $expected = YAML::Dump( [{
        title => 'サーモンとアボガドのヘルシー丼☆',
        uri   => 'http://cookpad.com/recipe/816359',
        image => 'http://d3921.cpcdn.com/recipes/816359/280/4c950a9e8eae6dd2b508f8e87356f4c3.jpg?u=742448&p=1337952172',
        description => 'わさびマヨネーズが決め手のサーモンとアボガド丼。簡単にできて、嫁にも大好評でした。hackmylife',
        ingredients => [
            {
                category => '',
                name => 'サーモン（柵）',
                quantity => '200g位',
            },
            {
                category => '',
                name => 'アボガド',
                quantity => '一個',
            },
            {
                category => '',
                name => 'レタス',
                quantity => '３枚ぐらい',
            },
            {
                category => '',
                name => '万能ネギ（あれば）',
                quantity => '少々',
            },
            {
                category => '',
                name => 'マヨネーズ',
                quantity => '大さじ６',
            },
            {
                category => '',
                name => 'わさび',
                quantity => '小さじ１（目安）',
            },
            {
                category => '',
                name => '醤油',
                quantity => '大さじ３',
            },
        ]
    }]
);

ok $got eq $expected, Text::Diff::diff(\$got, \$expected);

done_testing;



