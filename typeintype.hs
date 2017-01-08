

class A a where
    type B a
    type C a

instance A () where
    type B () = Int
    type C () = String

data D a = D (B a) (C a)
