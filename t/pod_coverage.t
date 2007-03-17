# $Id: pod_coverage.t 1564 2005-03-08 05:16:57Z comdog $

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
	
