import qualified Primitives
import qualified VanillaRect
import qualified DefineShapeAlignment
import qualified Roundtripping
import qualified SpecificationExample

import Data.SWF.Internal.Utilities

import Data.Char
import Data.List


-- The actual tests:
main :: IO ()
main = do
    Primitives.main
    VanillaRect.main
    DefineShapeAlignment.main
    Roundtripping.main
    SpecificationExample.main


-- Useful for constructing new tests:
showHexList :: Integral a => [a] -> String
showHexList xs = "[" ++ intercalate ", " ["0x" ++ padTo 2 '0' (map toUpper $ showHex x "") | x <- xs] ++ "]"

showListBinary :: Integral a => [a] -> String
showListBinary xs = intercalate " " [padTo 8 '0' (showBinary x "") | x <- xs]

pretty :: String -> String
pretty = unlines . go 0 ""
  where
    go lvl line (',':rest) = finish lvl (',' : line) : go lvl "" rest
    go lvl line ('{':'}':rest) = go lvl ('}' : '{' : line) rest
    go lvl line ('[':']':rest) = go lvl (']' : '[' : line) rest
    go lvl line (o:rest) | o `elem` "{[" = finish lvl (o : line) : go (lvl + 2) "" rest
    go lvl line (c:rest) | c `elem` "}]" = finish lvl line : go (lvl - 2) [c] rest
    go lvl line (x:rest) = go lvl (x : line) rest
    go lvl line [] = [finish lvl line]
    
    finish lvl line = replicate (lvl * 2) ' ' ++ dropWhile isSpace (reverse (dropWhile isSpace line))
