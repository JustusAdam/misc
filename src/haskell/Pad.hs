module Pad where
    
chunk :: Int -> String -> [String]
chunk n l 
    | length l < n = [l ++ ('1' : replicate (n - length l - 1) '0')]
    | otherwise = x : chunk n xs
    where (x,xs) = splitAt n l