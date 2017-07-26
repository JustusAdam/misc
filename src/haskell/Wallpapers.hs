import Data.Conduit.Network
import Data.Conduit
import Data.Conduit.List
import System.FilePath
import Data.ByteString.Lazy as BS (ByteString, writeFile)
import Network.HTTP.Simple
import Control.Monad
import Control.Monad.IO.Class
import System.IO
import Data.Foldable
import System.Directory
import Text.HTML.DOM


baseDir = "wallpapers/canada2"

baseUrl = "https://www.desktopnexus.com/tag/canada/"

overviewPages :: Conduit Int IO Document
overviewPages = awaitForever $ \i -> do
    req <- parseRequest_ $ baseUrl ++ show i
    yield $ parseLBS $ getResponseBody req


linksFromPage :: Monad m => Conduit Document m String
linksFromPage =


files :: Source IO (String, FilePath)
files = go
  where
    go = do
        end <- liftIO isEOF
        if end
            then return ()
            else do
                l <- liftIO $ getLine
                case words l of
                    [url] -> yield (url, reverse $ takeWhile (/= '/') $ reverse item)
                    [url, name] -> yield (url, name)
                    [] -> return ()
                    _ -> putStrLn $ "Malformed line " ++ l
                go


getFile :: Conduit (String, FilePath) IO (ByteString, FilePath)
getFile = awaitForever $ \(url, name) -> do
    case parseRequest url of
        Nothing -> liftIO $ putStrLn $ "Malformed url " ++ url
        Just req -> do
            res <- httpLBS req
            yield (getResponseBody res, name)


writeFileC :: Sink (ByteString, FilePath) IO ()
writeFileC = awaitForever $ \(thing, name) -> liftIO $ BS.writeFile (baseDir </> name) thing


main = do
    createDirectoryIfMissing True baseDir
    runConduit $ files =$= getFile =$= writeFileC
