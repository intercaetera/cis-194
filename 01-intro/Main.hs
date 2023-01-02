toDigits :: Int -> [Int]
toDigits x
  | x <= 0 = []
  | otherwise = toDigits (x `div` 10) ++ [x `mod` 10]

doubleEven :: [Int] -> [Int]
doubleEven [] = []
doubleEven [x] = [x]
doubleEven (x:y:xs) = x : (y * 2) : doubleEven xs

doubleEveryOther :: [Int] -> [Int]
doubleEveryOther = reverse . doubleEven . reverse

sumDigits :: [Int] -> Int
sumDigits = sum . concatMap toDigits

validate :: Int -> Bool
validate x = (sumDigits . doubleEveryOther . toDigits) x `mod` 10 == 0
