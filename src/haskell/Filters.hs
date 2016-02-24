{-# LANGUAGE UnicodeSyntax, ImplicitParams, MultiWayIf #-}

fir :: (?x :: Int -> Float) => Int -> Float
fir k | k < 0 = 0
      | otherwise = 0.25 * (sum (map (\n -> ?x (k - n)) [0..3]))


iir :: (?x :: Int -> Float) => Int -> Float
iir k | k < 0 = 0
      | otherwise = α * y (k - 1) + (1 - α) * ?x k
    where
      α = 0.7
      y = iir


main = do
  let ?x = \k -> if
                  | k < 0 -> 0
                  | k `mod` 2 == 0 -> 1.1
                  | otherwise -> 0.9

  print $ map fir [-2, -1, 0, 1, 2]
  print $ map iir [-2, -1, 0, 1, 2]
