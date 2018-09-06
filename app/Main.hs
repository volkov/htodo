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
             | Done { index :: Int }
             | DoneAll
             | List
               deriving (Show, Data, Typeable)

data Task = Task { name :: String } deriving (Show, Generic)
instance ToJSON Task
instance FromJSON Task

add     = Add { title = def &= argPos 0 } &= auto
done    = Done { index = def &= argPos 0 }
doneAll = DoneAll
list    = List

main :: IO ()
main = cmdArgs (modes [add, done, doneAll, list]) >>= exec

fileName :: FilePath
fileName = ".htodo"

exec :: Command -> IO() 
exec List                 = readTasks >>= mapM_ print 
exec Add {title = title}  = process ((:)(Task title))
exec Done {index = index} = process (\ts -> take index ts ++ drop (index + 1) ts)
exec DoneAll              = writeTasks []

process :: ([Task] -> [Task]) -> IO()
process f = readTasks >>= \ts -> writeTasks (f ts)

readTasks :: IO [Task]
readTasks = doesPathExist fileName >>= \exists -> if exists then decodeFileThrow fileName 
                                                            else return []

writeTasks :: [Task] -> IO ()
writeTasks = encodeFile fileName 
