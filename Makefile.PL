
use 5;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'biz-br',
    VERSION_FROM      => 'lib/biz-br.pod', # finds $VERSION
    PREREQ_PM         => {
		Business::BR::Ids => 0,
	}, 
    ($] >= 5.005 ?     
      (ABSTRACT  => 'Deprecated, superseded by Business-BR-Ids distribution',
	   #ABSTRACT_FROM => 'lib/biz-br.pod',
       AUTHOR         => 'A. R. Ferreira <ferreira@cpan.org>') : ()),
	NO_META => 1,
);
