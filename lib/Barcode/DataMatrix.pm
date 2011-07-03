package Barcode::DataMatrix;
use Any::Moose;
use Any::Moose '::Util::TypeConstraints';
use Barcode::DataMatrix::Engine ();

our $VERSION = '0.02';

has 'encoding_mode' => (
    is       => 'ro',
    isa      => enum(qw[ ASCII C40 TEXT BASE256 NONE AUTO ]),
    isa      => enum('BCDM_EncodingMode', qw[ ASCII C40 TEXT BASE256 NONE AUTO ]),
    required => 1,
    default  => 'AUTO',
    documentation => 'The encoding mode for the data matrix. Can be one of: ASCII C40 TEXT BASE256 NONE AUTO',
);
has 'process_tilde' => (
    is       => 'ro',
    isa      => 'Bool',
    required => 1,
    default  => 0,
    documentation => 'Set to true to indicate the tilde character "~" is being used to recognize special characters.',
);

=head1 NAME

Barcode::DataMatrix - Generate data for Data Matrix barcodes

=head1 SYNOPSIS

    use Barcode::DataMatrix;
    my $data = Barcode::DataMatrix->new->barcode('MONKEY');
    for my $row (@$data) {
        print for map { $_ ? "#" : ' ' } @$row;
        print "\n";
    }

=cut

=head1 DESCRIPTION

This class is used to generate data for Data Matrix barcodes. It is primarily
useful as a data source for barcode modules that do rendering,
such as L<HTML::Barcode::DataMatrix>.  You can easily make a version that
renders an image, PDF, or anything else.

=head1 METHODS

=head2 new (%attributes)

Instantiate a new Barcode::DataMatrix object. The C<%attributes> hash
can take any of the other L<attributes|/ATTRIBUTES> listed below.

=cut

=head2 barcode ($text)

Generate barcode data representing the C<$text> string.  This returns
an array ref of rows in the data matrix, each containing array refs of 
cells within that row. The cells are true and false values
that represent filled or empty squares.

This can throw an exception if it's unable to generate the barcode data.

=cut

sub barcode {
    my ($self, $text) = @_;

    my $engine = Barcode::DataMatrix::Engine->new(
        $text,
        $self->encoding_mode,
        undef, # size
        $self->process_tilde,
    );

    my $rows = $engine->{rows};
    my $cols = $engine->{cols};
    my $bitmap = $engine->{bitmap};
    my $rv = [];
    for my $r (0 .. $rows - 1) {
        my $row = [];
        for my $c (0 .. $cols - 1) {
            push @$row, ($bitmap->[$c]->[$r] ? 1 : 0);
        }
        push @$rv, $row;
    }

    return $rv;
}

=head1 ATTRIBUTES

=head2 encoding_mode

The encoding mode for the data matrix. Can be one of:
C<AUTO> (default), C<ASCII>, C<C40>, C<TEXT>, C<BASE256>, or C<NONE>.

=head2 process_tilde

Set to true to indicate the tilde character "~" is being used to recognize
special characters. See this page for more information:
L<http://www.idautomation.com/datamatrixfaq.html>

=cut

=head1 AUTHOR

Mons Anderson C<< <inthrax@gmail.com> >> (GD::Barcode::DataMatrix at L<http://code.google.com/p/perl-ex/>, from which this distribution originates)

Mark A. Stratman, C<< <stratman@gmail.com> >>

=head1 SOURCE REPOSITORY

L<http://github.com/mstratman/Barcode-DataMatrix>

=head1 SEE ALSO

=over 4

=item L<HTML::Barcode::DataMatrix>

=item L<http://grandzebu.net/index.php?page=/informatique/codbar-en/datamatrix.htm>

=item L<http://www.idautomation.com/datamatrixfaq.html>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2011 the AUTHORs listed above.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

no Any::Moose;
1; # End of Barcode::DataMatrix
