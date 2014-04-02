import Data.Bits
data Bin = Z | O deriving (Eq)

instance Show Bin where
  show Z = show 0
  show O = show 1


s1 = [
         [5, 2, 1, 6, 3, 4, 7, 0],
         [1, 4, 6, 2, 0, 7, 5, 3]
     ]

s2 = [
         [4, 0, 6, 5, 7, 1, 3, 2],
         [5, 3, 0, 7, 6, 2, 1, 4]
     ]

bin2dec :: [Bin] -> Int
bin2dec [] = 0
bin2dec bin@(b:bs)
  | b == Z = bin2dec bs
  | b == O = 2 ^ pwr + bin2dec bs
 where pwr = (length bin)-1

dec2bin :: Int -> [Bin]
dec2bin 0 = [Z]
dec2bin d = dec2bin' d
  where dec2bin' d
          | d == 0         = []
          | d `mod` 2 == 0 = (dec2bin' $ d `div` 2) ++ [Z]
          | d `mod` 2 == 1 = (dec2bin' $ d `div` 2) ++ [O]

expand :: [Bin] -> [Bin]
expand n = (take 2 n) ++ [n!!3] ++ (take 2 (drop 2 n)) ++ [n!!2] ++ (drop 4 n)

generateKeys key = f (cycle key) 4
  where f key 0     = []
        f key limit = [take 8 key] ++ f (tail key) (limit - 1)
