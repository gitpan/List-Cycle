package List::Cycle;

use warnings;
use strict;

=head1 NAME

List::Cycle - Objects for cycling through a list of values

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use List::Cycle;

    my $color = List::Cycle->new( '#000000', '#FAFAFA', '#BADDAD' );
    print $color->next;

=head1 FUNCTIONS

=head2 new( @values )

Creates a new cycle object, using I<@values>.

=cut

my %values_of;
my %pointer_of;

sub new {
    my $class = shift;
    my $self = \join( q{ }, caller, scalar localtime );
    bless $self, $class;

    $values_of{ $self } = [@_];
    $pointer_of{ $self } = 0;

    return $self;
}

=head2 $cycle->next

Gives the next value in the sequence.

=cut

sub next {
    my $self = shift;

    my $ptr = $pointer_of{ $self }++;
    if ( $pointer_of{ $self } >= @{$values_of{$self}} ) {
        $pointer_of{ $self } = 0;
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

=head1 COPYRIGHT & LICENSE

Copyright 2005 Andy Lester, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of List::Cycle
