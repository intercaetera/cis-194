module Golf where

skips :: [a] -> [[a]]
skips xs = [pickEvery i xs | i <- [1..length xs]]

pickEvery :: Int -> [a] -> [a]
pickEvery i xs = [xs !! (n - 1) | n <- [1..length xs], n `mod` i == 0]

localMaxima :: [Integer] -> [Integer]
localMaxima (x:y:z:rest)
  | y > x && y > z = y : localMaxima (y:z:rest)
  | otherwise = localMaxima (y:z:rest)
localMaxima _ = []
