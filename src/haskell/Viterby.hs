module Viterby where


import Data.Set
import Data.Map as Map
import Data.Maybe
import Safe
import Data.Function (on)
import Control.Arrow
import Debug.Trace
import Data.Foldable


(~>) = (,)


(>$<) = flip fmap


viterby :: (Ord b, Ord a) => [a] -> Set b -> Map b Float -> Map b (Map b Float) -> Map b (Map a Float) -> [[(Float, [b])]]
viterby obs states startProbs transProbs emitProbs =
    Prelude.scanl f initial (fromMaybe [] $ tailMay obs)
    where
        stateList = Data.Set.toList states
        initial = catMaybes $ stateList >$< \state -> do
            o1 <- headMay obs
            prob <- Map.lookup state startProbs
            emitPr <- Map.lookup state emitProbs >>= Map.lookup o1
            return $ (prob * emitPr, [state])
        f prevProbs observed =
            catMaybes $ stateList >$< \state -> do
                currEmitProb <- Map.lookup state emitProbs >>= Map.lookup observed

                maximumByMay (compare `on` fst) $ catMaybes $ prevProbs >$< \(prob, pointers) -> do
                    prevState <- headMay pointers
                    currTransProb <- Map.lookup prevState transProbs >>= Map.lookup state
                    return (prob * currEmitProb * currTransProb, state:pointers)


data State = Healthy | Fever deriving (Ord, Eq, Show)
data Observations = Normal | Cold | Dizzy deriving (Ord, Eq, Show)

data States2 = Start | End | Person | Stadt | Other deriving (Ord, Eq, Show)

main = do
    let
        states = Data.Set.fromList [Healthy, Fever]
        observations = [Normal, Cold, Dizzy]
        startProbability = Map.fromList [Healthy ~> 0.6, Fever ~> 0.4]
        transitionProbability = Map.fromList $ fmap (second Map.fromList)
            [ Healthy ~> [Healthy ~> 0.7, Fever ~> 0.3]
            , Fever ~> [Healthy ~> 0.4, Fever ~> 0.6]
            ]
        emissionProbability = Map.fromList $ fmap (second Map.fromList)
            [ Healthy ~> [Normal ~> 0.5, Cold ~> 0.4, Dizzy ~> 0.1]
            , Fever ~> [Normal ~> 0.1, Cold ~> 0.3, Dizzy ~> 0.6]
            ]
        result = viterby
                    observations
                    states
                    startProbability
                    transitionProbability
                    emissionProbability
    putStrLn "Calculation nr 1"
    putStrLn "================\n"
    mapM print $ zip observations result

    maybe (return ()) print $ lastMay result >>= maximumByMay (compare `on` fst)

    let
        states = Data.Set.fromList [Start, End, Person, Stadt, Other]
        observations = ["$", "Paris", "lives", "in", "Denver", "EE"]
        startProbability = Map.fromList [Start ~> 1]
        transitionProbability = Map.fromList $ fmap (second Map.fromList)
            [ Person ~> [Other ~> 0.5, Person ~> 0.3, End ~> 0.2]
            , Other ~> [Other ~> 0.5, Stadt ~> 0.4, Person ~> 0.1]
            , Stadt ~> [Other ~> 0.4, Start ~> 0.6]
            , Start ~> [Person ~> 0.4, Stadt ~> 0.6]
            ]
        emissionProbability = Map.fromList $ fmap (second Map.fromList)
            [ Person ~> ["John" ~> 0.5, "Denver" ~> 0.25, "Paris" ~> 0.25]
            , Start ~> ["$" ~> 1]
            , End ~> ["EE" ~> 1]
            , Stadt ~> ["Washington" ~> 0.4, "Denver" ~> 0.3, "Paris" ~> 0.2, "Dresden" ~> 0.1]
            , Other ~> ["went" ~> 0.3, "to" ~> 0.3, "lives" ~> 0.2, "in" ~> 0.2]
            ]
        result = viterby
                    observations
                    states
                    startProbability
                    transitionProbability
                    emissionProbability

    putStrLn "\n\n\n"
    putStrLn "Calculation nr 2"
    putStrLn "================\n"

    mapM print $ zip observations result
    maybe (return ()) print $ lastMay result >>= maximumByMay (compare `on` fst)
