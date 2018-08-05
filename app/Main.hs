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
main = cmdArgs (modes [add, list]) >>= exec

exec :: Command -> IO() 
exec List                = readFile ".htodo" >>= putStrLn 
exec Add {title = title} = appendFile ".htodo" (title ++ "\n")
