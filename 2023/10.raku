my $line = prompt;
my @map;
my @newMap;
while $line ne 'DONE' {
    @map.push: $line;
    my $a = '.';
    $a = $a ~ '.' for 1..$line.encode.elems - 1;
    @newMap.push: $a;
    $line = prompt;
}

my $row = 0;
my $r1;
my $c1;
my $r2;
my $c2;
my $pr1;
my $pc1;
my $pr2;
my $pc2;
my $irow;
my $icol;
say @map[1].substr(1, 1);
for @map -> $i {
    my $col = $i.index("S");
    if $col {
        # Replace with the needed by the input (Big Input: L)
        # Hardcoded because I'm lazy
        # @map[$row] = @map[$row].subst('S', 'F');
        @map[$row] = @map[$row].subst('S', 'L');
        $irow = $row;
        $icol = $col;
        
    }
    # say $i;
    ++$row;
}

$r1 = $irow;
$c1 = $icol;
$r2 = $irow;
$c2 = $icol;
$pr1 = $irow - 1; # + -
$pc1 = $icol;
$pr2 = $irow;
$pc2 = $icol + 1;

sub getNextPos(@map, $opx, $opy, $ox, $oy) {
    # | - L J F 7
    my $y = $oy;
    my $x = $ox;
    my $px = $opx;
    my $py = $opy;
    if @map[$x].substr($y, 1) eq "-" {
        $py = $y;
        if $opy == $y - 1 {$y = $y + 1;}
        else {$y = $y - 1;}
    }
    elsif @map[$x].substr($y, 1) eq "|" {
        $px = $x;
        if $opx == $x - 1 {$x = $x + 1;}
        else {$x = $x - 1;}
    }
    elsif @map[$x].substr($y, 1) eq "L" {
        if $px == $x - 1 {
            $px = $x;
            $y = $y + 1;
        }
        else {
            $py = $y;
            $x = $x - 1;
        }
    }
    elsif @map[$x].substr($y, 1) eq "J" {
        if $px == $x - 1 {
            $px = $x;
            $y = $y - 1;
        }
        else {
            $py = $y;
            $x = $x - 1;
        }
    }
    elsif @map[$x].substr($y, 1) eq "F" {
        if $px == $x + 1 {
            $px = $x;
            $y = $y + 1;
        }
        else {
            $py = $y;
            $x = $x + 1;
        }
    }
    elsif @map[$x].substr($y, 1) eq "7" {
        if $px == $x + 1 {
            $px = $x;
            $y = $y - 1;
        }
        else {
            $py = $y;
            $x = $x + 1;
        }
    }
    return($px, $py, $x, $y);
}


my $count = 0;
my $first = True;
# say "Iteration $count, Previous: $pr1, $pr2. Actual: $r1, $r2";
while $r1 != $r2 || $c1 != $c2 || $first {
    $first = False;
    @newMap[$r1].substr-rw($c1, 1) = @map[$r1].substr($c1, 1);
    @newMap[$r2].substr-rw($c2, 1) = @map[$r2].substr($c2, 1);
    ($pr1, $pc1, $r1, $c1) = getNextPos(@map, $pr1, $pc1, $r1, $c1);
    ($pr2, $pc2, $r2, $c2) = getNextPos(@map, $pr2, $pc2, $r2, $c2);
    ++$count;
    # say "Iteration $count, Previous: $pr1, $pr2. Actual: $r1, $r2";
}
@newMap[$r2].substr-rw($c2, 1) = @map[$r2].substr($c2, 1);

# Part one
say $count;

.say for @newMap;
# for @newMap {
#     say $_;
# }

$r1 = $irow;
$c1 = $icol;
$r2 = $irow;
$c2 = $icol;
$pr1 = $irow - 1; # + -
$pc1 = $icol;
$pr2 = $irow;
$pc2 = $icol + 1;

# Update when changing files
# True if inside is inside F, L, 7, J or left |, above - 
my $bestName = True;
$first = True;

