{-# LANGUAGE DeriveDataTypeable #-}
module Main where

import Lib
import System.Console.CmdArgs

data Command = Add {title :: String}
             | List
               deriving (Show, Data, Typeable)

add = Add{title = def &= argPos 0} &= auto
list = List

main :: IO ()
main = print =<< cmdArgs (modes [add, list])

exec :: Command -> String
exec = show
