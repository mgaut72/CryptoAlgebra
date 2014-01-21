import CryptoTools

shift_encrypt :: String -> Int -> String
shift_encrypt cs k = map (idxToChar. shift k . charToIdx) (clean cs)

shift_decrypt :: String -> Int -> String
shift_decrypt cs k = shift_encrypt cs (-k)
