#!perl -Tw

use Test::More tests => 2;

BEGIN {
    use_ok( 'List::Cycle' );
}

my $cycle = List::Cycle->new( 2112, 5150, 90125 );
isa_ok( $cycle, 'List::Cycle' );
