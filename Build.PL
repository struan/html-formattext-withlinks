use strict;
use Module::Build;

Module::Build
    ->new(
        module_name =>  "HTML::FormatText::WithLinks",
        license     =>  'perl',
        requires    =>  {
                            'HTML::FormatText'    =>  0,
                            'HTML::TreeBuilder'   =>  0,
                            'URI::WithBase'       =>  0,  
        },
        build_requires  =>  {
                            'Test::More'          =>  0,
                            },
        )
    ->create_build_script;

