module Jaccard where


import Trigrams
import Data.Set
import Data.Ratio
import Data.Foldable
import Data.Monoid


jaccardCoefficient :: String -> String -> Float
jaccardCoefficient sa sb = fromIntegral (2 * size (intersection ta tb)) / fromIntegral (size ta + size tb)
    where
        ta = extractStrTrigrams sa
        tb = extractStrTrigrams sb


main = do
    let comparators =
            [ ("lung cancer", "cancer of the lung")
            , ("Protein", "Prtoein")
            , ("Reisebus", "Busreise")
            , ("Maus", "Haus")
            ]
    for_ comparators $ \(a, b) ->
        putStrLn $ "coefficient for " <> show a <> " and " <> show b <> " is " <> show (jaccardCoefficient a b)
