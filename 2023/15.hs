import Data.List.Split
import Data.Char (ord, digitToInt)

type Lens = (String, Int)

main = do
    line <- getLine
    -- print $ foldl suma 0 $ map hashify $ splitOn "," $ line -- Part One
    -- let boxes = [[("rn", 1), ("cm", 2)], [], [], [("ot", 7), ("ab", 5), ("pc", 6)]]
    let boxes = foldl computeAction [[] | x <- [0..255]] (splitOn "," line) -- Part Two
    print $ foldl suma 0 $ map focusPowerBox $ zip boxes [1..(length boxes)]


computeAction :: [[Lens]] -> String -> [[Lens]]
computeAction m x
            | last x == '-' = remove m (hashify $ init x) (init x)
            | otherwise = insert m (hashify label) label (digitToInt $ last x)
            where 
                label = init $ init x

remove :: [[Lens]] -> Int -> String -> [[Lens]]
remove m n s = map (removeIf n s) $ zip m [0..((length m) - 1)]

removeIf :: Int -> String -> ([Lens], Int) -> [Lens]
removeIf x label (m, n)
            | x /= n = m
            | otherwise = removeItem m
            where
                removeItem [] = []
                removeItem ((lab, focal):ls)
                        | lab == label = ls
                        | otherwise = (lab, focal) : removeItem ls

insert :: [[Lens]] -> Int -> String -> Int -> [[Lens]]
insert m id label focal = map (insertIf id label focal) $ zip m [0..(length m - 1)]

insertIf :: Int -> String -> Int -> ([Lens], Int) -> [Lens]
insertIf id label focal (m, n)
            | id /= n = m
            | otherwise = insertItem m
            where
                insertItem [] = [(label, focal)]
                insertItem ((lab, foc):l)
                    | lab == label = (label, focal):l
                    | otherwise = (lab, foc):(insertItem l)

focusPowerBox :: ([Lens], Int) -> Int
focusPowerBox (l, n) = r_focusPowerBox ((reverse l), n)

r_focusPowerBox :: ([Lens], Int) -> Int
r_focusPowerBox ([], _) = 0
r_focusPowerBox (((_, x):l), n) = n * ((length l) + 1) * x + r_focusPowerBox (l, n)

hashify :: [Char] -> Int
hashify l = p_hashify $ reverse l

p_hashify :: [Char] -> Int
p_hashify [] = 0
p_hashify (x:l) = ((p_hashify l + ord x)*17) `mod` 256

suma :: Int -> Int -> Int
suma a b = a + b