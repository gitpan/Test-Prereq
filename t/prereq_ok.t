# $Id: prereq_ok.t,v 1.2 2002/10/11 00:34:51 comdog Exp $

use Test::More tests => 1;

use Test::Prereq;

prereq_ok( undef, undef, [ qw(CPANPLUS::Internals::System) ] );
