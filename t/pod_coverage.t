# $Id: pod_coverage.t,v 1.2 2005/03/08 05:14:25 comdog Exp $

use Test::More;
eval "use Test::Pod::Coverage";

if( $@ )
	{
	plan skip_all => "Test::Pod::Coverage required for testing POD";
	}
else
	{
	plan tests => 2;

	pod_coverage_ok( "Test::Prereq" );
	
	pod_coverage_ok( "Test::Prereq::Build",
		{ trustme => [ qr/create_build_script|prereq_ok/ ] } );
	}
	
