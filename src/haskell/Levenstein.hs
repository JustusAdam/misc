import System.Environment
import Data.Maybe


lev :: Eq a => [a] -> [a] -> Int
lev a b =
  (foldl go initialMatrix cells !! (length a - 1)) !! (length b - 1)
  where
    initialMatrix =
      [[x + y | x <- [0..length a]] | y <- [0..length b]]

    cells = [(x, y) | x <- [1..length a], y <- [1..length b]]

    go matrix (x, y) =
      let
        newVal
          | a !! x == b !! y = (matrix !! (x-1)) !! (y-1)
          | otherwise = minimum [ (matrix !! (x-1)) !! y
                                , (matrix !!  x   ) !! (y-1)
                                , (matrix !! (x-1)) !! (y-1)
                                ] + 1
      in
        fromJust (setIndex y newVal (matrix !! x) >>= \r -> setIndex x r matrix)


main :: IO ()
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
