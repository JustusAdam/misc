{-# LANGUAGE OverloadedStrings #-}
module Email (Email) where


import Data.String
import Data.Maybe

e :: Email
e = "m3" 

newtype Email = Email { fromEmail :: String }


toEmail :: String -> Maybe Email
toEmail e
  | '@' `elem` e = return $ Email e
  | otherwise = Nothing


instance IsString Email where
  fromString = fromJust . toEmail

instance Show Email where
  show = fromEmail
