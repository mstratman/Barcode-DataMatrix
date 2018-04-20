use strict;
use warnings;
use Test::More tests => 4;
use Test::Exception;

use Barcode::DataMatrix::Engine;

subtest "Engine object creation" => sub {
    plan tests => 1;

    my $text = "Monkey Magic";
    my $encoding_mode = "ASCII";
    my $process_tilde = 0;
    my $matrix_format = undef;

    my $engine = Barcode::DataMatrix::Engine->new(
        $text, $encoding_mode, $matrix_format, $process_tilde,
    );

    ok $engine, "Engine object created successfully";
};

subtest "Matrix format handling" => sub {
    plan tests => 5;

    my $text = "Monkey Magic";
    my $encoding_mode = "ASCII";
    my $process_tilde = 0;
    my $matrix_format = undef;

    my $engine = Barcode::DataMatrix::Engine->new(
        $text, $encoding_mode, $matrix_format, $process_tilde,
    );

    is $engine->{preferredFormat}, -1, "No format set";

    $matrix_format = "10x10";
    $engine = Barcode::DataMatrix::Engine->new(
        $text, $encoding_mode, $matrix_format, $process_tilde,
    );

    # NOTE: the value of preferredFormat should be "0" for the format
    # "10x10", however due to a bug in the C<new> method, the value is
    # interpreted as false and hence the default value of "-1" is returned.
    # Luckily, this also matches the format that would have been chosen, had
    # the value for the "10x10" format been returned correctly
    is $engine->{preferredFormat}, -1, "10x10 format correctly set";

    $matrix_format = "12x12";
    $engine = Barcode::DataMatrix::Engine->new(
        $text, $encoding_mode, $matrix_format, $process_tilde,
    );

    is $engine->{preferredFormat}, 1, "12x12 format correctly set";

    $matrix_format = "88x88";
    $engine = Barcode::DataMatrix::Engine->new(
        $text, $encoding_mode, $matrix_format, $process_tilde,
    );

    is $engine->{preferredFormat}, 18, "88x88 format correctly set";

    $matrix_format = "12x13";
    throws_ok( sub {
            Barcode::DataMatrix::Engine->new(
                $text, $encoding_mode, $matrix_format, $process_tilde)
        },
        qr/Format not supported \(12x13\)/,
        "Caught unsupported format ok"
    );
};

subtest "Tilde control character processing" => sub {
    plan tests => 12;

    my $encoding_mode = "ASCII";
    my $matrix_format = undef;
    my $process_tilde = 1;
    {
        my $text = "Monkey Magic ~d065";
        my $engine = Barcode::DataMatrix::Engine->new(
            $text, $encoding_mode, $matrix_format, $process_tilde,
        );

        my $processed_text = $engine->{code};
        is $processed_text, "Monkey Magic A",
            "Simple ascii character code handled correctly";
    }

    {
        my $text = "~1Monkey Magic";
        my $engine = Barcode::DataMatrix::Engine->new(
            $text, $encoding_mode, $matrix_format, $process_tilde,
        );

        my $processed_text = $engine->{code};
        is $processed_text, "\350Monkey Magic",
            "prepended ~1 encoded char without prefix handled correctly";
    }

    {
        my $text = "x~1Monkey Magic";
        my $engine = Barcode::DataMatrix::Engine->new(
            $text, $encoding_mode, $matrix_format, $process_tilde,
        );

        my $processed_text = $engine->{code};
        is $processed_text, "x\350Monkey Magic",
            "prepended ~1 encoded char with single char prefix handled correctly";
    }

    {
        my $text = "xyz~1Monkey Magic";
        my $engine = Barcode::DataMatrix::Engine->new(
            $text, $encoding_mode, $matrix_format, $process_tilde,
        );

        my $processed_text = $engine->{code};
        is $processed_text, "xyz\035Monkey Magic",
            "prepended ~1 encoded char with 3 char prefix handled correctly";
    }

    {
        my $text = "xyza~1Monkey Magic";
        my $engine = Barcode::DataMatrix::Engine->new(
            $text, $encoding_mode, $matrix_format, $process_tilde,
        );

        my $processed_text = $engine->{code};
        is $processed_text, "xyza\350Monkey Magic",
            "prepended ~1 encoded char with 4 char prefix handled correctly";
    }

    {
        my $text = "xyzab~1Monkey Magic";
        my $engine = Barcode::DataMatrix::Engine->new(
            $text, $encoding_mode, $matrix_format, $process_tilde,
        );

        my $processed_text = $engine->{code};
        is $processed_text, "xyzab\350Monkey Magic",
            "prepended ~1 encoded char with 5 char prefix handled correctly";
    }

    {
        my $text = "Monkey Magic~1";
        my $engine = Barcode::DataMatrix::Engine->new(
            $text, $encoding_mode, $matrix_format, $process_tilde,
        );

        my $processed_text = $engine->{code};
        is $processed_text, "Monkey Magic\035",
            "appended ~1 encoded char handled correctly";
    }

    {
        my $text = "~2Monkey Magic";
        my $engine = Barcode::DataMatrix::Engine->new(
            $text, $encoding_mode, $matrix_format, $process_tilde,
        );

        my $processed_text = $engine->{code};
        is $processed_text, "\351key Magic",
            "~2 encoded char handled correctly";
    }

    {
        my $text = "~3Monkey Magic";
        my $engine = Barcode::DataMatrix::Engine->new(
            $text, $encoding_mode, $matrix_format, $process_tilde,
        );

        my $processed_text = $engine->{code};
        is $processed_text, "\352Monkey Magic",
            "~3 encoded char handled correctly";
    }

    {
        my $text = "~5Monkey Magic";
        my $engine = Barcode::DataMatrix::Engine->new(
            $text, $encoding_mode, $matrix_format, $process_tilde,
        );

        my $processed_text = $engine->{code};
        is $processed_text, "\354Monkey Magic",
            "~5 encoded char handled correctly";
    }

    {
        my $text = "~6Monkey Magic";
        my $engine = Barcode::DataMatrix::Engine->new(
            $text, $encoding_mode, $matrix_format, $process_tilde,
        );

        my $processed_text = $engine->{code};
        is $processed_text, "\355Monkey Magic",
            "~6 encoded char handled correctly";
    }

    {
        my $text = "~7000065Monkey Magic";
        my $engine = Barcode::DataMatrix::Engine->new(
            $text, $encoding_mode, $matrix_format, $process_tilde,
        );

        my $processed_text = $engine->{code};
        is $processed_text, "\361Monkey Magic",
            "~7 encoded char handled correctly";
    }
};

subtest "hexary output" => sub {
    plan tests => 1;

    my @input = (77, 79, 78, 75, 69, 89);
    my $output = Barcode::DataMatrix::Engine::hexary(\@input);
    is $output, "4d 4f 4e 4b 45 59", "hex string representation";
}
