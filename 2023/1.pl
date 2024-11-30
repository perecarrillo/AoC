# Solves the first problem of the AoC 2023
use strict;
use warnings;
my $sum  = 0;
my $line = "0abc0";

while ($line = <STDIN>) {
    my $f = 0;
    my $l = 0;
    my $c = 0;

    # my $first = "true";
    for my $i (0..length($line) - 1) {
        my $c = substr($line, $i, 1);
        my $prev = substr($line, 0, $i);
        if (index($prev, "one") != -1) {
            $c = "1";
        }
        elsif (index($prev, "two") != -1) {
                $c = "2";
            }
        elsif (index($prev, "three") != -1) {
                $c = "3";
            }
        elsif (index($prev, "four") != -1) {
                $c = "4";
            }
        elsif (index($prev, "five") != -1) {
                $c = "5";
            }
        elsif (index($prev, "six") != -1) {
                $c = "6";
            }
        elsif (index($prev, "seven") != -1) {
                $c = "7";
            }
        elsif (index($prev, "eight") != -1) {
                $c = "8";
            }
        elsif (index($prev, "nine") != -1) {
                $c = "9";
            }
        if ($c =~ m/\d/) {
                $f = $c;
                last;
                # if ($first eq "true") {
                #     $f     = $c;
                #     $first = "false";
                # }
                # $l = $c;
            }
    }
    $line = reverse($line);
    for my $i (0..length($line) - 1) {
        my $c = substr($line, $i, 1);
        my $prev = substr($line, 0, $i);
        if (index($prev, "eno") != -1) {
            $c = "1";
        }
        elsif (index($prev, "owt") != -1) {
                $c = "2";
            }
        elsif (index($prev, "eerht") != -1) {
                $c = "3";
            }
        elsif (index($prev, "ruof") != -1) {
                $c = "4";
            }
        elsif (index($prev, "evif") != -1) {
                $c = "5";
            }
        elsif (index($prev, "xis") != -1) {
                $c = "6";
            }
        elsif (index($prev, "neves") != -1) {
                $c = "7";
            }
        elsif (index($prev, "thgie") != -1) {
                $c = "8";
            }
        elsif (index($prev, "enin") != -1) {
                $c = "9";
            }
        if ($c =~ m/\d/) {
                $l = $c;
                last;
                # if ($first eq "true") {
                #     $f     = $c;
                #     $first = "false";
                # }
                # $l = $c;
            }
    }
    # print "New line readed\n";
    print "$f$l\n";

    $sum = int($sum) + int($f . $l);
    print "$sum\n";
}

print "Total sum: $sum";