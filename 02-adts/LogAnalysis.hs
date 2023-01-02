{-# OPTIONS_GHC -Wall #-}
module LogAnalysis where

import Log

parseMessage :: String -> LogMessage
parseMessage message = 
  case words message of
    ("E":severity:timestamp:rest) ->
      LogMessage (Error (read severity :: Int)) (read timestamp :: Int) (unwords rest)
    ("W":timestamp:rest) ->
      LogMessage Warning (read timestamp :: Int) (unwords rest)
    ("I":timestamp:rest) ->
      LogMessage Info (read timestamp :: Int) (unwords rest)
    rest -> Unknown (unwords rest)

parse :: String -> [LogMessage]
parse file = map parseMessage $ lines file

insert :: LogMessage -> MessageTree -> MessageTree
insert msg@LogMessage{} Leaf = Node Leaf msg Leaf
insert msg@(LogMessage _ msgTimestamp _) (Node left treeMsg@(LogMessage _ treeTimestamp _) right)
  | msgTimestamp > treeTimestamp = Node left treeMsg (insert msg right)
  | otherwise = Node (insert msg left) treeMsg right
insert _ tree = tree

build :: [LogMessage] -> MessageTree
build  = foldr insert Leaf

inOrder :: MessageTree -> [LogMessage]
inOrder Leaf = []
inOrder (Node left msg right) = inOrder left ++ [msg] ++ inOrder right


isSevere :: LogMessage -> Bool
isSevere (LogMessage (Error severity) _ _)
  | severity > 50 = True
  | otherwise = False
isSevere _ = False

msgToString :: LogMessage -> String
msgToString (LogMessage _ _ msg) = msg
msgToString (Unknown msg) = msg

whatWentWrong :: [LogMessage] -> [String]
whatWentWrong = map msgToString . filter isSevere . inOrder . build
