use inc::Module::Install;

name     'Barcode-DataMatrix';
all_from 'lib/Barcode/DataMatrix.pm';
author   q{Mark A. Stratman <stratman@gmail.com>};
license  'perl';

requires 'Any::Moose' => '0.15';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
githubmeta;
auto_include;
auto_install;
WriteAll;
