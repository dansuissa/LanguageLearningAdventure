module Cmd where

data Cmd = Next
         | Back
         | Learn
         | Quiz
         | Progress
         | ExitQuiz
         | Quit
         | Help
         | ChooseLevel   -- New command for choosing a level
         deriving (Show, Eq)
