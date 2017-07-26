import System.Environment
import System.Random
import Control.Monad.Random


allowedVals =
    lowerCaseLetters
    ++ upperCaseLetters
    ++ numbers
    ++ symbols


lowerCaseLetters = ['a'..'z']
upperCaseLetters = ['A'..'Z']
numbers = ['0'..'9']
symbols = "-_/[]{}()*&^%$#@."


mkPass length = do
    p <- sequence $ replicate length (uniform allowedVals)
    if and $ flip sequence p $ map (any . flip elem) [lowerCaseLetters,  upperCaseLetters, numbers, symbols]
        then return p
        else mkPass length


-- Usage: runhaskell GenPW.hs l1 l2 l3 ...
-- For each length (l1, l2, l3 and so on) generates a password of this length
-- Guarantees to have at least 1 lower case character, 1 upper case character,
-- one digit (0-9) and one symbol
main = do
    ls <- map read <$> getArgs

    pws <- evalRandIO $ mapM mkPass ls

    mapM putStrLn pws


