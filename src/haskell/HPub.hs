
{-# LANGUAGE OverloadedStrings #-}

import ClassyPrelude
import System.Directory
import Distribution.PackageDescription.Parse
import Distribution.Verbosity
import Distribution.Package
import Distribution.PackageDescription
import System.Process
import Data.Version
import System.IO (hFlush)
import Data.Aeson
import Data.Aeson.Types
import qualified Data.ByteString.Lazy as BS
import System.Exit
import qualified Data.Text as T
import qualified Data.Text.IO as T
import qualified Prelude as P


getHaskellVersion :: IO Version
getHaskellVersion = do
    candidates <- filter (".cabal" `isSuffixOf`) <$> getDirectoryContents "."
    case candidates of
        [f] ->
            pkgVersion . package . packageDescription <$> readPackageDescription silent f
        [] -> error "No cabal file found"
        _ -> error "More than one .cabal file"


getNodeVersion :: IO Version
getNodeVersion = do
    c <- BS.readFile "package.json"
    return $ either (error . ("Invalid JSON: " ++)) id $ eitherDecode c >>= parseEither (withObject "package must be object" (.: "version"))


knownActions = 
    [ ("hackage", (getHaskellVersion, callProcess "stack" ["upload", "."]))
    , ("vscode", (getNodeVersion, callProcess "vsce" ["publish"]))
    ]


main = do
    args <- getArgs

    case args of
        [a] -> case lookup a knownActions of
                    Just (getVersion, runAction) -> do
                        (code, out, err) <- readProcessWithExitCode "git" ["status", "--porcelain"] ""
                        
                        case code of 
                            ExitSuccess -> return ()
                            f@(ExitFailure _) -> do
                                putStrLn "Git process errored"
                                P.putStrLn err
                                exitWith f
                        
                        case out of 
                            "" -> return ()
                            content -> do
                                putStrLn "You seem to have uncomitted changes"
                                putStrLn ""
                                P.putStrLn content
                                putStrLn "Would you like to Create a commit, continue Without a commit or Abort the upload? [cwA]"
                                l <- T.getLine
                                case T.toLower $ T.strip l of
                                    "" -> abort
                                    "a" -> abort
                                    "w" -> return ()
                                    "c" -> do
                                        putStrLn "Enter a (one line) commit message"
                                        s <- getLine
                                        callProcess "git" ["commit", "-am", s]
                                    _ -> putStrLn "unrecognized command" >> abort
                                  where abort = exitWith $ ExitFailure 1
                        v <- getVersion
                        putStr "Creating tag..."
                        hFlush stdout
                        callProcess "git" ["tag", "-m", "Release version " ++ showVersion v , 'v':showVersion v]
                        callProcess "git" ["push", "--tags"]
                        putStrLn "done"
                        putStr "Uploading package..."
                        hFlush stdout
                        runAction
                        putStrLn "done"
                    Nothing -> printHelp
        _ -> printHelp
      where printHelp = putStrLn "Known actions: " >> print (map fst knownActions)
