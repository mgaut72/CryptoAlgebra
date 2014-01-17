import Data.Char

-- functions to convert
-- a b c ... z
-- 0 1 2 ... 25
-- and back
charToAlphaIdx :: Char -> Int
charToAlphaIdx = subtract 65 . fromEnum . toUpper

alphaIdxToChar :: Int -> Char
alphaIdxToChar = toEnum . (+65)


shift_encrypt :: String -> Int -> String
shift_encrypt plaintext k = map (alphaIdxToChar. shift k . charToAlphaIdx) (filter isAlpha plaintext)

shift k x = mod (x + k) 26

shift_decrypt :: String -> Int -> String
shift_decrypt cyphertext k = map (alphaIdxToChar. unshift k . charToAlphaIdx) (filter isAlpha cyphertext)

unshift k x = mod (x - k) 26

affine_encrypt :: String -> Int -> Int -> String
affine_encrypt plaintext a b = map (alphaIdxToChar. (affine a b) . charToAlphaIdx) (filter isAlpha plaintext)

affine a b x = mod (a * x + b) 26

affine_decrypt :: String -> Int -> Int -> String
affine_decrypt plaintext a b = map (alphaIdxToChar. (unaffine a b) . charToAlphaIdx) (filter isAlpha plaintext)

unaffine a b x = mod (inv 26 a * (x - b)) 26

inv q 1 = 1
inv q p = (n * q + 1) `div` p
  where n = p - inv p (q `mod` p)


sentence = "meet me in the tunnel at midnight"

main = do
  putStrLn $ "sentence : " ++ sentence
  putStrLn $ "shift encoded with k=19 : " ++ shift_encrypt sentence 19
  putStrLn $ "affine encoded with k=5,17 : " ++ affine_encrypt sentence 5 17


