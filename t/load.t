# $Id: load.t,v 1.3 2004/02/20 10:27:38 comdog Exp $
BEGIN {
	@classes = qw(Test::Prereq);
	}

use Test::More tests => scalar @classes;

foreach my $class ( @classes )
	{
	print "bail out! Could not compile $class!" unless use_ok( $class );
	}
