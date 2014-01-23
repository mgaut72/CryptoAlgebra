module Playfair where
import CryptoTools
import qualified Data.Set as Set
import Data.Char
import Data.List

playfair_encrypt :: String -> String -> String
playfair_encrypt ks cs = map toUpper (peHelper (makeArray ks) (clean cs))

playfair_decrypt :: String -> String -> String
playfair_decrypt ks cs = map toLower (pdHelper (makeArray ks) (map toLower (clean cs)))

peHelper :: String -> String -> String
peHelper _  [] = []
peHelper ks (a:[]) = peHelper ks (a:'x':[])
peHelper ks (a:b:cs)
    | a == b       = peHelper ks (a:'x':b:cs)
    | colA == colB = (d1r rowA colA):(d1r rowB colB):(peHelper ks cs)
    | rowA == rowB = (o1c rowA colA):(o1c rowB colB):(peHelper ks cs)
    | otherwise    = (charAt ks (rowA, colB)):(charAt ks (rowB, colA)):(peHelper ks cs)
  where colA = snd (idx2D ks a)
        rowA = fst (idx2D ks a)
        colB = snd (idx2D ks b)
        rowB = fst (idx2D ks b)
        d1r r c = charAt ks ((r + 1) `mod` 5, c) -- down 1 row
        o1c r c = charAt ks (r, (c + 1) `mod` 5) -- over 1 col

pdHelper :: String -> String -> String
pdHelper _  [] = []
pdHelper ks (a:b:cs)
    | colA == colB = (d1r rowA colA):(d1r rowB colB):(pdHelper ks cs)
    | rowA == rowB = (o1c rowA colA):(o1c rowB colB):(pdHelper ks cs)
    | otherwise    = (charAt ks (rowA, colB)):(charAt ks (rowB, colA)):(pdHelper ks cs)
  where colA = snd (idx2D ks a)
        rowA = fst (idx2D ks a)
        colB = snd (idx2D ks b)
        rowB = fst (idx2D ks b)
        d1r r c = charAt ks ((r - 1) `mod` 5, c) -- down 1 row
        o1c r c = charAt ks (r, (c - 1) `mod` 5) -- over 1 col



makeArray cs = (makeUnique cs) ++ restOfAlphabet
    where restOfAlphabet = (Set.toList $ Set.difference alphaSet cSet)
          cSet = Set.fromList cs
          alphaSet = Set.fromList $ ['a'..'i'] ++ ['k'..'z']


makeUnique :: [Char] -> [Char]
makeUnique = muHelper Set.empty
    where muHelper _ [] = []
          muHelper a (b : bs) = if Set.member b a
                         then muHelper a bs
                         else b : muHelper (Set.insert b a) bs


idx2D arr c = (idx arr c) `divMod` 5
    where idx arr c = case elemIndex c arr of
                           Nothing -> idx arr 'i'
                           Just x  -> x

charAt :: String -> (Int, Int) -> Char
charAt arr (r,c) = arr !! ((r * 5) + c)


