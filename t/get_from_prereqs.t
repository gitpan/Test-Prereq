# $Id: get_from_prereqs.t,v 1.1 2002/10/09 22:38:49 comdog Exp $
use strict;

use Test::More tests => 1;

use Test::Prereq;

use lib qw(.);

print STDERR "\nThis may take awhile...\n";

my $modules = Test::Prereq->_get_from_prereqs( [ 'Tk' ] );

ok(1);
