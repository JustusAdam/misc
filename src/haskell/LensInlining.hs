module LensInlining where
    
import Control.Lens
import System.Environment

data D = D Int deriving Show

accessor :: Lens' D Int
accessor = lens (\(D i) -> i) (\_ a -> D a)

f :: D -> D -> D
f d1 d2 = d1 & accessor .~ (d1 ^. accessor) + (d2^. accessor)
