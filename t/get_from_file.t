# $Id: get_from_file.t,v 1.2 2002/10/04 22:39:52 comdog Exp $

use Test::More tests => 2;

use Test::Prereq;

my $modules = Test::Prereq->_get_from_file( 't/pod.t' );
ok(
  eq_array( $modules, [ qw( File::Find::Rule Test::More Test::Pod ) ] ),
  'Right modules for t/pod.t'
	);

$modules = Test::Prereq->_get_from_file( 'lib/Prereq.pm' );
ok(
  eq_array( $modules, [ qw( File::Find::Rule Module::CoreList Module::Info Test::Builder ) ] ),
  'Right modules for t/Prereq.pm'
	);
