module Data.SWF.Internal.Utilities (
    module Data.SWF.Internal.Utilities,
    
    module Control.Arrow,
    module Control.Monad,
    module Data.Maybe,
    module Data.List,
    module Debug.Trace,
    module Numeric
  ) where

import Control.Arrow (first, second, (&&&), (***))
import Control.Monad

import Data.Maybe
import Data.List

import Debug.Trace

import Numeric


orElse = flip fromMaybe

fst3 (a, _, _) = a
snd3 (_, b, _) = b
thd3 (_, _, c) = c

fst4 (a, _, _, _) = a
snd4 (_, b, _, _) = b
thd4 (_, _, c, _) = c
fth4 (_, _, _, d) = d

assertM True  _ = return ()
assertM False s = fail s

condM :: Monad m => m Bool -> m a -> m a -> m a
condM mcond mt mf = do
    cond <- mcond
    if cond then mt else mf


consistentWith :: Bool -> Bool -> Bool -> Bool
consistentWith _        True  True  = True
consistentWith _        False False = False
consistentWith inconsis _     _     = inconsis

inconsistent :: String -> String -> a
inconsistent selector why
  = error $ unlines ["Data.SWF: Inconsistent state when writing back!",
                     "Reason: " ++ why,
                     "Selector: " ++ selector]

maybeHasM :: Monad m => m Bool -> m b -> m (Maybe b)
maybeHasM ma mb = ma >>= \a -> maybeHas a mb

maybeHas :: Monad m => Bool -> m b -> m (Maybe b)
maybeHas flag act
  | flag      = liftM Just act
  | otherwise = return Nothing

genericReplicateM :: (Integral a, Monad m) => a -> m b -> m [b]
genericReplicateM n act = sequence $ genericReplicate n act

isLeft :: Either a b -> Bool
isLeft (Left _) = True
isLeft _        = False


padTo :: Int -> a -> [a] -> [a]
padTo n c xs = replicate (n - length xs) c ++ xs

showBinary :: Integral a => a -> ShowS
showBinary x = showIntAtBase 2 (\d -> toEnum (fromEnum '0' + d)) (fromIntegral x)


the :: Eq a => String -> String -> [a] -> Maybe a
the _        _   [] = Nothing
the selector why (x:xs) | all (x==) xs = Just x
                        | otherwise    = inconsistent selector why
