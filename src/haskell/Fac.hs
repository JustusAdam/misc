{-# LANGUAGE TypeFamilies #-}

afac :: (Num a, Eq a) => a -> a -> a
afac a 0 = a
afac a n = afac (n*a) (n-1)

main = do
    i <- readLn
    print $ afac i 3
    print $ afac 2 (3 :: Int)
