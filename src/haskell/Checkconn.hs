{-# LANGUAGE LambdaCase #-}
module Main where


import System.Process
import System.Exit
import Data.Traversable
import Data.Foldable
import Control.Lens
import Control.Concurrent.Async
import Text.Printf


nodes =
    [ ("localhost", "Computer internal networking",  "Your computer does not exist.")
    , ("192.168.0.1", "Router reachability", "The router may be offline.")
    , ("141.30.202.1", "Wundtstraße switch",
    "Your buildings internet may be offline.")
    , ("141.30.228.39", "Primary Wundtstraße DNS","DNS server down.")
    , ("141.30.228.4", "Secondary Wundtstraße DNS", "Second DNS server down.")
    , ("wh2.tu-dresden.de", "WH2 DNS resolving", "DNS resolving is down.")
    , ("141.30.235.81", "Weberplatz connection", "The Research network is down.")
    , ("8.8.8.8", "Google\"s DNS", "ALL THE INTERNET IS GONE FOREVER.")
    , ("google.com", "Google.com website", "Big internet DNS resolving does not work")
    ]


ping url = do
    resp <- readCreateProcessWithExitCode (proc "ping" ["-c", "3", url]) ""
    case resp of
        (ExitSuccess, _, _) -> return True
        _ -> return False


tableFormat = "%-20s | %-35s | %-s\n"


main = do
    connections <- mapM (async . ping . (^. _1)) nodes

    printf tableFormat "node" "purpose" "status"

    putStrLn $ replicate 80 '-'

    results <- for (zip connections nodes) $ \(conn, (target, type', message)) -> do
        reached <- wait conn
        printf tableFormat target type' $ if reached then "✅" else "❌"
        return (reached, target, message)

    putStrLn "\n\n"

    case find (not . (^. _1)) results of
        Nothing -> putStrLn "All checks positive! No problems found"
        Just (_, target, message) ->
            printf "Failed when trying to reach %s, likely problem: %s" target message
