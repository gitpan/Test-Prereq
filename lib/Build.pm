# $Id: Build.pm,v 1.10 2005/07/13 22:28:37 comdog Exp $
package Test::Prereq::Build;
use strict;

use base qw(Test::Prereq);
use vars qw($VERSION @EXPORT);

=head1 NAME

Test::Prereq::Build - test prerequisites in Module::Build scripts

=head1 SYNOPSIS

   use Test::Prereq::Build;
   prereq_ok();

=cut

$VERSION = sprintf "%d.%03d", q$Revision: 1.10 $ =~ /(\d+)\.(\d+)/;

use Module::Build;
use Test::Builder;

my $Test = Test::Builder->new;

=head1 METHODS

If you have problems, send me your Build.PL.

This module overrides methods in Test::Prereq to make it work with
Module::Build.

This module does not have any public methods.  See L<Test::Prereq>.

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT

Copyright 2002-2005 brian d foy, All rights reserved

You can use this software under the same terms as Perl itself.

=cut

sub import 
	{
    my $self   = shift;
    my $caller = caller;
    no strict 'refs';
    *{$caller.'::prereq_ok'}       = \&prereq_ok;

    $Test->exported_to($caller);
    $Test->plan(@_);
	}

sub prereq_ok
	{
	$Test->plan( tests => 1 ) unless $Test->has_plan;
	__PACKAGE__->_prereq_check( @_ );
	}

sub _master_file { 'Build.PL' }

# override Module::Build
sub Module::Build::new
	{
	my $class = shift;

	my %hash = @_;

	my @requires = sort grep $_ ne 'perl', (
		keys %{ $hash{requires} },
		keys %{ $hash{build_requires} },
		);

	@Test::Prereq::prereqs = @requires;

	# intercept further calls to this object
	return bless {}, __PACKAGE__;
	}

# fake Module::Build methods
sub create_build_script { 1 };

1;