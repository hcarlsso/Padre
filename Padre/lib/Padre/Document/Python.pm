package Padre::Document::Python;

use 5.008;
use strict;
use warnings;
use Padre::Document::HashComment ();

our $VERSION = '0.91';
our @ISA     = qw{
	Padre::Document::HashComment
};

# Python keywords
# The list is obtained from src/scite/src/python.properties
sub lexer_keywords {
	return [
		[   qw(and as assert break class continue def del elif \
else except exec finally for from global if import in is lambda None \
not or pass print raise return try while with yield)
		],
	];
}

1;

# Copyright 2008-2011 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.
