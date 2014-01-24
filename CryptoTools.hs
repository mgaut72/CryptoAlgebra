module CryptoTools where
import Data.Char (isAlpha, toUpper)
import Data.List (nub)
import Data.Ratio


-- converts characters
-- A B .. Z
-- 0 1 .. 25
charToIdx :: Char -> Int
charToIdx = subtract 65 . fromEnum . toUpper

idxToChar :: Int -> Char
idxToChar = toEnum . (+65)

-- convention : plaintext stripped to to alpha chars before encryption
clean :: String -> String
clean = filter isAlpha


-- classical cryptosystems often rely on shifting by some key
shift :: Int -> Int -> Int
shift k x = (x + k) `mod` 26

unshift :: Int -> Int -> Int
unshift k x = (x - k) `mod`  26


-- frequencies of each english letter in common text
englishFrequencies = [ 0.082, 0.015, 0.028, 0.043, 0.127, 0.022, 0.020, 0.061
                     , 0.070, 0.002, 0.008, 0.040, 0.024, 0.067, 0.075, 0.019
                     , 0.001, 0.060, 0.063, 0.091, 0.028, 0.010, 0.023, 0.001
                     , 0.020, 0.001 ]

-- get the frequencies of letters in a given string
letterFreq :: String -> [Double]
letterFreq s = [ normalize . countC c $ (map toUpper s) | c <- ['A' .. 'Z']]
    where countC c  = length . filter (== c)
          normalize = (/ fromIntegral (length s)) . fromIntegral

-- Euler phi function, nieve
phi' :: Int -> Int
phi' x = length [ a | a <- [1..(x-1)], gcd a x == 1 ]

phi :: (Integral a) => a -> a
phi 1 = 1
phi n = numerator ratio `div` denominator ratio
 where ratio = foldl (\acc x -> acc * (1 - (1 % x)))
                        (n % 1) $ nub (factors n)
factors 1 = []
factors n = let divisors = dropWhile ((/= 0) . mod n) [2 .. ceiling $ sqrt $ fromIntegral n]
               in let prime = if null divisors then n else head divisors
                      in (prime :) $ factors $ div n prime
