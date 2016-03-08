module DoubleLinkedList where


data DoubleList a = Cons (DoubleList a) a (DoubleList a) | Nil


showLeft Nil = "["
showLeft (Cons ll v _) = showLeft ll ++ show v ++ ", "


showRight Nil = "]"
showRight (Cons _ v lr) = ", " ++ show v ++ showRight lr


instance Show a => Show (DoubleList a) where
    show Nil = "[]"
    show (Cons ll v lr) = showLeft ll ++ show v ++ showRight lr


instance Functor DoubleList where
    fmap _ Nil = Nil
    fmap f (Cons ll v lr) = self
        where self = Cons (mapLeft f ll self) (f v) (mapRight f lr self)


instance Applicative DoubleList where
    pure = return
    f <*> v = do
        f' <- f
        v' <- v
        return $ f' v'



instance Monad DoubleList where
    return a = Cons Nil a Nil
    Nil >>= f = Nil
    a@(Cons ll v lr) >>= f = self
        where
            left = bindLeft ll f self
            right = bindRight lr f self
            created = f v
            self = left `concatD` created `concatD` right


concatD Nil a = a
concatD a Nil = a
concatD a b = a'
    where
        a' = linkLeft b' a
        b' = linkRight a' b


bindLeft Nil _ _ = Nil
bindLeft (Cons ll v _) f ref = self
    where
        created = f v
        left = bindLeft ll f self
        self = linkLeft left $ linkRight ref created


bindRight Nil _ _ = Nil
bindRight (Cons _ v lr) f ref = self
    where
        created = f v
        right = bindRight lr f self
        self = linkRight right $ linkLeft ref created


mapLeft _ Nil _ = Nil
mapLeft f (Cons ll v _) ref = self
    where self = Cons (mapLeft f ll self) (f v) ref


mapRight _ Nil _ = Nil
mapRight f (Cons _ v lr) ref = self
    where self = Cons ref (f v) (mapRight f lr self)


fromList = rec Nil
    where
        rec _ [] = Nil
        rec ref (x:xs) = self
            where self = Cons ref x (rec self xs)



singleton a = Cons Nil a Nil


twoElem a b = a'
    where
        a' = Cons Nil a b'
        b' = Cons a' b Nil


insertBefore e Nil = Cons Nil e Nil
insertBefore e ol@(Cons l1 _ _) = self
    where
        self = Cons (linkLeft self l1) e (linkRight self ol)

insertAfter e Nil = Cons Nil e Nil
insertAfter e ol@(Cons _ _ l1) = self
    where
        self = Cons (linkLeft self ol) e (linkRight self l1)


linkLeft prep Nil = Nil
linkLeft prep (Cons l1 v _) = self
    where self = Cons (linkLeft l1 self) v prep


linkRight prep Nil = Nil
linkRight prep (Cons _ v l1) = self
    where self = Cons prep v (linkRight self l1)


next Nil = Nil
next (Cons _ _ l) = l


prev Nil = Nil
prev (Cons r _ _) = r


getValue Nil = Nothing
getValue (Cons _ v _) = Just v


getAt _ Nil = Nothing
getAt 0 (Cons _ v _) = Just v
getAt a (Cons ll _ lr)
    | a < 0 = getAt (succ a) ll
    | otherwise = getAt (pred a) lr


main = do
    let myList = twoElem 2 9
    print $ myList
    print $ getValue myList
    print $ getValue $ next myList
    print $ getValue $ next $ next myList
    print $ getValue $ prev myList

    let larger = insertBefore 4 myList

    print larger

    print $ fmap succ larger

    print $ fmap (+ 10) $ fromList [0,0,0]

    print $ myList `concatD` larger

    print $ do
        one <- myList
        two <- larger
        return $ one * two
