{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}


module Text.MonadicPrinter where


import Data.Monoid
import Data.String
import Unsafe.Coerce
import Data.Text


data Printer a = Printer { getContent :: [Text] }


instance Functor Printer where
  fmap _ = unsafeCoerce


instance Applicative Printer where
  pure = const $ Printer []
  f <*> v = f >> fmap unsafeCoerce v
  (Printer c1) *> (Printer c2) = Printer (c1 <> c2)
  (Printer c1) <* (Printer c2) = Printer (c2 <> c1)


instance Monad Printer where
  (>>) = (*>)

  h >>= f = h >> f (error "Cannot use monadig bind here")

  return = pure


instance IsString (Printer a) where
  fromString s = Printer [s]


print_ :: Printer () -> IO ()
print_ (Printer s) =
  mapM_ putStrLn s


main = print_ $ do
  "hello"
  "a new line"
  "some more text"
