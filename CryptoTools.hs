module CryptoTools where
import Data.Char (isAlpha, toUpper)

-- converts characters
-- A B .. Z
-- 0 1 .. 25
charToAlphaIdx :: Char -> Int
charToAlphaIdx = subtract 65 . fromEnum . toUpper

alphaIdxToChar :: Int -> Char
alphaIdxToChar = toEnum . (+65)

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

