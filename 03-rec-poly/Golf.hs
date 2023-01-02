module Golf where

import Data.List

skips :: [a] -> [[a]]
skips xs = [pickEvery i xs | i <- [1..length xs]]

pickEvery :: Int -> [a] -> [a]
pickEvery i xs = [xs !! (n - 1) | n <- [1..length xs], n `mod` i == 0]


localMaxima :: [Integer] -> [Integer]
localMaxima (x:y:z:rest)
  | y > x && y > z = y : localMaxima (y:z:rest)
  | otherwise = localMaxima (y:z:rest)
localMaxima _ = []


histogram :: [Int] -> String
histogram = unlines . addScale . map concat . reverse . transpose . toLines . frequencies

frequency :: Eq a => a -> [a] -> Int
frequency x = length . filter (== x)

frequencies :: [Int] -> [Int]
frequencies xs = map (`frequency` xs) [0..9]

line :: Int -> Int -> [String]
line m 0 = replicate m " "
line m x = replicate x "*" ++ replicate (m - x) " "

toLines :: [Int] -> [[String]]
toLines xs = map (line (maximum xs)) xs

addScale :: [String] -> [String]
addScale strs = strs ++ ["==========\n0123456789\n"] 
