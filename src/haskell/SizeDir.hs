module SizeDir where


import System.Environment (getArgs)
import Text.Printf (printf)
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


uncheckedSizedir :: FilePath -> IO Integer
uncheckedSizedir path = do
    isFile <- doesFileExist path
    if isFile
        then getOwnSize
        else do
            ownSize <- getOwnSize
            files <- fmap (fmap (path </>) . filter (`notElem` [".", ".."])) $ getDirectoryContents path
            fmap ((+ ownSize) . sum) $ mapM uncheckedSizedir files
    where getOwnSize = getFileSize path


tableCell :: String
tableCell = "%-40s | %-15v\n"


verticalSpacer :: String
verticalSpacer = replicate 60 '-'


main :: IO ()
main = do
    args <- getArgs

    let dirs = if null args then ["."] else args

    printf tableCell "directory" "size"
    putStrLn verticalSpacer

    sizes <- for dirs $ \dir -> do
        msize <- sizedir dir

        case msize of
            Nothing ->
                printf "Directory %s does not exist" (show dir)
            Just size ->
                printf tableCell dir size

        return msize

    unless (length sizes < 2) $ do
        putStrLn verticalSpacer
        printf tableCell "total" $ sum $ catMaybes sizes
