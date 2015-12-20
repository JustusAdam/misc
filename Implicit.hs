{-# LANGUAGE ImplicitParams #-}


func1 :: (?message :: String) => IO ()
func1 = putStrLn ?message

func2 :: (?message :: String) => IO ()
func2 = do
  putStrLn ?message
  let ?message = ?message ++ " changed"
  func1

main =
  func2
  where ?message = "This works"
