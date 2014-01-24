module Affine where
import CryptoTools

affine_encrypt :: Int -> Int -> String -> String
affine_encrypt a b cs = map (idxToChar. affine a b . charToIdx) (clean cs)
      where affine a b c = (a * c + b) `mod` 26

affine_decrypt :: Int -> Int -> String -> String
affine_decrypt a b cs = map (idxToChar . unaffine a b . charToIdx) (clean cs)
      where unaffine a b c = inverse 26 a * (c - b) `mod` 26

-- calculate multiplicative inverse in arbitary Z/qZ
inverse q 1 = 1
inverse q p = (n * q + 1) `div` p
      where n = p - inverse p (q `mod` p)
