package Padre::Plugin::Moose::FBP::Main;

## no critic

# This module was generated by Padre::Plugin::FormBuilder::Perl.
# To change this module edit the original .fbp file and regenerate.
# DO NOT MODIFY THIS FILE BY HAND!

use 5.008005;
use utf8;
use strict;
use warnings;
use Padre::Wx ();
use Padre::Wx::Role::Main ();
use Padre::Wx::Editor ();

our $VERSION = '0.02';
our @ISA     = qw{
	Padre::Wx::Role::Main
	Wx::Dialog
};

sub new {
	my $class  = shift;
	my $parent = shift;

	my $self = $class->SUPER::new(
		$parent,
		-1,
		Wx::gettext("Moose!"),
		Wx::DefaultPosition,
		[ 691, 575 ],
		Wx::DEFAULT_DIALOG_STYLE,
	);

	$self->{treebook} = Wx::Notebook->new(
		$self,
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	$self->{class_panel} = Wx::Panel->new(
		$self->{treebook},
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::TAB_TRAVERSAL,
	);

	my $class_label = Wx::StaticText->new(
		$self->{class_panel},
		-1,
		Wx::gettext("Class:"),
	);

	$self->{class_text} = Wx::TextCtrl->new(
		$self->{class_panel},
		-1,
		"",
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	my $superclass_label = Wx::StaticText->new(
		$self->{class_panel},
		-1,
		Wx::gettext("Superclass:"),
	);

	$self->{superclass_text} = Wx::TextCtrl->new(
		$self->{class_panel},
		-1,
		"",
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	my $roles_label = Wx::StaticText->new(
		$self->{class_panel},
		-1,
		Wx::gettext("Roles:"),
	);

	$self->{roles_list} = Wx::ListBox->new(
		$self->{class_panel},
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		[],
	);

	$self->{namespace_autoclean_label} = Wx::StaticText->new(
		$self->{class_panel},
		-1,
		Wx::gettext("Auto-clean namespace?"),
	);

	$self->{namespace_autoclean_checkbox} = Wx::CheckBox->new(
		$self->{class_panel},
		-1,
		'',
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	$self->{add_class_button} = Wx::Button->new(
		$self->{class_panel},
		-1,
		Wx::gettext("Add"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	$self->{role_panel} = Wx::Panel->new(
		$self->{treebook},
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::TAB_TRAVERSAL,
	);

	my $role_label = Wx::StaticText->new(
		$self->{role_panel},
		-1,
		Wx::gettext("Role:"),
	);

	$self->{role_text} = Wx::TextCtrl->new(
		$self->{role_panel},
		-1,
		"",
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	my $superclass_label1 = Wx::StaticText->new(
		$self->{role_panel},
		-1,
		Wx::gettext("Superclass"),
	);

	$self->{superclass_text1} = Wx::TextCtrl->new(
		$self->{role_panel},
		-1,
		"",
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	my $requires_label = Wx::StaticText->new(
		$self->{role_panel},
		-1,
		Wx::gettext("Requires"),
	);

	$self->{requires_list} = Wx::ListBox->new(
		$self->{role_panel},
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		[],
	);

	$self->{add_role_button} = Wx::Button->new(
		$self->{role_panel},
		-1,
		Wx::gettext("Add"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	$self->{attribute_panel} = Wx::Panel->new(
		$self->{treebook},
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::TAB_TRAVERSAL,
	);

	my $attribute_label = Wx::StaticText->new(
		$self->{attribute_panel},
		-1,
		Wx::gettext("Attribute:"),
	);

	$self->{attribute_text} = Wx::TextCtrl->new(
		$self->{attribute_panel},
		-1,
		"",
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	my $type_label = Wx::StaticText->new(
		$self->{attribute_panel},
		-1,
		Wx::gettext("Type:"),
	);

	$self->{type_choice} = Wx::Choice->new(
		$self->{attribute_panel},
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		[
			"Any",
			"Item",
			"Bool",
			"Maybe",
			"Undef",
			"Defined",
			"Value",
			"Str",
			"Num",
			"Int",
			"ClassName",
			"RoleName",
			"Ref",
			"ScalarRef",
			"ArrayRef",
			"HashRef",
			"CodeRef",
			"RegexpRef",
			"GlobRef",
			"FileHandle",
			"Object",
		],
	);
	$self->{type_choice}->SetSelection(0);

	my $property_label = Wx::StaticText->new(
		$self->{attribute_panel},
		-1,
		Wx::gettext("Property:"),
	);

	$self->{property_choice} = Wx::Choice->new(
		$self->{attribute_panel},
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		[
			"Read-Write",
			"Read-Only",
			"Bare",
		],
	);
	$self->{property_choice}->SetSelection(0);

	my $trigger_label = Wx::StaticText->new(
		$self->{attribute_panel},
		-1,
		Wx::gettext("Trigger:"),
	);

	$self->{trigger_text} = Wx::TextCtrl->new(
		$self->{attribute_panel},
		-1,
		"",
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	$self->{required_checbox} = Wx::CheckBox->new(
		$self->{attribute_panel},
		-1,
		Wx::gettext("Required?"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	$self->{add_attribute_button} = Wx::Button->new(
		$self->{attribute_panel},
		-1,
		Wx::gettext("Add"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	$self->{subtype_panel} = Wx::Panel->new(
		$self->{treebook},
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::TAB_TRAVERSAL,
	);

	my $subtype_label = Wx::StaticText->new(
		$self->{subtype_panel},
		-1,
		Wx::gettext("Subtype:"),
	);

	$self->{role_text1} = Wx::TextCtrl->new(
		$self->{subtype_panel},
		-1,
		"",
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	my $constraint_label = Wx::StaticText->new(
		$self->{subtype_panel},
		-1,
		Wx::gettext("Constraint:"),
	);

	$self->{constraint_text} = Wx::TextCtrl->new(
		$self->{subtype_panel},
		-1,
		"",
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	my $error_message_label = Wx::StaticText->new(
		$self->{subtype_panel},
		-1,
		Wx::gettext("Error Message:"),
	);

	$self->{error_message_text} = Wx::TextCtrl->new(
		$self->{subtype_panel},
		-1,
		"",
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	$self->{add_subtype_button} = Wx::Button->new(
		$self->{subtype_panel},
		-1,
		Wx::gettext("Add"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	$self->{tree} = Wx::TreeCtrl->new(
		$self,
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::TR_DEFAULT_STYLE,
	);

	$self->{preview} = Padre::Wx::Editor->new(
		$self,
		-1,
	);

	$self->{moose_manual_hyperlink} = Wx::HyperlinkCtrl->new(
		$self,
		-1,
		Wx::gettext("Moose Manual"),
		"https://metacpan.org/module/Moose::Manual",
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::HL_DEFAULT_STYLE,
	);

	$self->{moose_cookbook_hyperlink} = Wx::HyperlinkCtrl->new(
		$self,
		-1,
		Wx::gettext("How to Cook a Moose?"),
		"https://metacpan.org/module/Moose::Cookbook",
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::HL_DEFAULT_STYLE,
	);

	$self->{moose_website_hyperlink} = Wx::HyperlinkCtrl->new(
		$self,
		-1,
		Wx::gettext("Moose Website"),
		"http://moose.iinteractive.com/",
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::HL_DEFAULT_STYLE,
	);

	$self->{about_button} = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("About"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{about_button},
		sub {
			shift->on_about_button_clicked(@_);
		},
	);

	$self->{close_button} = Wx::Button->new(
		$self,
		-1,
		Wx::gettext("Close"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{close_button},
		sub {
			shift->on_cancel_button_clicked(@_);
		},
	);

	my $class_content_sizer = Wx::FlexGridSizer->new( 2, 2, 0, 0 );
	$class_content_sizer->SetFlexibleDirection(Wx::BOTH);
	$class_content_sizer->SetNonFlexibleGrowMode(Wx::FLEX_GROWMODE_SPECIFIED);
	$class_content_sizer->Add( $class_label, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::LEFT | Wx::RIGHT | Wx::TOP, 5 );
	$class_content_sizer->Add( $self->{class_text}, 0, Wx::ALL, 5 );
	$class_content_sizer->Add( $superclass_label, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::LEFT | Wx::RIGHT | Wx::TOP, 5 );
	$class_content_sizer->Add( $self->{superclass_text}, 0, Wx::ALL, 5 );
	$class_content_sizer->Add( $roles_label, 0, Wx::ALL, 5 );
	$class_content_sizer->Add( $self->{roles_list}, 0, Wx::ALL, 5 );
	$class_content_sizer->Add( $self->{namespace_autoclean_label}, 0, Wx::ALL, 5 );
	$class_content_sizer->Add( $self->{namespace_autoclean_checkbox}, 0, Wx::ALL, 5 );

	my $class_button_sizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$class_button_sizer->Add( $self->{add_class_button}, 0, Wx::ALIGN_RIGHT | Wx::ALL, 5 );

	my $class_sizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$class_sizer->Add( $class_content_sizer, 1, Wx::EXPAND, 5 );
	$class_sizer->Add( $class_button_sizer, 0, Wx::EXPAND, 5 );

	$self->{class_panel}->SetSizerAndFit($class_sizer);
	$self->{class_panel}->Layout;

	my $role_content_sizer = Wx::FlexGridSizer->new( 2, 2, 0, 0 );
	$role_content_sizer->SetFlexibleDirection(Wx::BOTH);
	$role_content_sizer->SetNonFlexibleGrowMode(Wx::FLEX_GROWMODE_SPECIFIED);
	$role_content_sizer->Add( $role_label, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::LEFT | Wx::RIGHT | Wx::TOP, 5 );
	$role_content_sizer->Add( $self->{role_text}, 0, Wx::ALL, 5 );
	$role_content_sizer->Add( $superclass_label1, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::LEFT | Wx::RIGHT | Wx::TOP, 5 );
	$role_content_sizer->Add( $self->{superclass_text1}, 0, Wx::ALL, 5 );
	$role_content_sizer->Add( $requires_label, 0, Wx::ALL, 5 );
	$role_content_sizer->Add( $self->{requires_list}, 0, Wx::ALL, 5 );

	my $role_button_sizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$role_button_sizer->Add( $self->{add_role_button}, 0, Wx::ALIGN_RIGHT | Wx::ALL, 5 );

	my $role_sizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$role_sizer->Add( $role_content_sizer, 1, Wx::EXPAND, 5 );
	$role_sizer->Add( $role_button_sizer, 0, Wx::EXPAND, 5 );

	$self->{role_panel}->SetSizerAndFit($role_sizer);
	$self->{role_panel}->Layout;

	my $attribute_content_sizer = Wx::FlexGridSizer->new( 2, 2, 0, 0 );
	$attribute_content_sizer->SetFlexibleDirection(Wx::BOTH);
	$attribute_content_sizer->SetNonFlexibleGrowMode(Wx::FLEX_GROWMODE_SPECIFIED);
	$attribute_content_sizer->Add( $attribute_label, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::LEFT | Wx::RIGHT | Wx::TOP, 5 );
	$attribute_content_sizer->Add( $self->{attribute_text}, 0, Wx::ALL, 5 );
	$attribute_content_sizer->Add( $type_label, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::LEFT | Wx::RIGHT | Wx::TOP, 5 );
	$attribute_content_sizer->Add( $self->{type_choice}, 0, Wx::ALL, 5 );
	$attribute_content_sizer->Add( $property_label, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::LEFT | Wx::RIGHT | Wx::TOP, 5 );
	$attribute_content_sizer->Add( $self->{property_choice}, 0, Wx::ALL, 5 );
	$attribute_content_sizer->Add( $trigger_label, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::LEFT | Wx::RIGHT | Wx::TOP, 5 );
	$attribute_content_sizer->Add( $self->{trigger_text}, 0, Wx::ALL, 5 );
	$attribute_content_sizer->Add( $self->{required_checbox}, 0, Wx::ALL, 5 );

	my $attribute_button_sizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$attribute_button_sizer->Add( $self->{add_attribute_button}, 0, Wx::ALIGN_RIGHT | Wx::ALL, 5 );

	my $attribute_sizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$attribute_sizer->Add( $attribute_content_sizer, 1, Wx::EXPAND, 5 );
	$attribute_sizer->Add( $attribute_button_sizer, 0, Wx::ALIGN_RIGHT | Wx::EXPAND, 5 );

	$self->{attribute_panel}->SetSizerAndFit($attribute_sizer);
	$self->{attribute_panel}->Layout;

	my $subtype_content_sizer = Wx::FlexGridSizer->new( 2, 2, 0, 0 );
	$subtype_content_sizer->SetFlexibleDirection(Wx::BOTH);
	$subtype_content_sizer->SetNonFlexibleGrowMode(Wx::FLEX_GROWMODE_SPECIFIED);
	$subtype_content_sizer->Add( $subtype_label, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::LEFT | Wx::RIGHT | Wx::TOP, 5 );
	$subtype_content_sizer->Add( $self->{role_text1}, 0, Wx::ALL, 5 );
	$subtype_content_sizer->Add( $constraint_label, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::LEFT | Wx::RIGHT | Wx::TOP, 5 );
	$subtype_content_sizer->Add( $self->{constraint_text}, 0, Wx::ALL, 5 );
	$subtype_content_sizer->Add( $error_message_label, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::LEFT | Wx::RIGHT | Wx::TOP, 5 );
	$subtype_content_sizer->Add( $self->{error_message_text}, 0, Wx::ALL, 5 );

	my $subtype_button_sizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$subtype_button_sizer->Add( $self->{add_subtype_button}, 0, Wx::ALIGN_RIGHT | Wx::ALL, 5 );

	my $subtype_sizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$subtype_sizer->Add( $subtype_content_sizer, 1, Wx::EXPAND, 5 );
	$subtype_sizer->Add( $subtype_button_sizer, 0, Wx::EXPAND, 5 );

	$self->{subtype_panel}->SetSizerAndFit($subtype_sizer);
	$self->{subtype_panel}->Layout;

	$self->{treebook}->AddPage( $self->{class_panel}, Wx::gettext("Class"), 1 );
	$self->{treebook}->AddPage( $self->{role_panel}, Wx::gettext("Role"), 0 );
	$self->{treebook}->AddPage( $self->{attribute_panel}, Wx::gettext("Attribute"), 0 );
	$self->{treebook}->AddPage( $self->{subtype_panel}, Wx::gettext("Subtype"), 0 );

	my $left_sizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$left_sizer->Add( $self->{treebook}, 1, Wx::EXPAND | Wx::ALL, 5 );

	my $top_sizer = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$top_sizer->Add( $left_sizer, 1, Wx::EXPAND, 5 );
	$top_sizer->Add( $self->{tree}, 1, Wx::ALL | Wx::EXPAND, 5 );

	my $hyperlink_sizer = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$hyperlink_sizer->Add( $self->{moose_manual_hyperlink}, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::ALL, 5 );
	$hyperlink_sizer->Add( $self->{moose_cookbook_hyperlink}, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::ALL, 5 );
	$hyperlink_sizer->Add( $self->{moose_website_hyperlink}, 0, Wx::ALIGN_CENTER_VERTICAL | Wx::ALL, 5 );

	my $buttons_sizer = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$buttons_sizer->Add( $hyperlink_sizer, 0, Wx::EXPAND, 5 );
	$buttons_sizer->Add( 10, 0, 1, Wx::EXPAND, 5 );
	$buttons_sizer->Add( $self->{about_button}, 0, Wx::ALL, 2 );
	$buttons_sizer->Add( 5, 0, 0, Wx::EXPAND, 5 );
	$buttons_sizer->Add( $self->{close_button}, 0, Wx::ALL, 2 );

	my $vsizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$vsizer->Add( $top_sizer, 1, Wx::EXPAND, 5 );
	$vsizer->Add( $self->{preview}, 1, Wx::ALL | Wx::EXPAND, 5 );
	$vsizer->Add( $buttons_sizer, 0, Wx::EXPAND, 5 );

	my $hsizer = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$hsizer->Add( $vsizer, 1, Wx::ALL | Wx::EXPAND, 5 );

	$self->SetSizer($hsizer);
	$self->Layout;

	return $self;
}

sub on_about_button_clicked {
	$_[0]->main->error('Handler method on_about_button_clicked for event about_button.OnButtonClick not implemented');
}

sub on_cancel_button_clicked {
	$_[0]->main->error('Handler method on_cancel_button_clicked for event close_button.OnButtonClick not implemented');
}

1;

# Copyright 2008-2012 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.

