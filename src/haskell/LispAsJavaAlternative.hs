{-# LANGUAGE TupleSections, NoImplicitPrelude, TypeFamilies #-}


-- http://www.flownet.com/ron/papers/lisp-java/instructions.html

import ClassyPrelude
import qualified Data.IntMap as IntMap
import qualified Data.Map as Map
import Text.Read (read)


newtype PrefixMap = MkPrefixMap { unPrefixMap :: IntMap PrefixMapVal } deriving Show
data PrefixMapVal = MkPrefixMapVal { completedWords :: [String], innerMap :: PrefixMap } deriving Show



mergePrefixMapVal :: PrefixMapVal -> PrefixMapVal -> PrefixMapVal
mergePrefixMapVal (MkPrefixMapVal w1 m1) (MkPrefixMapVal w2 m2) = MkPrefixMapVal (w1 ++ w2) (MkPrefixMap $ unionWith mergePrefixMapVal (unPrefixMap m1) (unPrefixMap m2))


buildPrefixMap :: String -> [String] -> PrefixMap
buildPrefixMap prefix = MkPrefixMap . foldl' (unionWith mergePrefixMapVal) IntMap.empty . map go . map ((fst . headEx) &&& map snd) . groupAllOn fst . catMaybes . map uncons
  where
    go (h, all) = mapFromList $ map (, computed) (encode h)
      where
        (nulls, innerWords) = partition null (all :: [String])
        computed = MkPrefixMapVal
            (if null nulls then [] else [reverse (h:prefix)])
            (buildPrefixMap (h:prefix) innerWords)


-- E | J N Q | R W X | D S Y | F T | A M | C I V | B K U | L O P | G H Z
-- e | j n q | r w x | d s y | f t | a m | c i v | b k u | l o p | g h z
-- 0 |   1   |   2   |   3   |  4  |  5  |   6   |   7   |   8   |   9
encode :: Char -> [Int]
encode = fromMaybe [] . flip lookup (Map.fromListWith (++) asl)
  where
    mapping = ["jnq", "rwx", "dsy", "ft", "am", "civ", "bku", "lop", "ghz"]
    asl = [ (v, [index])
          | (index, vs) <- zip [1..] mapping
          , v <- toLower vs ++ toUpper vs
          ]


findMatching :: PrefixMap -> [Int] -> [String]
findMatching pmap = go True pmap
    where
        go _ _ [] = []
        -- go canEncodeNum mapState (x:[]) = (if canEncodeNum then (show x:) else id) $ fromMaybe [] $ completedWords <$> lookup x (unPrefixMap mapState)
        go canEncodeNum mapState (x:xs) =
          case lookup x $ unPrefixMap mapState of
              Nothing ->
                if canEncodeNum
                  then case xs of
                          [] -> show x
                          t -> map (show x ++) $ go False pmap t
                  else []
              Just (MkPrefixMapVal w innerMap) ->
                  [ prefix ++ " " ++ (if encodeNum then show x ++ " " else "") ++ suffix
                  | prefix <- w
                  , suffix <- chosenSuffix
                  ]
                  ++ go True innerMap xs
                where suffixCandidate = go True pmap xs
                      encodeNum = canEncodeNum && null suffixCandidate
                      chosenSuffix = if encodeNum then go False pmap (tailEx xs) else suffixCandidate


main :: IO ()
main = do
    [dictfile, numberphile] <- getArgs
    dict <- readFile (unpack dictfile)
    numbers <- readFile (unpack numberphile)
    let pmap = buildPrefixMap [] (words dict)
    for_ (words numbers) $ \num ->
        mapM_ (putStrLn . pack . (\res -> (num :: String) ++ ":  " ++ res)) (findMatching pmap $ traceShowId $ map (read . singleton) $ filter (`elem` "0123456789") num)
