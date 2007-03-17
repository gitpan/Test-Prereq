# $Id: prereq_ok.t 1564 2005-03-08 05:16:57Z comdog $

use Test::Prereq;
prereq_ok( undef, undef, [ qw(CPANPLUS::Internals::System) ] );
