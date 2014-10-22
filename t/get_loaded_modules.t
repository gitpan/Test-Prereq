# $Id: get_loaded_modules.t,v 1.1 2002/09/12 10:11:07 comdog Exp $

use Test::More tests => 4;

use Test::Prereq;

{
my $modules = Test::Prereq::_get_loaded_modules( 'blib/lib', 't' );
my $keys = [ sort keys %$modules ];

ok(
  eq_array( $keys, 
		[ 
		qw( File::Find::Rule Module::CoreList Module::Info 
		Test::Builder Test::More Test::Pod Test::Prereq ) 
		] ),
	'Right modules for modules and tests'
	);
}

{
my $modules = Test::Prereq::_get_loaded_modules( );
my $okay = defined $modules ? 0 : 1;
ok( $okay, '_get_loaded_modules catches no arguments' );

   $modules = Test::Prereq::_get_loaded_modules( undef, 't' );
$okay = defined $modules ? 0 : 1;
ok( $okay, '_get_loaded_modules catches missing first arg' );

   $modules = Test::Prereq::_get_loaded_modules( 'blib/lib', undef );
$okay = defined $modules ? 0 : 1;
ok( $okay, '_get_loaded_modules catches missing second arg' );

}
