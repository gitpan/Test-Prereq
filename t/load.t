# $Id: load.t,v 1.4 2005/03/08 05:14:25 comdog Exp $
BEGIN {
	@classes = qw(Test::Prereq Test::Prereq::Build);
	}

use Test::More tests => scalar @classes;

foreach my $class ( @classes )
	{
	print "bail out! Could not compile $class!" unless use_ok( $class );
	}
