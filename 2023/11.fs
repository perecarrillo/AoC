open System
open System.Collections.Generic

let mutable line = Console.ReadLine()
let galaxies = new List<string>()
let emptyRows = new List<int>()
let mutable i = 0
while line <> "DONE" do
  // printf "%s \n" line
  galaxies.Add(line)
  if not (line.Contains('#')) then
    emptyRows.Add(i)
    // galaxies.Add(line)
  
    // printf "%s \n" line
  i <- i + 1
  line <- Console.ReadLine()

let newGalaxies = new List<string> ()
let emptyCols = new List<int>()
i <- 0
while i < String.length (galaxies.[0]) - 1 do
  if galaxies.TrueForAll(fun str -> str.[i].Equals('.')) then
    emptyCols.Add(i)
    // newGalaxies.Clear()
    // for gal in galaxies do
      // let str = new List<char> (Seq.toList gal)
      // str.Insert(i, '.')
        
      // newGalaxies.Add(System.String(str.ToArray()))
     
    // galaxies.Clear()
    // for gal in newGalaxies do
      // galaxies.Add(gal)
    // i <- i + 1
  i <- i + 1

let coords = new List<int * int> ()

i <- 0

for gal in galaxies do
  let line= new List<char> (Seq.toList gal)
  let mutable c = line.FindIndex(fun cha -> cha.Equals('#'))
  while c <> -1 do
    coords.Add((i, c))
    c <- line.FindIndex(c + 1, fun cha -> cha.Equals('#'))
  i <- i + 1

// printf "%A \n" coords

i <- 0
let mutable sum = 0UL
for (x, y) in coords do 
  // printf "%d %d \n" x y
  for (x2, y2) in Seq.skip i coords do
    let normDist = abs (x - x2) + abs (y - y2)
    sum <- sum + uint64(normDist)
    for z in emptyRows do
      if z < x && z > x2 || z < x2 && z > x then
        sum <- sum + 1000000UL - 1UL
    for z in emptyCols do
      if z < y && z > y2 || z < y2 && z > y then
        sum <- sum + 1000000UL - 1UL
  i <- i + 1

printf "Total sum: %d" sum
