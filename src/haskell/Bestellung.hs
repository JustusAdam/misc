module Bestellung where
  
  
import Data.Foldable

items =
  [ ("Invertocat Hoodie", 55)
  , ("Black GitHub mug", 12)
  , ("Arctocat", 25)
  , ("Invertocat 2.0", 25)
  , ("Atom and electron Sticker", 5)
  , ("Piratocat", 25) -- 5
  , ("Die Cut Sticker", 1)
  , ("Sticker Pack 3", 5)
  , ("Atom Coasters", 5)
  , ("Octicons Shirt", 25)
  ]

people =
  [ ("Kilian", [0, 1, 2])
  , ("Steiger", [3])
  , ("Justus", [2, 4])
  , ("Hoodie", [5, 6])
  , ("Felix D.", [1])
  , ("Felix W", [0, 4, 1])
  , ("Sascha", [2, 3])
  , ("Stephan", [1, 7])
  , ("Philipp", [8])
  , ("Lucas V", [9])
  , ("Laen", [0])
  , ("Ollie", [8])
  ]


toFull p = p * 1.58


main = do
  for_ items $ \(name, price) ->
    putStrLn $ name ++ ": " ++ show (toFull price) ++ "€"
  putStrLn ""
  putStrLn ""
  for_ people $ \(name, itemIndexes) -> do
    let cItems = map (snd . (items !!)) itemIndexes
    let total = sum cItems
    putStrLn $ name ++ ": " ++ show total ++ "€ -> " ++ show (toFull total) ++ "€"
