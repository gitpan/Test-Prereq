# $Id: get_from_file.t,v 1.1 2002/09/12 10:11:07 comdog Exp $

use Test::More tests => 2;

use Test::Prereq;

my $modules = Test::Prereq::_get_from_file( 't/pod.t' );
ok(
  eq_array( $modules, [ qw( File::Find::Rule Test::More Test::Pod ) ] ),
  'Right modules for t/pod.t'
	);

$modules = Test::Prereq::_get_from_file( 'lib/Prereq.pm' );
ok(
  eq_array( $modules, [ qw( File::Find::Rule Module::CoreList Module::Info Test::Builder ) ] ),
  'Right modules for t/Prereq.pm'
	);
