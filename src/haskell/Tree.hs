module Tree where



data BinaryTree a = BiNode (BinaryTree a) (BinaryTree a) | BiLeaf a deriving (Eq, Ord, Show)


instance Functor BinaryTree where
  fmap f (BiNode t1 t2) = BiNode (fmap f t1) (fmap f t2)
  fmap f (BiLeaf a) = BiLeaf $ f a


instance Applicative BinaryTree where
  pure = BiLeaf
  (BiNode t1 t2) <*> v = BiNode (t1 <*> v) (t2 <*> v)
  (BiLeaf f) <*> v = fmap f v


instance Monad BinaryTree where
  (BiNode t1 t2) >>= f = BiNode (t1 >>= f) (t2 >>= f)
  (BiLeaf a) >>= f = f a


data RoseTree a = Stem [RoseTree a] | Petal a deriving (Eq, Ord, Show)


instance Functor RoseTree where
  fmap f (Stem l) = Stem $ fmap (fmap f) l
  fmap f (Petal a) = Petal $ f a


instance Applicative RoseTree where
  pure = Petal
  (Stem l) <*> v = Stem $ fmap (<*> v) l
  (Petal f) <*> v = fmap f v


instance Monad RoseTree where
  (Stem l) >>= f = Stem $ fmap (>>= f) l
  (Petal v) >>= f = f v
