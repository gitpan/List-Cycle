package List::Cycle;

use warnings;
use strict;
use Carp;
use UNIVERSAL qw( isa );

=head1 NAME

List::Cycle - Objects for cycling through a list of values

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

    use List::Cycle;

    my $color = List::Cycle->new( {vals => ['#000000', '#FAFAFA', '#BADDAD']} );
    print $color->next; # #000000
    print $color->next; # #FAFAFA
    print $color->next; # #BADDAD
    print $color->next; # #000000

=head1 FUNCTIONS

=head2 new( {vals => \@values} )

Creates a new cycle object, using I<@values>.

=cut

my %storage = (
    'values' => \my %values_of,
    'pointer' => \my %pointer_of,
);

sub new {
    my $class = shift;
    my $args = shift;

    my $self = \do { my $scalar };
    bless $self, $class;

    $self->_init( %$args );

    return $self;
}

sub _init {
    my $self = shift;
    my @args = @_;

    $self->_store_pointer( 0 );
    while ( @args ) {
        my $key = shift @args;
        my $value = shift @args;

        if ( $key eq "vals" ) {
            $values_of{ $self } = $value;
        }
        else {
            croak "$key is not a valid constructor value";
        }
    }

    return $self;
}

sub DESTROY {
    my $self = shift;

    for my $attr_ref ( values %storage ) {
        delete $attr_ref->{$self};
    }
}

sub _pointer {
    my $self = shift;

    return $pointer_of{ $self };
}

sub _store_pointer {
    my $self = shift;

    $pointer_of{ $self } = shift;
}

=head2 $cycle->reset

Sets the internal pointer back to the beginning of the cycle.

=cut

sub reset {
    my $self = shift;

    $self->_store_pointer(0);

    return;
}

=head2 $cycle->dump

Returns a handy string representation of internals.

=cut

sub dump {
    my $self = shift;
    my $str = "";

    while ( my($key,$value) = each %storage ) {
        my $realval = $value->{$self};
        $realval = join( ",", @$realval ) if isa( $realval, "ARRAY" );
        $str .= "$key => $realval\n";
    }
    return $str;
}

=head2 $cycle->next

Gives the next value in the sequence.

=cut

sub next {
    my $self = shift;

    my $ptr = $pointer_of{ $self }++;
    if ( $pointer_of{ $self } >= @{$values_of{$self}} ) {
        $self->reset();
    }
    return $values_of{ $self }[$ptr];
}

=head1 AUTHOR

Andy Lester, C<< <andy@petdance.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-list-cycle @ rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=List-Cycle>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 ACKNOWLEDGEMENTS

List::Cycle is a playground that uses some of the ideas in Damian Conway's
marvelous I<Perl Best Practices>, due out in mid-2005 from O'Reilly.
One of the chapters mentions a mythical List::Cycle module, so I made
it real.

=head1 COPYRIGHT & LICENSE

Copyright 2005 Andy Lester, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of List::Cycle
