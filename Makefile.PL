use inc::Module::Install;

name     'Barcode-DataMatrix';
all_from 'lib/Barcode/DataMatrix.pm';
author   q{Mark A. Stratman <stratman@gmail.com>};
license  'perl';

requires 'Moose' => '2.1200';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_install;
WriteAll;
