main = do
  bool <$> fetch1 <*> fetch2 <*> pure True


ifm :: Monad m => m Bool -> m a -> m a -> m a
ifm cond a b =
  cond >>= \cond' -> if cond' then a else b


ifm2 :: Monad m => m Bool -> m a -> m a -> m a
ifm2 cond a b = do
  cond' <- cond
  if cond' then a else b

ifa :: Applicative f => f Bool -> f a -> f a -> f a
ifa cond a b = (\cond' -> if cond' then a else b) <$> cond

main2 = do
  data1 <- fetch1
  data2 <- fetch2

  if True
    then data2
    else data1

main3 =
  if True then fetch2 else fetch1


bool False a _ = a
bool True _ b = b

(if cond
  (fetch1)
  (fetch2))
