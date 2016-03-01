module SizeDir where


import System.Environment (getArgs)
import Text.Printf (printf, PrintfArg)
import Control.Monad (unless)
import System.Directory
import Data.Maybe (catMaybes)
import System.Posix.Files
import Data.Traversable (for)
import System.FilePath


getFileSize :: FilePath -> IO Integer
getFileSize = fmap (toInteger . fileSize) . getFileStatus


sizedir :: FilePath -> IO (Maybe Integer)
sizedir dir = do
    exists <- doesDirectoryExist dir
    if exists
        then fmap Just (uncheckedSizedir dir)
        else return Nothing


listDirectoryContents :: FilePath -> IO [FilePath]
listDirectoryContents path = filter ((&&) <$> (/= ".") <*> (/= "..")) <$> getDirectoryContents path


uncheckedSizedir :: FilePath -> IO Integer
uncheckedSizedir path = do
    isFile <- doesFileExist path
    if isFile
        then getOwnSize
        else do
            files <- map (path </>) <$> listDirectoryContents path
            ((+) . sum) <$> mapM uncheckedSizedir files <*> getOwnSize
    where getOwnSize = getFileSize path


tableCell :: String
tableCell = "| %-40s | %-15v |\n"


verticalSpacer :: String
verticalSpacer = "|" ++ replicate 42 '-' ++ "|" ++ replicate 17 '-' ++ "|"


putCell :: PrintfArg a => String -> a -> IO ()
putCell s = printf tableCell (take 40 s)


putSpacer = putStrLn verticalSpacer


main :: IO ()
main = do
    args <- getArgs

    let dirs = if null args then ["."] else args

    putSpacer
    putCell "directory" "size"
    putSpacer

    sizes <- for dirs $ \dir -> do
        msize <- sizedir dir

        maybe
            (printf "Directory %s does not exist" (show dir))
            (putCell dir)
            msize

        return msize

    unless (length sizes < 2) $ do
        putSpacer
        putCell "total" $ sum $ catMaybes sizes

    putSpacer
