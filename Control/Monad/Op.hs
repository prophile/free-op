{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE RankNTypes #-}

module Control.Monad.Op(Op, liftOp, runOp) where

import Control.Applicative
import Control.Monad
import Control.Monad.Free.Church

data Coyoneda f a where
  Coyoneda :: (b -> a) -> f b -> Coyoneda f a

liftCoyoneda :: f a -> Coyoneda f a
liftCoyoneda = Coyoneda id

instance Functor (Coyoneda f) where
  fmap f (Coyoneda g x) = Coyoneda (f . g) x

newtype Op c a = Op (F (Coyoneda c) a)
  deriving (Monad, Applicative, Functor)

liftOp :: c a -> Op c a
liftOp = Op . liftF . liftCoyoneda

runOp :: (Monad m) => (forall x. c x -> m x) -> Op c a -> m a
runOp n (Op x) = iterM f x
  where f (Coyoneda g y) = n y >>= g

