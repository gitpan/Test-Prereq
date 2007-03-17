# $Id: load.t 2209 2007-03-17 05:47:05Z comdog $
BEGIN {
	@classes = qw(Test::Prereq Test::Prereq::Build);
	}

use Test::More tests => 2 * scalar @classes;

foreach my $class ( @classes )
	{
	undef &main::prereq_ok;
	print "bail out! Could not compile $class!" unless use_ok( $class );
	ok( defined &main::prereq_ok, "prereq_ok imported" );
	}
