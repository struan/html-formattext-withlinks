use strict;
use Module::Build;

Module::Build
    ->new(
        module_name =>  "HTML::FormatText::LinksAsFootnotes",
        license     =>  'perl',
        requires    =>  {
                            'HTML::FormatText'    =>  0,
                            'HTML::TreeBuilder'   =>  0,
        },
        build_requires  =>  {
                            },
        )
    ->create_build_script;

