#!/usr/bin/perl

use 5.006;
use strict;
use warnings;
use Test::More tests => 3;
use Padre::Plugin::wxGlade ();
use PPI::Document          ();

# We need a fake IDE object to boot up the plugin
my $ide = bless {}, 'Padre';

# Create the plugin outside of a full Padre instance
my $plugin = Padre::Plugin::wxGlade->new( $ide );
isa_ok( $plugin, 'Padre::Plugin::wxGlade' );





######################################################################
# Main Tests

my $input    = test_input();
my $packages = $plugin->package_list(\$input);
is_deeply(
	$packages,
	[ qw{ MyDialog4 MyFrame } ],
	'Found expected packages',
);

my $expected = test_output();
my $output   = $plugin->isolate_package( \$input, $packages->[0] );
is( $output, $expected, '->isolate_package ok' );





#########################################################
# Test Data

sub test_input { <<'END_PERL' }
#!/usr/bin/perl -w -- 
# generated by wxGlade 0.6.3
# To get wxPerl visit http://wxPerl.sourceforge.net/

use Wx 0.15 qw[:allclasses];
use strict;

package MyDialog4;

use Wx qw[:everything];
use base qw(Wx::Dialog);
use strict;

sub new {
	my( $self, $parent, $id, $title, $pos, $size, $style, $name ) = @_;
	$parent = undef              unless defined $parent;
	$id     = -1                 unless defined $id;
	$title  = ""                 unless defined $title;
	$pos    = wxDefaultPosition  unless defined $pos;
	$size   = wxDefaultSize      unless defined $size;
	$name   = ""                 unless defined $name;

# begin wxGlade: MyDialog4::new

	$style = wxDEFAULT_DIALOG_STYLE 
		unless defined $style;

	$self = $self->SUPER::new( $parent, $id, $title, $pos, $size, $style, $name );
	$self->{warning_label} = Wx::StaticText->new($self, -1, "See http://padre.perlide.org/ for update information", wxDefaultPosition, wxDefaultSize, wxALIGN_CENTRE);
	$self->{warning_checkbox} = Wx::CheckBox->new($self, -1, "Do not show this again", wxDefaultPosition, wxDefaultSize, );
	$self->{line_1} = Wx::StaticLine->new($self, -1, wxDefaultPosition, wxDefaultSize, );
	$self->{ok_button} = Wx::Button->new($self, wxID_OK, "");

	$self->__set_properties();
	$self->__do_layout();

# end wxGlade
	return $self;

}


sub __set_properties {
	my $self = shift;

# begin wxGlade: MyDialog4::__set_properties

	$self->SetTitle("Warning");

# end wxGlade
}

sub __do_layout {
	my $self = shift;

# begin wxGlade: MyDialog4::__do_layout

	$self->{sizer_4} = Wx::BoxSizer->new(wxHORIZONTAL);
	$self->{sizer_5} = Wx::BoxSizer->new(wxVERTICAL);
	$self->{sizer_6} = Wx::BoxSizer->new(wxHORIZONTAL);
	$self->{sizer_5}->Add($self->{warning_label}, 0, 0, 0);
	$self->{sizer_5}->Add($self->{warning_checkbox}, 0, wxTOP|wxEXPAND, 5);
	$self->{sizer_5}->Add($self->{line_1}, 0, wxTOP|wxBOTTOM|wxEXPAND, 5);
	$self->{sizer_6}->Add($self->{ok_button}, 0, 0, 0);
	$self->{sizer_5}->Add($self->{sizer_6}, 1, wxALIGN_CENTER_HORIZONTAL, 5);
	$self->{sizer_4}->Add($self->{sizer_5}, 1, wxALL|wxEXPAND, 5);
	$self->SetSizer($self->{sizer_4});
	$self->{sizer_4}->Fit($self);
	$self->Layout();

# end wxGlade
}

# end of class MyDialog4

1;

package MyFrame;

use Wx qw[:everything];
use base qw(Wx::Frame);
use strict;

sub new {
	my( $self, $parent, $id, $title, $pos, $size, $style, $name ) = @_;
	$parent = undef              unless defined $parent;
	$id     = -1                 unless defined $id;
	$title  = ""                 unless defined $title;
	$pos    = wxDefaultPosition  unless defined $pos;
	$size   = wxDefaultSize      unless defined $size;
	$name   = ""                 unless defined $name;

# begin wxGlade: MyFrame::new

	$style = wxDEFAULT_FRAME_STYLE 
		unless defined $style;

	$self = $self->SUPER::new( $parent, $id, $title, $pos, $size, $style, $name );
	$self->{panel_1} = Wx::Panel->new($self, -1, wxDefaultPosition, wxDefaultSize, );

	$self->__set_properties();
	$self->__do_layout();

# end wxGlade
	return $self;

}


sub __set_properties {
	my $self = shift;

# begin wxGlade: MyFrame::__set_properties

	$self->SetTitle("frame_1");

# end wxGlade
}

sub __do_layout {
	my $self = shift;

# begin wxGlade: MyFrame::__do_layout

	$self->{sizer_3} = Wx::BoxSizer->new(wxVERTICAL);
	$self->{sizer_3}->Add($self->{panel_1}, 1, wxEXPAND, 0);
	$self->SetSizer($self->{sizer_3});
	$self->{sizer_3}->Fit($self);
	$self->Layout();

# end wxGlade
}

# end of class MyFrame

1;

1;

package main;

unless(caller){
	local *Wx::App::OnInit = sub{1};
	my $app = Wx::App->new();
	Wx::InitAllImageHandlers();

	my $dialog_find = MyDialog1->new();

	$app->SetTopWindow($dialog_find);
	$dialog_find->Show(1);
	$app->MainLoop();
}
END_PERL

sub test_output { <<'END_PERL' }
	$self->{warning_label} = Wx::StaticText->new($self, -1, "See http://padre.perlide.org/ for update information", wxDefaultPosition, wxDefaultSize, wxALIGN_CENTRE);
	$self->{warning_checkbox} = Wx::CheckBox->new($self, -1, "Do not show this again", wxDefaultPosition, wxDefaultSize);
	$self->{line_1} = Wx::StaticLine->new($self, -1, wxDefaultPosition, wxDefaultSize);
	$self->{ok_button} = Wx::Button->new($self, wxID_OK, "");
	$self->SetTitle("Warning");
	$self->{sizer_4} = Wx::BoxSizer->new(wxHORIZONTAL);
	$self->{sizer_5} = Wx::BoxSizer->new(wxVERTICAL);
	$self->{sizer_6} = Wx::BoxSizer->new(wxHORIZONTAL);
	$self->{sizer_5}->Add($self->{warning_label}, 0, 0, 0);
	$self->{sizer_5}->Add($self->{warning_checkbox}, 0, wxTOP|wxEXPAND, 5);
	$self->{sizer_5}->Add($self->{line_1}, 0, wxTOP|wxBOTTOM|wxEXPAND, 5);
	$self->{sizer_6}->Add($self->{ok_button}, 0, 0, 0);
	$self->{sizer_5}->Add($self->{sizer_6}, 1, wxALIGN_CENTER_HORIZONTAL, 5);
	$self->{sizer_4}->Add($self->{sizer_5}, 1, wxALL|wxEXPAND, 5);
	$self->SetSizer($self->{sizer_4});
	$self->{sizer_4}->Fit($self);
END_PERL
