import Debug.Trace

qsort [] = []
qsort (a:as) = qsort left ++ [a] ++ qsort right ++ head []
  where (left,right) = trace "executing filter" $ (filter (<=a) as, filter (>a) as)

v = (qsort [8, 4, 0, 3, 1, 23, 11, 18])
