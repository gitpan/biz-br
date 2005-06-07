
use 5;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'biz-br',
    VERSION_FROM      => 'lib/Business/BR.pm', # finds $VERSION
    PREREQ_PM         => {
		Scalar::Util => 0, 
		Test::More   => 0, 
	}, 
    ($] >= 5.005 ?     
      (ABSTRACT  => 'Modules for Brazilian business-related subjects',
       AUTHOR         => 'A. R. Ferreira <ferreira@cpan.org>') : ()),
);
