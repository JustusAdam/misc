{-# LANGUAGE RoleAnnotations, TypeFamilies #-}

data D1 a = D1 a
data D2 b = D2 b

type role D1 representational

type role D2 nominal

type family F a where
    F String = Int