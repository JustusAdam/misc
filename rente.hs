#!/usr/bin/env runhaskell

f :: (Fractional t, Integral a) => t -> (t, t) -> a -> (t, t)
f base (acc, s) a =
  let
    extra =
      if a `mod` 3 == 0
        then s * 1.1
        else s
  in
    (acc * (1 + base) + extra, extra)


main :: IO ()
main = do
  putStrLn $ "Rente gesamt " ++ show total
  putStrLn $ "Monatliche Rente " ++ show  (total / 12 / 25 :: Double)
  putStrLn $ "Letzter monatlicher Beitrag " ++ show (month / 12)
  where
    base = 0.055
    year = 1200
    years = 44
    (total, month) = scanl (f base) (0,year) [(0 :: Int) ..] !! years
