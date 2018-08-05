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
main = cmdArgs (modes [add, list]) >>= \action -> print (exec action)

exec :: Command -> String
exec List = "List not implemented"
exec Add {title = title} = "Add not implemented: " ++ title
