module ShiftCrack where
import CryptoTools
import Shift
import Data.List
import Data.Ord


encrypted = shift_encrypt 10 "I am going to type up a really long string so\
                            \ that we can perform a frequency analysis of the\
                            \ characters in this string.  We are going to need\
                            \ to have a lot of characters because with a short\
                            \ string, we will have the problem that the\
                            \ characters in this sentence do not conform to the\
                            \ expected distribution given in the english\
                            \ langauge.  If this string isn't long enough\
                            \ I will go back and add more and more\
                            \ letters."

shift_crack :: String -> String
shift_crack cs = shift_decrypt key cs
    where key = maxIndex (letterFreq cs) - (charToIdx 'e') -- 'e' is most common
          maxIndex xs = snd . maximum $ zip xs [0 .. ]
