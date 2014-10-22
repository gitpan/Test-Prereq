#$Id: Prereq.pm,v 1.7 2002/10/08 07:23:23 comdog Exp $
package Test::Prereq;
use strict;

=head1 NAME

Test::Prereq - check if Makefile.PL has the right pre-requisites

=head1 SYNOPSIS

# if you use Makefile.PL
use Test::Prereq;
prereq_ok();

# if you use Module::Build
use Test::Prereq::Build;
prereq_ok();

=head1 DESCRIPTION

THIS IS ALPHA SOFTWARE.  IT HAS SOME PROBLEMS.

The prereq_ok() function examines the modules it finds in blib/lib/
and the test files it finds in t/.  It figures out which modules
they use, skips the modules that are in the Perl core, and compares
the remaining list of modules to those in the PREREQ_PM section of
Makefile.PL.  If you use Module::Build instead, see 
L<Test::Prereq::Build> instead.

Your Makefile.PL must end in a true value since prereq_ok() has to 
require() it to perform a bit of magic.  Not to worry---it will tell
you when you don't.

=cut

use base qw(Exporter);
use vars qw($VERSION @EXPORT @prereqs);

$VERSION = '0.11';
@EXPORT = qw( prereq_ok );

use Carp qw(carp);
use Exporter;
use ExtUtils::MakeMaker;
use File::Find::Rule;
use Module::CoreList;
use Module::Info;
use Test::Builder;

my $Test = Test::Builder->new;
	
my $Namespace = '';

sub ExtUtils::MakeMaker::WriteMakefile
	{
	my %hash = @_;
	
	my $name = $hash{NAME};
	my $hash = $hash{PREREQ_PM};
	
	$Namespace = $name;
	@Test::Prereq::prereqs   = sort keys %$hash;
	}
	
=head1 FUNCTIONS

=over 4

=item prereq_ok( [ VERSION, [ NAME [, SKIP_ARRAY] ] ] )

If you don't specify a version, prereq_ok assumes you want to compare
the list of prerequisite modules to version 5.6.1.

Valid version come from Module::CoreList (which uses $[):

        5.008
        5.00307
        5.00405
        5.00503
        5.007003
        5.004
        5.005
        5.006
        5.006001

prereq_ok attempts to remove modules found in blib and 
libraries found in t from the reported prerequisites.

The optional third argument is an array reference to a list of
names that prereq_ok should ignore. You might want to use this
if your tests do funny things with require.

=cut

my $default_version = '5.006001';
my $version         = '5.006001';

sub prereq_ok
	{
	__PACKAGE__->_prereq_check( @_ );
	}
	
sub _prereq_check
	{
	my $class   = shift;
	
	   $version  = shift || $default_version;
	my $name     = shift || 'Prereq test';
	my $skip     = shift || [];
	
	$version = $default_version unless 
		exists $Module::CoreList::version{$version};
	
	unless( UNIVERSAL::isa( $skip, 'ARRAY' ) )
		{
		carp( 'Third parameter to prereq_ok must be an array reference!' );
		return;
		}
		
	my $prereqs = $class->_get_prereqs();
	unless( $prereqs )
		{
		$Test->ok( 0, $name );
		$Test->diag( "\t" . 
			$class->_master_file . " did not return a true value.\n" );
		return 0;
		}
	
	my $loaded = $class->_get_loaded_modules( 'blib/lib', 't' );
	unless( $loaded )
		{
		$Test->ok( 0, $name );
		$Test->diag( "\tCouldn't look up the modules for some reasons.\n",
			"\tDo the blib/lib and t directories exist?\n",
			);
		return 0;
		}

	# remove modules found in PREREQ_PM		
	foreach my $module ( @$prereqs )
		{
		delete $loaded->{$module};
		}

	# remove modules found in distribution	
	my $distro = $class->_get_dist_modules( 'blib/lib' );
	foreach my $module ( @$distro )
		{
		delete $loaded->{$module};
		}

	# remove modules found in test directory	
	$distro = $class->_get_test_libraries();
	foreach my $module ( @$distro )
		{
		delete $loaded->{$module};
		}

	# remove modules in the skip array	
	foreach my $module ( @$skip )
		{
		delete $loaded->{$module};
		}
				
	if( keys %$loaded ) # stuff left in %loaded, oops!
		{
		$Test->ok( 0, $name );
		$Test->diag( "Found some modules that didn't show up in PREREQ_PM\n",
			map { "\t$_\n" } sort keys %$loaded );
		}
	else
		{
		$Test->ok( 1, $name );
		}
	}

sub _master_file { 'Makefile.PL' }

sub _get_prereqs
	{
	my $class = shift;
	my $file = $class->_master_file;
	
	delete $INC{$file};  # make sure we load it again
	unless( eval { eval "require '$file'" } )
		{
		print STDERR $@;
		return;
		}
		
	delete $INC{$file};  # pretend we were never here

	my @modules = sort @Test::Prereq::prereqs;
	@Test::Prereq::prereqs = ();
	return \@modules;
	}
	
# get all the loaded modules.  we'll filter this later
sub _get_loaded_modules
	{
	my $class = shift;

	return unless( defined $_[0] and defined $_[1] );
	return unless( -d $_[0] and -d $_[1] );

	my @files = File::Find::Rule->file()->name( '*.pm' )->in( $_[0] );

	push @files, File::Find::Rule->file()->name( '*.t' )->in( $_[1] );
	
	my @found = ();
	foreach my $file ( @files )
		{
		push @found, @{ $class->_get_from_file( $file ) };
		}
		
	return { map { $_, 1 } @found };
	}

sub _get_test_libraries
	{
	my $class = shift;

	my $dirsep = "/";

	my @files = 
		map {
			my $x = $_;
			$x =~ s/^.*$dirsep//;
			$x =~ s|$dirsep|::|g;
			$x;
			}
			File::Find::Rule->file()->name( '*.pl' )->in( 't' );

	return \@files;
	}
		
sub _get_dist_modules
	{
	my $class = shift;

	return unless( defined $_[0] and -d $_[0] );
	
	my $dirsep = "/";
	
	my @files = 
		map { 
			my $x = $_;
			$x =~ s/^$_[0]($dirsep)?//;
			$x =~ s/\.pm$//;
			$x =~ s|$dirsep|::|g;
			$x;
			}
			File::Find::Rule->file()->name( '*.pm' )->in( $_[0] );
			
	#print STDERR "Found in blib @files\n";
	
	return \@files;
	}
	
sub _get_from_file
	{
	my $class = shift;

	my $file = shift;
	
	my $module = Module::Info->new_from_file( $file );
	
	my @used = $module->modules_used;
	
	my @modules = 
		sort 
		grep { not exists $Module::CoreList::version{$version}{$_} }
		@used;
	
	@modules = grep { not /$Namespace/ } @modules if $Namespace;
	
	return \@modules;
	}

=back

=head1 TO DO

* skip the modules included in the distribution.  at the moment
I skip things that match the string in NAME in WriteMakefile 
and I don't think that's a good solution.

* figure out which modules depend on others, and then apply that
to what i see in the PREREQ_PM.

=head1 SOURCE AVAILABILITY

This source is part of a SourceForge project which always has the
latest sources in CVS, as well as all of the previous releases.

	https://sourceforge.net/projects/brian-d-foy/
	
If, for some reason, I disappear from the world, one of the other
members of the project can shepherd this module appropriately.

=head1 AUTHOR

brian d foy, E<lt>bdfoy@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2002, brian d foy, All Rights Reserved.

You may use, modify, and distribute this package under the
same terms as Perl itself.

=cut

1;
