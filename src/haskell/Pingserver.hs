module Pingserver where

import System.Environment
import Safe
import Network.Wreq
import Text.Printf
import Control.Concurrent
import Data.List
import Control.Lens
import qualified Data.ByteString.Lazy.Char8 as BS
import Network.HTTP.Types (ok200)
import Control.Exception


ping url timeout = loop 0
    where
        loop :: Int -> IO ()
        loop seq = do
            eitherResp <- try (get url)
            case eitherResp of
                Right resp | resp ^. responseStatus == ok200 -> do
                    putStrLn "Recieved response"
                    BS.putStrLn $ resp ^. responseBody
                Right resp ->
                    let status = resp ^. responseStatus in
                    printf "Recieved response, but unexpected staus %u : %s" (status ^. statusCode) (show $ status ^. statusMessage)
                Left err -> do
                    printf "Request failed for seq %u with error \"%s\"" seq (show (err :: SomeException))
                    threadDelay (timeout * 1000000)
                    loop $ succ seq


main :: IO ()
main = do
    args <- getArgs

    let (url, timeout) = case args of
                            [url] -> (url, 30)
                            [url, timeout] -> (url, read timeout)
                            [] -> error "Wrong number of command line arguments."

    let url_ = if "://" `isInfixOf` url then url else "http://" ++ url

    ping url_ timeout
