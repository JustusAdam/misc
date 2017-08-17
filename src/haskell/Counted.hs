{-# LANGUAGE ExplicitForAll, Rank2Types #-}
module Counted where

import Control.Applicative
data Counted a = Counted Int a

type Lens s t a b = forall f. Functor f => (a -> f b) -> s -> f t
type Lens' s a = Lens s s a a

counted :: Lens s t a b -> Lens (Counted s) (Counted t) a b
counted l f (Counted i a) = Counted (i+1) <$> l f a

get :: Lens s t a b -> s -> a
get l = getConst . l Const

getCount :: Counted a -> Int
getCount = get count

count :: Lens' (Counted a) Int
count f (Counted i a) = flip Counted a <$> f i
