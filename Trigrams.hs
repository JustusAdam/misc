module Trigrams where


import Safe
import Data.List
import Data.Set


extractTrigrams :: Ord a => [a] -> Set [a]
extractTrigrams (x:y:z:xs) =
    fromList $ scanl f initial xs
    where
        initial = [x, y, z]
        f (x:xs) i = xs ++ [i]
extractTrigrams _ = empty


extractStrTrigrams :: String -> Set String
extractStrTrigrams l =
    unions $ fmap extractTrigrams $ lines l >>= words
