# $Id: prior_plan.t,v 1.1 2005/03/08 05:16:57 comdog Exp $

use Test::More tests => 2;

use Test::Prereq;
prereq_ok( undef, undef, [ qw(CPANPLUS::Internals::System) ] );
ok(1);