# $Id: get_from_file.t,v 1.7 2004/02/20 10:27:38 comdog Exp $

use Test::More tests => 2;

use Test::Prereq;

my $modules = Test::Prereq->_get_from_file( 't/pod.t' );
my @modules = grep ! /^CPANPLUS/, @$modules;

print STDERR "Did not find right modules from t/pod.t!\n" .
	"Found <@modules>\n" unless
	ok(
		eq_array( \@modules, [] ),
			'Right modules for t/pod.t'
			);

$modules = Test::Prereq->_get_from_file( 'lib/Prereq.pm' );
@modules = grep ! /^CPANPLUS/, @$modules;

print STDERR "Did not find right modules for lib/Prereq.pm!\n" .
	 "Found <@modules>\n" unless
		ok(
			eq_array( \@modules, [ 
			qw( Module::CoreList Module::Info ) ] ),
			'Right modules for t/Prereq.pm'
			);
