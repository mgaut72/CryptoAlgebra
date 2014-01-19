import CryptoTools

affine_encrypt :: String -> Int -> Int -> String
affine_encrypt cs a b = map (alphaIdxToChar. (affine a b) . charToAlphaIdx) (clean cs)
      where affine a b x = (a * x + b) `mod` 26

affine_decrypt :: String -> Int -> Int -> String
affine_decrypt cs a b = map (alphaIdxToChar . (unaffine a b) . charToAlphaIdx) (clean cs)
      where unaffine a b x = inverse 26 a * (x - b) `mod` 26

-- calculate multiplicative inverse in arbitary Z/qZ
inverse q 1 = 1
inverse q p = (n * q + 1) `div` p
      where n = p - inv p (q `mod` p)
