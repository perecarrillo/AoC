extension Character {
    var isSymbol: Bool {
        let notSymbols = ".0123456789"
        return !notSymbols.contains(self)
    }
}

var line = readLine()!
var first = true
var matrix = [[Character]] ()

while (line != "DONE") {
    if (line != "") {
        if (first) {
            matrix.append([Character](repeating: ".", count: line.count + 2))
            first = false
        }
        matrix.append(Array("." + line + "."))
        
    }
    line = readLine()!
}
matrix.append([Character](repeating: ".", count: matrix[0].count))

let rows = matrix.count
let cols = matrix[0].count

var sum : Int = 0

// Part one
// for i in 1..<matrix.count - 1 {
//     var inNumber = false
//     var hasSymbol = false
//     var number : String = ""
//     for j in 1..<matrix[0].count - 1 {
//         if (matrix[i][j].isNumber) {
//             inNumber = true
//             number += String(matrix[i][j])
//             if (!hasSymbol && (matrix[i-1][j-1].isSymbol || matrix[i-1][j].isSymbol || matrix[i-1][j+1].isSymbol || matrix[i][j-1].isSymbol || matrix[i][j+1].isSymbol || matrix[i+1][j-1].isSymbol || matrix[i+1][j].isSymbol || matrix[i+1][j+1].isSymbol)) {
//                 // print("Found one")
//                 hasSymbol = true
//             }
//         }
//         else {
//             if (inNumber) {
//                 if (hasSymbol) {
//                     if (i > 130) {
                        
//                     print("number found: \(Int(number)!)")
//                     }
//                     sum += Int(number)!
//                 }
//                 inNumber = false
//                 hasSymbol = false
//                 number = ""
//             }
//         }
//     }
//     if (inNumber) {
//         if (hasSymbol) {
//             if (i > 130) {
                
//             print("number found: \(Int(number)!)")
//             }
//             sum += Int(number)!
//         }
//         inNumber = false
//         hasSymbol = false
//         number = ""
//     }
// }

// Part two

var newMatrix = Array(repeating: Array(repeating: 0, count: cols), count: rows)
var gearIdx = [(Int, Int)] ()

for i in 1..<matrix.count - 1 {
    var inNumber = false
    var number : String = ""
    var numberIdx = [(Int, Int)] ()
    for j in 1..<matrix[0].count - 1 {
        if (matrix[i][j] == "*") {
            gearIdx.append((i, j))
        }
        if (matrix[i][j].isNumber) {
            inNumber = true
            number += String(matrix[i][j])
            numberIdx.append((i, j))
        }
        else {
            if (inNumber) {
                for (x, y) in numberIdx {
                    newMatrix[x][y] = Int(number)!
                }
                inNumber = false
                number = ""
                numberIdx = [(Int, Int)] ()
            }
        }
    }
    if (inNumber) {
        for (x, y) in numberIdx {
            newMatrix[x][y] = Int(number)!
        }
        inNumber = false
        number = ""
        numberIdx = [(Int, Int)] ()
    }
}

for (i, j) in gearIdx {
    var numberOne = 0
    var numberTwo = 0
    for x in [-1, 0, 1] {
        for y in [-1, 0, 1] {
            if (newMatrix[i+x][j+y] != 0) {
                if (numberOne == 0) {
                    numberOne = newMatrix[i+x][j+y]
                }
                else if(newMatrix[i+x][j+y] != numberOne) {
                    numberTwo = newMatrix[i+x][j+y]
                }
            }
        }
    }
    sum += numberOne * numberTwo
    
}


print("Total sum: \(sum)")
