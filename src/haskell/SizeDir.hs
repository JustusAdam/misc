{-# LANGUAGE LambdaCase #-}
module SizeDir where


import System.Environment (getArgs)
import Text.Printf (printf)
import Control.Monad (unless, (>=>))
import System.Directory
import Data.Maybe (catMaybes)
import Control.Category ((>>>))
import System.Posix.Files
import Data.Traversable (for)
import Data.List (partition)
import Control.Arrow ((***))
import System.FilePath


getFileSize :: FilePath -> IO Integer
getFileSize = getFileStatus
    >=> fileSize
    >>> toInteger
    >>> return


sizedir :: FilePath -> IO (Maybe Integer)
sizedir dir = do
    exists <- doesDirectoryExist dir
    if exists
        then fmap Just (uncheckedSizedir dir)
        else return Nothing


uncheckedSizedir :: FilePath -> IO Integer
uncheckedSizedir dir = do
    nodes <- fmap (fmap (dir </>) . filter (`notElem` [".", ".."])) $ getDirectoryContents dir
    areFiles <- mapM doesFileExist nodes
    let (files, directories) = (map fst *** map fst) $ partition snd $ zip nodes areFiles
    filesizes <- fmap sum $ mapM getFileSize files
    dirsizes <- fmap sum $ mapM uncheckedSizedir directories
    ownSize <- getFileSize dir
    return $ filesizes + dirsizes + ownSize



tableCell = "%-40s | %-15v\n"
verticalSpacer = replicate 60 '-'

main = do
    args <- getArgs

    let dirs = if null args then ["."] else args

    printf tableCell "directory" "size"
    putStrLn verticalSpacer

    sizes <- for dirs $ \dir -> do
        msize <- sizedir dir

        case msize of
            Nothing -> do
                printf "Directory %s does not exist" (show dir)
            Just size ->
                printf tableCell dir size

        return msize

    unless (length sizes < 1) $ do
        putStrLn verticalSpacer
        printf tableCell "total" $ sum $ catMaybes sizes
