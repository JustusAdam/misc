{-# LANGUAGE OverloadedLists #-}
{-# LANGUAGE ExplicitForAll, ScopedTypeVariables #-}
{-# LANGUAGE NoImplicitPrelude #-}
module FCA where


import ClassyPrelude
import Data.Map.Strict (Map, fromListWith, (!))
import Data.Set (Set)
import qualified Data.Set as S

concatIntersect :: Ord a => [Set a] -> Set a
concatIntersect [] = mempty
concatIntersect [x] = x
concatIntersect (x:xs) = x `intersection` concatIntersect xs

allConcepts :: forall a b. (Ord a, Ord b) => Map a (Set b) -> [(Set a, Set b)]
allConcepts context = map (id &&& concatIntersect . map (context !) . setToList) $ setToList allExtents 
  where
    allExtents :: Set (Set a)
    allExtents = foldr f g (concatMap snd ctxL)
    ctxL = mapToList context
    attrContext :: Map b (Set a)
    attrContext = fromListWith (++) [(attr, S.singleton obj) | (obj, intent) <- ctxL, attr <- setToList intent]
    g = S.singleton $ setFromList $ map fst $ mapToList context
    f :: b -> Set (Set a) -> Set (Set a)
    f attr earlier = 
        earlier ++ S.map (intersection $ attrContext ! attr) earlier

data Attributes = Older | Middle | Younger | Male | Female | Rich | Carefree | Indebted deriving (Ord, Eq, Show)
data Objects = Tick | Trick | Track | Donald | Daisy | Gustav | Dagobert | Annette | Primus deriving (Ord, Eq, Show)

c :: Map Objects (Set Attributes)
c = 
    [ (Tick, [Younger, Male, Carefree])
    , (Trick, [Younger, Male, Carefree])
    , (Track, [Younger, Male, Carefree])
    , (Donald, [Middle, Male, Indebted])
    , (Daisy, [Middle, Female, Carefree])
    , (Gustav, [Middle, Male, Carefree])
    , (Dagobert, [Older, Male, Rich])
    , (Annette, [Older, Female, Carefree])
    , (Primus, [Older, Male, Carefree])
    ]
