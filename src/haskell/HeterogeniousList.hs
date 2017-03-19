{-# LANGUAGE GADTs #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ExplicitForAll, ScopedTypeVariables #-}
{-# LANGUAGE ConstraintKinds #-}
{-# OPTIONS_GHC -fprint-potential-instances #-}

import Data.Proxy
import Test.Hspec
import Prelude hiding (tail, head)

data List a where
    Nil :: List '[]
    Cons :: elem -> List rest -> List (elem:rest)

infixr 4 `Cons`

instance Eq (List '[]) where
    _ == _ = True

instance (Eq a, Eq (List rest)) => Eq (List (a:rest)) where
    Cons e1 r1 == Cons e2 r2 = 
        e1 == e2 || r1 == r2

class ShowNonEmpty a where
    showNonEmpty :: a -> String

instance Show (List '[]) where
    show _ = "[]"

instance (ShowNonEmpty (List a), Show e) => Show (List (e:a)) where
    show (Cons e rest) = "[" ++ show e ++ showNonEmpty rest

instance ShowNonEmpty (List '[]) where
    showNonEmpty _ = "]"

instance (Show a, ShowNonEmpty (List rest)) => ShowNonEmpty (List (a:rest)) where
    showNonEmpty (Cons e rest) = "," ++ show e ++ showNonEmpty rest

cons :: elem -> List rest -> List (elem:rest)
cons = Cons

head :: List (a:rest) -> a
head (Cons e _) = e

tail :: List (a:rest) -> List rest
tail (Cons _ r) = r

data Nat = Zero | Succ Nat

type family TypeNeq a b :: Bool where
  TypeNeq a a = False
  TypeNeq a b = True

class Indexable a b (c :: Nat) where
    index :: a -> Proxy c -> Maybe b

instance Indexable (List '[]) b c where
    index _ _ = Nothing

instance Indexable (List (a:rest)) a Zero where
    index (Cons e _) _ = Just e

instance TypeNeq a b ~ True => Indexable (List (a:rest)) b Zero where
    index (Cons e _) _ = Nothing

instance forall c rest a b. Indexable (List rest) b c => Indexable (List (a:rest)) b (Succ c) where
    index (Cons _ rest) _ = index rest (Proxy :: Proxy c)

class TypeIndexable a b where
    retrieve :: a -> Maybe b

instance TypeIndexable (List '[]) a where
    retrieve = const Nothing

instance TypeIndexable (List (a:rest)) a where
    retrieve (Cons e _) = Just e

instance {-# OVERLAPPABLE #-} TypeIndexable (List rest) b => TypeIndexable (List (a:rest)) b where
    retrieve (Cons _ rest) = retrieve rest

-- On the command line

-- λ> let a = 'c' `Cons` (9 :: Int) `Cons` () `Cons` Nil
-- λ> :t a
-- a :: List '[Char, Int, ()]
-- λ> a
-- ['c',9,()]
-- λ>


main = hspec $
    describe "a heterogenious list" $ do
        let a = 'c' `Cons` (9 :: Int) `Cons` (10 :: Int) `Cons` () `Cons` True `Cons` Nil
        it "converts to string" $
            show a `shouldBe` "['c',9,10,(),True]"
        it "supports dequing" $
            head a `shouldBe` 'c'
        it "supports getting the tail" $
            tail a `shouldBe` ((9 :: Int) `Cons` (10 :: Int) `Cons` () `Cons` True `Cons` Nil)
        it "is indexable by type" $
            retrieve a `shouldBe` (Just 9 ::  Maybe Int)
        it "is indexable by typed index" $
            index a (Proxy :: Proxy (Succ (Succ Zero))) `shouldBe` (Just 10 :: Maybe Int)
        
        