-- def lev(a, b):
--     matrix = [
--         [ax+bx for bx in range(len(b)+1)]
--         for ax in range(len(a)+1)
--     ]
--
--     for row in range(1,len(matrix)):
--         for col in range(1,len(matrix[row])):
--             if a[row-1] == b[col-1]:
--                 matrix[row][col] = matrix[row-1][col-1]
--             else:
--                 matrix[row][col] = min(matrix[row][col-1], matrix[row-1][col], matrix[row-1][col-1]) + 1
--
--     # for row in matrix:
--     #     print(row)
--
--     return matrix[-1][-1]
--

import System.Environment
import Data.Maybe


lev :: String -> String -> Int
lev a b =
  (foldl go initialMatrix cells !! (length a - 1)) !! (length b - 1)
  where
    initialMatrix :: [[Int]]
    initialMatrix =
      [[x + y | x <- [0..length a]] | y <- [0..length b]]

    cells :: [(Int, Int)]
    cells = [(x, y) | x <- [1..length a], y <- [1..length b]]

    go :: [[Int]] -> (Int, Int) -> [[Int]]
    go matrix (x, y) =
      let
        newVal
          | a !! x == b !! y = (matrix !! (x-1)) !! (y-1)
          | otherwise = minimum [(matrix !! (x-1)) !! y, (matrix !! x) !! (y-1), (matrix !! (x-1)) !! (y-1)] + 1
      in
        fromJust (setIndex y newVal (matrix !! x) >>= \r -> setIndex x r matrix)


main = do
  [a,b] <- getArgs
  print $ lev a b


setIndex :: Int -> a -> [a] -> Maybe [a]
setIndex i e l
  | i < 0 = if (- i) > length l
              then Nothing
              else setIndex (length l + i) e l
  | i == 0 = Just (e:l)
  | otherwise =
    case rest of
      (_:tail') -> Just (head' ++ (e:tail'))
      _ -> Nothing
  where
    (head', rest) = splitAt i l
