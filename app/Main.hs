{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Main where

import Lib
import System.Console.CmdArgs
import Data.Yaml
import GHC.Generics
import System.Directory

data Command = Add { title :: String }
             | List
               deriving (Show, Data, Typeable)

data Task = Task { name :: String } deriving (Show, Generic)
instance ToJSON Task
instance FromJSON Task

add = Add{title = def &= argPos 0} &= auto
list = List

main :: IO ()
main = cmdArgs (modes [add, list]) >>= exec

fileName :: FilePath
fileName = ".htodo"

exec :: Command -> IO() 
exec List                = readTasks >>= putStrLn . show
exec Add {title = title} = readTasks >>= \ts -> writeTasks ((Task title):ts)

readTasks :: IO [Task]
readTasks = doesPathExist fileName >>= \exists -> if exists then decodeFileThrow fileName 
                                                             else return []

writeTasks :: [Task] -> IO ()
writeTasks = encodeFile fileName 
