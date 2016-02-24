if_ :: Bool -> a -> a -> a
if_ True a _ = a
if_ _ _ b = b


then_ = ($)


else_ = ($)


main =
  print $ (if_ True `then_` 1 `else_` 4 :: Int)
