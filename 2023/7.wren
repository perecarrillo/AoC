import "io" for Stdin
var line = Stdin.readLine().trim()

var pairs = 0
var bids = {}
var hands = []
while (line != "DONE") {
    var hand = line.split(" ")
    bids[hand[0]] = hand[1]
    hands.add(hand[0])

    line = Stdin.readLine().trim()
}
System.print(bids)
// System.print(hands)

var cmp = Fn.new{|h1, h2|
    var letters = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]
    var type1 = 1 // 1: High Card, 2: One pair, 2.5: Two pair, 3: Three kind, 3.5: Full House, 4: Four kind, 5: Five of a kind

    var hasTrio = false
    var hasPair = false

    var nJ = h1.count{|x| x == "J"}

    for (letter in letters) {
        if (letter == "J") break

        var count = h1.count{|x| x == letter}
        if (count == 5) {
            type1 = 5
            break
        } else if (count == 4) {
            type1 = 4
            break
        } else if (count == 3) {
            type1 = 3
            if (hasPair) {
                type1 = 3.5
                break
            }
            hasTrio = true
        } else if (count == 2) {
            type1 = 2
            if (hasTrio) {
                type1 = 3.5
                break
            } else if (hasPair) {
                type1 = 2.5
                break
            }
            hasPair = true
        }
    }

    type1 = type1 + nJ
    if (type1 > 5) type1 = 5
    // if (type1 == 4 && nJ == 1) {
    //     type1 = 5
    // } else if (type1 == 3) {
    //     type1 = type1 + nJ
    // } else if (type1 == 2.5 && nJ == 1) {
    //     type1 = 3.5
    // } else if (type1 == 2) {
    //     type1 = type1 + nJ
    // }

    var type2 = 1
    hasTrio = false
    hasPair = false
    nJ = h2.count{|x| x == "J"}

    for (letter in letters) {
        if (letter == "J") break
        var count = h2.count{|x| x == letter}
        if (count == 5) {
            type2 = 5
            break
        } else if (count == 4) {
            type2 = 4
            break
        } else if (count == 3) {
            type2 = 3
            if (hasPair) {
                type2 = 3.5
                break
            }
            hasTrio = true
        } else if (count == 2) {
            type2 = 2
            if (hasTrio) {
                type2 = 3.5
                break
            } else if (hasPair) {
                type2 = 2.5
                break
            }
            hasPair = true
        }
    }

    type2 = type2 + nJ
    if (type2 > 5) type2 = 5


    // for (letter in letters) {
    //     var count1 = h1.count{|x| x == letter}
    //     var count2 = h2.count{|x| x == letter}

    //     if (type1 == 3 && count1 == 2 || type1 == 1 && count1 == 3) {
    //         // Full
    //         type1 = 3.5
    //     } else if (type1 == 1 && count1 == 2) {
    //         // Two pair
    //         type1 = 2
    //     } else if (type1 < count1) {
    //         if (type1 < 1 && count1 == 2) {
    //             type1 = 1
    //         } else if (type1 < 0 && count1 == 1) {
    //             type1 = 0
    //         } else {
    //             type1 = count1
    //         }
    //     }

    //     if (type2 == 3 && count2 == 2 || type2 == 1 && count2 == 3) {
    //         // Full
    //         type2 = 3.5
    //     } else if (type2 == 1 && count2 == 2) {
    //         // Two pair
    //         type2 = 2
    //     } else if (type2 < count2) {
    //         if (type2 < 1 && count2 == 2) {
    //             type2 = 1
    //         } else if (type2 < 0 && count2 == 1) {
    //             type2 = 0
    //         } else {
    //             type2 = count2
    //         }
    //     }
    // }
    System.print("type1: " + type1.toString + " type2: " + type2.toString)
    if (type1 < type2) return true
    if (type1 > type2) return false
    for (i in (0..h2.count)) {
        if (letters.indexOf(h1[i]) > letters.indexOf(h2[i])) return true
        if (letters.indexOf(h1[i]) < letters.indexOf(h2[i])) return false

        
    }
    System.print("This should never happen")
    // if (letters.indexOf(h1[0]) > letters.indexOf(h2[0])) return true

    
}

// System.print("Hands not sorted")
// System.print(hands)

System.print(cmp.call("QQQJA", "T55J5"))

hands.sort(cmp)

System.print("Hands sorted")
System.print(hands)

var sum = 0
for (rank in (0...hands.count)) {
    sum = sum + (rank + 1) * Num.fromString(bids[hands[rank]])
}
System.print("Result: " + sum.toString)
System.print("END")