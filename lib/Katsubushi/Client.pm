package Katsubushi::Client;

use 5.008001;
use strict;
use warnings;

use Cache::Memcached::Fast;

use Carp qw(croak);
use Mouse;

our $VERSION = "0.1";

has _models => (
    is      => 'ro',
    isa     => 'ArrayRef[Cache::Memcached::Fast]',
    lazy    => 1,
    default => sub {
        my $self = shift;

        return [ map {
            Cache::Memcached::Fast->new({ servers => [ $_ ] });
        } @{$self->servers} ];
    },
);

has servers => (
    is  => 'ro',
    isa => 'ArrayRef[Str]',
);

no Mouse;

sub BUILD {
    my $self = shift;

    if (scalar @{$self->servers} < 1) {
        die 'there are no servers.';
    }
}

sub fetch {
    my $self = shift;

    my $id = 0;

    # retry at once for only main (the first of list) server
    for my $model ($self->_models->[0], @{$self->_models}) {
        $id = $model->get('id');
        last if $id;
    }

    unless ($id) {
        croak 'Failed to fetch new id';
    }

    return $id;
}

1;
__END__

=encoding utf-8

=head1 NAME

Katubushi::Client - A client library for katsubushi

=head1 SYNOPSIS

    use Katubushi::Client;
    my $client = Katsubushi::Client->new({
        servers => ["127.0.0.1:11212", "10.8.0.1:11212"],
    });
    $client->fetch;

=head1 DESCRIPTION

Katubushi::Client is a client library for katsubushi (github.com/kayac/go-katsubushi).

=head1 LICENSE

Copyright (C) KAYAC Inc.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

FUJIWARA Shunichiro E<lt>fujiwara.shunichiro@gmail.comE<gt>

=cut

