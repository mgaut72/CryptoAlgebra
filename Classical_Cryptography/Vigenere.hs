module Vigenere where
import CryptoTools

vigenere_encrypt :: [Int] -> String -> String
vigenere_encrypt ks cs = zipWith shiftLetter (clean cs) (cycle ks)
  where shiftLetter c x = idxToChar . shift x . charToIdx $ c

vigenere_decrypt :: [Int] -> String -> String
vigenere_decrypt ks cs= vigenere_encrypt (map negate ks) cs
