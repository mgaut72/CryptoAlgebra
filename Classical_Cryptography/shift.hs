import CryptoTools

shift_encrypt :: Int -> String -> String
shift_encrypt k cs = map (idxToChar. shift k . charToIdx) (clean cs)

shift_decrypt :: Int -> String -> String
shift_decrypt k cs = shift_encrypt (-k) cs
