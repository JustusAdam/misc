
import qualified Data.Foldable as F

foldrM :: (Foldable f, Monad m) => (a -> b -> m b) -> b -> f a -> m b
foldrM f z0 xs = foldr inner (return z0) xs
    where
        inner x accum = accum >>= f x


main = do

    let values = [1..1000000]
    let f = (return .) . (+) :: Int -> Int -> Maybe Int

    -- print $ foldrM f 5 values
    print $ F.foldrM f 5 values
