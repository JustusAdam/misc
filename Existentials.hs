{-# LANGUAGE ExplicitForAll, NamedFieldPuns, ExistentialQuantification, StandaloneDeriving #-}

class MyClass a where
  inc :: a -> a


instance MyClass Int where
  inc = (+ 1)

data MyRec = MyRec {a :: Int, b :: String} deriving Show

instance MyClass MyRec where
  inc MyRec{a, b} = MyRec (inc a) b


data Wrapper = forall a. (MyClass a, Show a) => Wrapper a

deriving instance Show Wrapper

mapInc :: [Wrapper] -> [Wrapper]
mapInc = map (\(Wrapper a) -> Wrapper (inc a))


main = do
  let l = mapInc $ map Wrapper [1::Int, 2, 3]
  let l2 = [Wrapper $ MyRec 1 "", Wrapper (2 :: Int)]
  print l
  print l2
