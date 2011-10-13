package Padre::Wx::FBP::VCS;

## no critic

# This module was generated by Padre::Plugin::FormBuilder::Perl.
# To change this module edit the original .fbp file and regenerate.
# DO NOT MODIFY THIS FILE BY HAND!

use 5.008;
use strict;
use warnings;
use Padre::Wx ();
use Padre::Wx::Role::Main ();

our $VERSION = '0.91';
our @ISA     = qw{
	Padre::Wx::Role::Main
	Wx::Panel
};

sub new {
	my $class  = shift;
	my $parent = shift;

	my $self = $class->SUPER::new(
		$parent,
		-1,
		Wx::DefaultPosition,
		[ 195, 530 ],
		Wx::TAB_TRAVERSAL,
	);

	$self->{add} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{add},
		sub {
			shift->on_add_click(@_);
		},
	);

	$self->{delete} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{delete},
		sub {
			shift->on_delete_click(@_);
		},
	);

	$self->{update} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{update},
		sub {
			shift->on_update_click(@_);
		},
	);

	$self->{commit} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{commit},
		sub {
			shift->on_commit_click(@_);
		},
	);

	$self->{revert} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{revert},
		sub {
			shift->on_revert_click(@_);
		},
	);

	$self->{refresh} = Wx::BitmapButton->new(
		$self,
		-1,
		Wx::NullBitmap,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::BU_AUTODRAW,
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{refresh},
		sub {
			shift->on_refresh_click(@_);
		},
	);

	$self->{list} = Wx::ListCtrl->new(
		$self,
		-1,
		Wx::DefaultPosition,
		Wx::DefaultSize,
		Wx::LC_REPORT | Wx::LC_SINGLE_SEL,
	);

	Wx::Event::EVT_LIST_COL_CLICK(
		$self,
		$self->{list},
		sub {
			shift->on_list_column_click(@_);
		},
	);

	Wx::Event::EVT_LIST_ITEM_ACTIVATED(
		$self,
		$self->{list},
		sub {
			shift->on_list_item_activated(@_);
		},
	);

	$self->{show_normal} = Wx::CheckBox->new(
		$self,
		-1,
		Wx::gettext("Normal"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	Wx::Event::EVT_CHECKBOX(
		$self,
		$self->{show_normal},
		sub {
			shift->on_show_normal_click(@_);
		},
	);

	$self->{show_unversioned} = Wx::CheckBox->new(
		$self,
		-1,
		Wx::gettext("Unversioned"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	Wx::Event::EVT_CHECKBOX(
		$self,
		$self->{show_unversioned},
		sub {
			shift->on_show_unversioned_click(@_);
		},
	);

	$self->{show_ignored} = Wx::CheckBox->new(
		$self,
		-1,
		Wx::gettext("Ignored"),
		Wx::DefaultPosition,
		Wx::DefaultSize,
	);

	Wx::Event::EVT_CHECKBOX(
		$self,
		$self->{show_ignored},
		sub {
			shift->on_show_ignored_click(@_);
		},
	);

	$self->{status} = Wx::StaticText->new(
		$self,
		-1,
		Wx::gettext("Status"),
	);

	my $button_sizer = Wx::BoxSizer->new(Wx::HORIZONTAL);
	$button_sizer->Add( $self->{add}, 0, Wx::ALL, 1 );
	$button_sizer->Add( $self->{delete}, 0, Wx::ALL, 1 );
	$button_sizer->Add( $self->{update}, 0, Wx::ALL, 1 );
	$button_sizer->Add( $self->{commit}, 0, Wx::ALL, 1 );
	$button_sizer->Add( $self->{revert}, 0, Wx::ALL, 1 );
	$button_sizer->Add( $self->{refresh}, 0, Wx::ALL, 1 );

	my $checkbox_sizer = Wx::StaticBoxSizer->new(
		Wx::StaticBox->new(
			$self,
			-1,
			Wx::gettext("Show"),
		),
		Wx::VERTICAL,
	);
	$checkbox_sizer->Add( $self->{show_normal}, 0, Wx::ALL, 2 );
	$checkbox_sizer->Add( $self->{show_unversioned}, 0, Wx::ALL, 2 );
	$checkbox_sizer->Add( $self->{show_ignored}, 0, Wx::ALL, 2 );

	my $main_sizer = Wx::BoxSizer->new(Wx::VERTICAL);
	$main_sizer->Add( $button_sizer, 0, Wx::EXPAND, 5 );
	$main_sizer->Add( $self->{list}, 1, Wx::ALL | Wx::EXPAND, 5 );
	$main_sizer->Add( $checkbox_sizer, 0, Wx::EXPAND, 2 );
	$main_sizer->Add( $self->{status}, 0, Wx::ALL | Wx::EXPAND, 8 );

	$self->SetSizer($main_sizer);
	$self->Layout;

	return $self;
}

sub on_add_click {
	$_[0]->main->error('Handler method on_add_click for event add.OnButtonClick not implemented');
}

sub on_delete_click {
	$_[0]->main->error('Handler method on_delete_click for event delete.OnButtonClick not implemented');
}

sub on_update_click {
	$_[0]->main->error('Handler method on_update_click for event update.OnButtonClick not implemented');
}

sub on_commit_click {
	$_[0]->main->error('Handler method on_commit_click for event commit.OnButtonClick not implemented');
}

sub on_revert_click {
	$_[0]->main->error('Handler method on_revert_click for event revert.OnButtonClick not implemented');
}

sub on_refresh_click {
	$_[0]->main->error('Handler method on_refresh_click for event refresh.OnButtonClick not implemented');
}

sub on_list_column_click {
	$_[0]->main->error('Handler method on_list_column_click for event list.OnListColClick not implemented');
}

sub on_list_item_activated {
	$_[0]->main->error('Handler method on_list_item_activated for event list.OnListItemActivated not implemented');
}

sub on_show_normal_click {
	$_[0]->main->error('Handler method on_show_normal_click for event show_normal.OnCheckBox not implemented');
}

sub on_show_unversioned_click {
	$_[0]->main->error('Handler method on_show_unversioned_click for event show_unversioned.OnCheckBox not implemented');
}

sub on_show_ignored_click {
	$_[0]->main->error('Handler method on_show_ignored_click for event show_ignored.OnCheckBox not implemented');
}

1;

# Copyright 2008-2011 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.
