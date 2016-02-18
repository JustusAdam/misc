
import Data.Ratio
import Data.Function hiding ((.))
import Control.Category
import Prelude hiding ((.))
import Data.Monoid


stdDerivF :: [Float] -> Float
stdDerivF l = sqrt $ (1 / (len - 1)) * sum (map (\a -> (a - average) ** 2) l)
  where
    len = fromIntegral $ length l
    average = sum l / len


gMFilter :: Int -> [Float] -> [Float]
gMFilter m l = map calc [0..length l - m]
  where
    calc :: Int -> Float
    calc n = len * sum (map ((+ n) >>> (l !!)) [0..m-1])
    len = 1 / fromIntegral m


main = do
  let l = [-2, 4, -8, 8, -4, 2]

  -- mapM_ ((>>) <$> print <*> print . stdDerivF) lists
  -- print $ gMFilter 2 (lists !! 0)
  -- print $ gMFilter 2 $ gMFilter 2 (lists !! 0)
  -- putStrLn "Standard derivation:"
  -- putStrLn $ "Original " <> show (stdDerivF l)
  -- putStrLn $ "One filter " <> show (stdDerivF $ gMFilter 2 l)
  -- putStrLn $ "Two filters " <> show (stdDerivF $ gMFilter 2 $ gMFilter 2 l
  print $ gMFilter 2 $ gMFilter 2 [0, 0, 0, 1, 0, 0, 0]

  -- print $ lists !! 1 == gMFilter 2 (lists !! 0)
