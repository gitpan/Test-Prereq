# $Id: prereq_ok.t,v 1.5 2005/03/08 05:14:25 comdog Exp $

use Test::Prereq;
prereq_ok( undef, undef, [ qw(CPANPLUS::Internals::System) ] );
