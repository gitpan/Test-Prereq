# $Id: get_from_prereqs.t,v 1.2 2005/03/08 05:14:25 comdog Exp $
use strict;

use Test::Prereq;

use lib qw(.);

print STDERR "\nThis may take awhile...\n";

my $modules = Test::Prereq->_get_from_prereqs( [ 'Tk' ] );

ok(1);
