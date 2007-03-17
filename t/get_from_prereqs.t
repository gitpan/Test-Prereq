# $Id: get_from_prereqs.t 1711 2005-12-26 04:02:35Z comdog $
use strict;

use Test::Prereq;
use Test::More tests => 1;

use lib qw(.);

print STDERR "\nThis may take awhile...\n";

my $modules = Test::Prereq->_get_from_prereqs( [ 'Tk' ] );

ok(1);
