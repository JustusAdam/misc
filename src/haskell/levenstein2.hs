levenshtein2 :: String -> String -> Int
levenshtein2 word1 word2 = last $ foldl transform [0..length word1] word2
  where
    transform :: [Int] -> Char -> [Int]
    transform xs@(x:xs') c = scanl compute (x+1) (zip3 word1 xs xs')
      where
        compute :: Int -> (Char , Int, Int) -> Int
        compute z (c', x, y) = minimum [y+1, z+1, x + fromEnum (c' /= c)]
