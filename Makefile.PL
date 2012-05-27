use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'RecipeBook',
    VERSION_FROM  => 'lib/RecipeBook.pm',
    PREREQ_PM     => {
        'Kossy' =>  '0.09',
    },
    MIN_PERL_VERSION => '5.008001'
);

