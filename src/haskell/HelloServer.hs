{-# LANGUAGE OverloadedStrings #-}


import Network.Wai.Handler.Warp
import Network.Wai
import Network.HTTP.Types
import Data.ByteString.Char8 as C


main = run 14900 $ \request respond -> do
    bod <- requestBody request
    C.putStrLn bod
    respond $ responseLBS ok200 [] "done"