{-# LANGUAGE LambdaCase #-}
module Main where


import System.Process
import System.Exit
import Data.Foldable


nodes =
  [ ("localhost", "Computer internal networking",  "Your computer does not exist?")
  , ("192.168.0.1", "Router reachability", "Perhaps it is offline")
  , ("141.30.202.1", "Wundtstraße switch",
    "The house switch is not reachable, your buildings internet is offline")
  , ("141.30.228.39", "Primary Wundtstraße DNS","DNS server unreachable")
  , ("141.30.228.4", "Secondary Wundtstraße DNS", "DNS server unreachable")
  , ("wh2.tu-dresden.de", "WH2 DNS resolving", "DNS resolving is screwed")
  , ("141.30.235.81", "Weberplatz connection", "Our gate to the world is closed.")
  , ("8.8.8.8", "Google\"s DNS", "ALL THE INTERNET IS GONE FOREVER.")
  , ("google.com", "Google.com website", "Big internet DNS resolving does not work")
  ]


ping url =
  (<$> readCreateProcessWithExitCode "ping" [url]) $ \case
    (ExitSuccess, _, _) -> True
    _ -> False


main =
  for_ nodes $ \(url, type', message) -> do
    reachable <- ping url
