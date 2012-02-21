package Padre::Plugin::Moose::Subtype;

use namespace::clean;
use Moose;

has 'name'          => ( is => 'rw', isa => 'Str' );
has 'constraint'    => ( is => 'rw', isa => 'Str', default => '' );
has 'error_message' => ( is => 'rw', isa => 'Str', default => '' );

sub to_code {
    my $self    = shift;
    my $comment = shift;

    my $code .=
        "subtype '"
      . $self->name
      . "'\n=> as 'Str'"
      . "\n=> where { "
      . $self->constraint
      . " } => "
      . "\nmessage { "
      . $self->error_message
      . " }\n\n";

    return $code;
}

__PACKAGE__->meta->make_immutable;

1;
