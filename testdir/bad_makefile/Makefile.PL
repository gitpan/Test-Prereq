# $Id: Makefile.PL,v 1.1 2002/09/12 10:11:07 comdog Exp $
use ExtUtils::MakeMaker;

WriteMakefile
        (
        'NAME'      => 'Test::Prereq',
        'VERSION'   => '0.05',
 		'PREREQ_PM' => {
 			'HTTP::Size'      => 0,
  			},
        'PM'        => 
        	{
            'lib/Prereq.pm' => '$(INST_LIBDIR)/Prereq.pm',
            },
 
		depend => { Makefile => 't/test_manifest' },
        test   => { TESTS => $tests },
        );

0;
