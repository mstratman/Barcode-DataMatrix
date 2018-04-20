use strict;
use warnings;
use Test::More tests => 1;

use Barcode::DataMatrix::CharDataFiller;

subtest "Check predefined format sizes" => sub {
    plan tests => 64;
    use Barcode::DataMatrix::Constants;

    my $formats = \@Barcode::DataMatrix::Constants::FORMATS;

    for my $format (@$formats) {
        my ($nrow, $ncol) = ($format->[0], $format->[1]);
        my $array = zeros( $nrow, $ncol );
        my $filler =
            Barcode::DataMatrix::CharDataFiller->new( $ncol, $nrow, $array );

        ok $filler, "$nrow x $ncol CharDataFiller object created successfully";
        ok nonzero($filler->{array}),
            "Resulting array contains nonzero elements";
    }

    # force corner3 to be exercised
    # this test necessary in order to check this particular special case,
    # which isn't exercised by the given list of formats
    {
        my ($nrow, $ncol) = (22, 12);
        my $array = zeros( $nrow, $ncol );
        my $filler =
            Barcode::DataMatrix::CharDataFiller->new( $ncol, $nrow, $array );

        ok $filler, "$nrow x $ncol CharDataFiller object created successfully";
        ok nonzero($filler->{array}),
            "Resulting array contains nonzero elements";
    }

    # force corner4 to be exercised
    # this test necessary in order to check this particular special case,
    # which isn't exercised by the given list of formats
    {
        my ($nrow, $ncol) = (22, 8);
        my $array = zeros( $nrow, $ncol );
        my $filler =
            Barcode::DataMatrix::CharDataFiller->new( $ncol, $nrow, $array );

        ok $filler, "$nrow x $ncol CharDataFiller object created successfully";
        ok nonzero($filler->{array}),
            "Resulting array contains nonzero elements";
    }
};

# return a zeroed array of the given size
sub zeros {
    my ( $nrow, $ncol ) = @_;

    my @array = ();
    for ( my $i = 0 ; $i < $nrow ; $i++ ) {
        for ( my $j = 0 ; $j < $ncol ; $j++ ) {
            $array[$i][$j] = 0;
        }
    }

    return \@array;
}

# check that array contains nonzero elements
sub nonzero {
    my ($array) = @_;

    for my $elem ( @$array ) {
        return 1 if $elem != 0;
    }

    return 0;
}
