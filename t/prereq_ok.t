# $Id: prereq_ok.t,v 1.4 2004/02/20 10:27:38 comdog Exp $
local $^W = 0;

use Test::More;
eval "use Test::Prereq";
plan skip_all => "Test::Prereq required to test dependencies" if $@;

prereq_ok( undef, undef, [ qw(CPANPLUS::Internals::System) ] );
