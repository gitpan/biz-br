
use 5;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'biz-br',
    VERSION_FROM      => 'lib/Business/BR.pm', # finds $VERSION
    PREREQ_PM         => {
		# e.g., Module::Name => 1.1
	}, 
    ($] >= 5.005 ?     
      (#ABSTRACT_FROM  => 'lib/Business/BR.pm', # retrieve abstract from module
       AUTHOR         => 'A. R. Ferreira <ferreira@cpan.org>') : ()),
);
