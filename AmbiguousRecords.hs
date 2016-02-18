{-# LANGUAGE DisambiguateRecordFields #-}

import TestRecord

data Q = Q { a :: String }


main =  do
  let x = Q ""
      y = TestRecord 4

  let (Q { a = a1 }) = x
  let (TestRecord { a = a2 }) = y

  print a1
  print a2
