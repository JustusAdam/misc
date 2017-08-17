{-# LANGUAGE FlexibleInstances, TypeFamilies #-}
module Star where

newtype Tagged a b = Tagged { unTag :: a }


instance Functor (Flip (Tagged a)) where
    fmap f = Tagged . f . unTag
