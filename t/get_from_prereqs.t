# $Id: get_from_prereqs.t,v 1.3 2005/12/26 04:02:35 comdog Exp $
use strict;

use Test::Prereq;
use Test::More tests => 1;

use lib qw(.);

print STDERR "\nThis may take awhile...\n";

my $modules = Test::Prereq->_get_from_prereqs( [ 'Tk' ] );

ok(1);
