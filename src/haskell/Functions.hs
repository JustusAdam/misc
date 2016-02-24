data A = A | B | C

functionA :: A -> String
functionB :: A -> Int

functionA A = "A"
functionA _ = ""
functionB A = 1


functionB _ = 0
