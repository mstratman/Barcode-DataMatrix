use inc::Module::Install;

name     'Barcode-DataMatrix';
all_from 'lib/Barcode/DataMatrix.pm';
author   q{Mark A. Stratman <stratman@gmail.com>};
license  'perl';
perl_version '5.006';

requires 'Moo'             => '0';
requires 'Type::Tiny'      => '0';
requires 'Types::Standard' => '0';
requires 'Type::Utils'     => '0';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_install;
WriteAll;
