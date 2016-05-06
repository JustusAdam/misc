{-# LANGUAGE TemplateHaskell #-}


import Control.Lens
import Data.Function

data Record' = Record { _fieldA :: String, _fieldB :: Record2' } deriving Show

data Record2' = Record2 { _fieldC :: String, _fieldD :: Int } deriving Show

makeLenses ''Record'
makeLenses ''Record2'



main = do
    print $ r1 & fieldA .~ "Good bye" & fieldB . fieldD .~ 5

  where
    r1 = Record "Hello" $ Record2 "Dude" 4
