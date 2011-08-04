use strict;
use warnings;

use Test::More;

# FILENAME: 01-apptest_unconfigured.t
# CREATED: 04/08/11 18:46:16 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Test that dzil runs on an unconfigured dist

use FindBin;
use File::Spec::Functions qw( catdir rel2abs );
use File::Temp qw( tempdir );
use File::Copy::Recursive qw( dircopy );
use File::pushd qw( pushd );

my $root = catdir( rel2abs($FindBin::Bin), 'apptest', '03_bad_config' );
my $tmpdir = tempdir( CLEANUP => 1 );
my $bdir = catdir( $tmpdir, '03_bad_config' );

note explain { root => $root, tmpdir => $tmpdir, bdir => $bdir };

ok( dircopy( $root, $bdir ), "Copied directory to tmpdir" )
    or diag explain {
    args  => [ $root, $bdir ],
    error => $!,
    };

{
    my $dir = pushd($bdir);
    my $result;
    local $@;
    eval { $result = system( 'dzil', 'perltidy' ); };
    my $res = $@;

    isnt( $result, 0, "perltidy fails with a bad config path" )
        and note explain {
        '$@'   => $res,
        '$?'   => $?,
        '$!'   => $!,
        result => $result,
        };
}

done_testing;

