use strict;
use warnings;

use SDL;
use SDL::App;
use SDL::Rect;
use SDL::Color;

my $window = SDL::App->new(
	-width => 640,
	-height => 480,
	-depth => 16,
	-title => 'SDL Demo',
);

my $rect = SDL::Rect->new( -height => 10, -width => 20);
my $blue = SDL::Color->new(
	-r => 0x00,
	-g => 0x00,
        -b => 0xff,
        );
$window->fill($rect, $blue);
$window->update($rect);

sleep 2;
