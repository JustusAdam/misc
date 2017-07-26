
import Data.Foldable


compress [] = []
compress (x:xs) = x:go x xs
  where
    go _ [] = []
    go x' (x:xs) | x == x' = go x xs
    go _ (x:xs) = x:go x xs


pack [] = []
pack (x:xs) = go [x] xs
  where
    go acc [] = [acc]
    go [] _ = error "invariant broken"
    go acc@(x':_) (x:xs) | x == x' = go (x:acc) xs
    go acc (x:xs) = acc:go [x] xs

encode :: Eq a => [a] -> [(a, Int)]
encode [] = []
encode (x:xs) = reverse $ uncurry (:) $ foldl' f ((x,1), []) xs
  where
    f ((x, count), acc) x' | x == x' = ((x, succ count), acc)
    f (e, acc) x = ((x, 1), e:acc)


encode2 :: Eq a => [a] -> [Either a (a, Int)]
encode2 [] = []
encode2 (x:xs) = reverse $ uncurry (:) $ foldl' f (Left x, []) xs
  where
    f (e, acc) x' | getElem e == x' = (increment e, acc)
    f (e, acc) x = (Left x, e:acc)

    getElem (Left e) = e
    getElem (Right (e, _)) = e

    increment (Left e) = Right (e, 2)
    increment (Right (e, count)) = Right (e, succ count)


decode2 :: [Either a (a, Int)] -> [a]
decode2 = concatMap f
  where
    f (Left e) = [e]
    f (Right (e, count)) = replicate count e
