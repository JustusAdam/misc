{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ExplicitForAll, ScopedTypeVariables #-}


import Data.Proxy
import Data.Proxy.TH
import Test.Hspec

data Attr1
data Attr2
data Attr3



class Compute a where
    compute :: a -> Int

instance Compute (Proxy '[]) where
    compute = const 1

instance {-# OVERLAPPABLE #-} forall rest a. Compute (Proxy rest) => Compute (Proxy (a:rest)) where
    compute _ = compute (Proxy :: Proxy rest)

instance Compute (Proxy (Attr1 :a)) where
    compute = const 2


main = hspec $ 
    describe "simple resolution" $ do
        it "recognizes no attrs" $ 
            compute (Proxy :: Proxy '[]) `shouldBe` 1
        it "recognizes one attr" $ 
            compute (Proxy :: Proxy '[Attr1]) `shouldBe` 2
        it "recognizes one attr among others" $
            compute (Proxy :: Proxy [Attr2,Attr1]) `shouldBe` 2
        it "recognizes one attr among others" $
            compute (Proxy :: Proxy [Attr2,Attr3,Attr1]) `shouldBe` 2
        it "recognizes if no attrs match" $
            compute (Proxy :: Proxy [Attr2, Attr3]) `shouldBe` 1