sub insideMap(@map, $r, $c) {
    if $r < 0 || $c < 0 {return False;}
    if $r > @map.elems - 1 {return False;}
    if $c > @map[$r].chars - 1 {return False;}
    return True;
}

while $r1 != $r2 || $c1 != $c2 || $first {
    $first = False;
    my $letter = @newMap[$r1].substr($c1, 1);
    if $letter eq 'F' {
        # We need to invert bestName
        $bestName = !$bestName;
        my $inF;
        my $outF;
        # True if inside is inside F, L, 7, J or left |, above - 
        if $bestName {
            $inF = 'I';
            $outF = 'O';
            $bestName = False;
        }
        else {
            $inF = 'O';
            $outF = 'I';
            $bestName = True;
        }
        if insideMap(@newMap, $r1 + 1, $c1 + 1) && @newMap[$r1 + 1].substr($c1 + 1, 1) eq '.' {@newMap[$r1 + 1].substr-rw($c1 + 1, 1) = $inF;}
        if insideMap(@newMap, $r1 - 1, $c1) && @newMap[$r1 - 1].substr($c1, 1) eq '.' {@newMap[$r1 - 1].substr-rw($c1, 1) = $outF;}
        if insideMap(@newMap, $r1, $c1 - 1) && @newMap[$r1].substr($c1 - 1, 1) eq '.' {@newMap[$r1].substr-rw($c1 - 1, 1) = $outF;}
    }
    elsif $letter eq 'L' {
        # If coming from above we need to invert bestName
        if $pr1 == $r1 - 1 {$bestName = !$bestName;}
        my $inL;
        my $outL;
        # True if inside is inside F, L, 7, J or left |, above - 
        if $bestName {
            $inL = 'I';
            $outL = 'O';
            $bestName = $pr1 == $r1 - 1; # True if coming from above and false if coming from the side
        }
        else {
            $inL = 'O';
            $outL = 'I';
            $bestName = $pc1 == $c1 + 1; # False if coming from above and true if coming from the side
        }
        if insideMap(@newMap, $r1 - 1, $c1 + 1) && @newMap[$r1 - 1].substr($c1 + 1, 1) eq '.' {@newMap[$r1 - 1].substr-rw($c1 + 1, 1) = $inL;}
        if insideMap(@newMap, $r1 + 1, $c1) && @newMap[$r1 + 1].substr($c1, 1) eq '.' {@newMap[$r1 + 1].substr-rw($c1, 1) = $outL;}
        if insideMap(@newMap, $r1, $c1 - 1) && @newMap[$r1].substr($c1 - 1, 1) eq '.' {@newMap[$r1].substr-rw($c1 - 1, 1) = $outL;}
    }
    elsif $letter eq '7' {
        # If coming from left, invert
        if $pc1 == $c1 - 1 {$bestName = !$bestName;}
        my $in7;
        my $out7;
        # True if inside is inside F, L, 7, J or left |, above - 
        if $bestName {
            $in7 = 'I';
            $out7 = 'O';
            $bestName = $pc1 == $c1 - 1;
        }
        else {
            $in7 = 'O';
            $out7 = 'I';
            $bestName = $pr1 == $r1 + 1;
        }
        if insideMap(@newMap, $r1 + 1, $c1 - 1) && @newMap[$r1 + 1].substr($c1 - 1, 1) eq '.' {@newMap[$r1 + 1].substr-rw($c1 - 1, 1) = $in7;}
        if insideMap(@newMap, $r1 - 1, $c1) && @newMap[$r1 - 1].substr($c1, 1) eq '.' {@newMap[$r1 - 1].substr-rw($c1, 1) = $out7;}
        if insideMap(@newMap, $r1, $c1 + 1) && @newMap[$r1].substr($c1 + 1, 1) eq '.' {@newMap[$r1].substr-rw($c1 + 1, 1) = $out7;}
    }
    elsif $letter eq 'J' {
        my $inJ;
        my $outJ;
        # True if inside is inside F, L, 7, J or left |, above - 
        if $bestName {
            $inJ = 'I';
            $outJ = 'O';
            $bestName = True;
        }
        else {
            $inJ = 'O';
            $outJ = 'I';
            $bestName = False;
        }
        if insideMap(@newMap, $r1 - 1, $c1 - 1) && @newMap[$r1 - 1].substr($c1 - 1, 1) eq '.' {@newMap[$r1 - 1].substr-rw($c1 - 1, 1) = $inJ;}
        if insideMap(@newMap, $r1 + 1, $c1) && @newMap[$r1 + 1].substr($c1, 1) eq '.' {@newMap[$r1 + 1].substr-rw($c1, 1) = $outJ;}
        if insideMap(@newMap, $r1, $c1 + 1) && @newMap[$r1].substr($c1 + 1, 1) eq '.' {@newMap[$r1].substr-rw($c1 + 1, 1) = $outJ;}
    }
    elsif $letter eq '-' {
        my $above;
        my $below;
        # True if inside is inside F, L, 7, J or left |, above - 
        if $bestName {
            $above = 'I';
            $below = 'O';
        }
        else {
            $above = 'O';
            $below = 'I';
        }
        if insideMap(@newMap, $r1 - 1, $c1) && @newMap[$r1 - 1].substr($c1, 1) eq '.' {@newMap[$r1 - 1].substr-rw($c1, 1) = $above;}
        if insideMap(@newMap, $r1 + 1, $c1) && @newMap[$r1 + 1].substr($c1, 1) eq '.' {@newMap[$r1 + 1].substr-rw($c1, 1) = $below;}
    }
    elsif $letter eq '|' {
        my $left;
        my $right;
        # True if inside is inside F, L, 7, J or left |, above - 
        if $bestName {
            $left = 'I';
            $right = 'O';
        }
        else {
            $left = 'O';
            $right = 'I';
        }
        if insideMap(@newMap, $r1, $c1 - 1) && @newMap[$r1].substr($c1 - 1, 1) eq '.' {@newMap[$r1].substr-rw($c1 - 1, 1) = $left;}
        if insideMap(@newMap, $r1, $c1 + 1) && @newMap[$r1].substr($c1 + 1, 1) eq '.' {@newMap[$r1].substr-rw($c1 + 1, 1) = $right;}
    }
    
    
    ($pr1, $pc1, $r1, $c1) = getNextPos(@map, $pr1, $pc1, $r1, $c1);
    # say "Previous: $pr1, $pr2. Actual: $r1, $r2";
}

