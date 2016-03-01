module DoubleLinkedList where


data DoubleList a = Cons (DoubleList a) a (DoubleList a) | Nil


showLeft Nil = "["
showLeft (Cons ll v _) = showLeft ll ++ show v ++ ", "


showRight Nil = "]"
showRight (Cons _ v lr) = ", " ++ show v ++ showRight lr


instance Show a => Show (DoubleList a) where
    show Nil = "[]"
    show (Cons ll v lr) = showLeft ll ++ show v ++ showRight lr


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
    | a < 0 = getAt (inc a) ll
    | otherwise = getAt (dec a) lr


main = do
    let myList = twoElem 2 9
    print $ myList
    print $ getValue myList
    print $ getValue $ next myList
    print $ getValue $ next $ next myList
    print $ getValue $ prev myList

    let larger = insertBefore 4 myList

    print larger