# Assuming that with 50 iterations it will be full
for 0..50 {
    for 0..@newMap.elems - 1 -> $row {
        for 0..@newMap[$row].chars -> $i {
            if @newMap[$row].substr($i, 1) eq '.' {
                if insideMap(@newMap, $row, $i - 1) && 'OI'.contains(@newMap[$row].substr($i - 1, 1)) {@newMap[$row].substr-rw($i, 1) = @newMap[$row].substr($i - 1, 1);}
                if insideMap(@newMap, $row, $i + 1) && 'OI'.contains(@newMap[$row].substr($i + 1, 1)) {@newMap[$row].substr-rw($i, 1) = @newMap[$row].substr($i + 1, 1);}
                if insideMap(@newMap, $row - 1, $i) && 'OI'.contains(@newMap[$row - 1].substr($i, 1)) {@newMap[$row].substr-rw($i, 1) = @newMap[$row - 1].substr($i, 1);}
                if insideMap(@newMap, $row + 1, $i) && 'OI'.contains(@newMap[$row + 1].substr($i, 1)) {@newMap[$row].substr-rw($i, 1) = @newMap[$row + 1].substr($i, 1);}
            }
        }
    }
}

say "InOut";
.say for @newMap;

my $sum = 0;
$sum += .indices('I').elems for @newMap;

say "Result: $sum";