module Parser where

import Cmd
import Data.Char (toLower)
import Control.Applicative

newtype Parser a = Parser { runParser :: String -> Maybe (a, String) }

instance Functor Parser where
    fmap f (Parser p) = Parser $ \s -> do
        (x, rest) <- p s
        return (f x, rest)

instance Applicative Parser where
    pure x = Parser $ \s -> Just (x, s)
    (Parser pf) <*> (Parser p) = Parser $ \s -> do
        (f, rest) <- pf s
        (x, rest') <- p rest
        return (f x, rest')

instance Alternative Parser where
    empty = Parser $ \_ -> Nothing
    (Parser p1) <|> (Parser p2) = Parser $ \s ->
        p1 s <|> p2 s

instance Monad Parser where
    return = pure
    (Parser p) >>= f = Parser $ \s -> do
        (x, rest) <- p s
        runParser (f x) rest

-- Simple Parsers
token :: String -> Parser String
token s = fmap (const s) (stringP s)

stringP :: String -> Parser String
stringP = traverse charP

charP :: Char -> Parser Char
charP c = Parser f
    where f (x:xs) | x == c = Just (x, xs)
          f _ = Nothing

ws :: Parser String
ws = many (charP ' ')

parseCmd :: Parser Cmd
parseCmd = parseNext <|> parseBack <|> parseLearn <|> parseQuiz <|> parseProgress <|> parseExitQuiz <|> parseQuit <|> parseHelp

parseNext :: Parser Cmd
parseNext = (token "next" <|> token "n") *> pure Next

parseBack :: Parser Cmd
parseBack = (token "back" <|> token "b") *> pure Back

parseLearn :: Parser Cmd
parseLearn = (token "learn" <|> token "l") *> pure Learn

parseQuiz :: Parser Cmd
parseQuiz = (token "quiz" <|> token "qz") *> pure Quiz

parseProgress :: Parser Cmd
parseProgress = (token "progress" <|> token "p") *> pure Progress

parseExitQuiz :: Parser Cmd
parseExitQuiz = (token "exitquiz" <|> token "eq") *> pure ExitQuiz

parseQuit :: Parser Cmd
parseQuit = (token "quit" <|> token "q") *> pure Quit

parseHelp :: Parser Cmd
parseHelp = token "help" *> pure Help

parseInput :: String -> Maybe Cmd
parseInput s = fmap fst $ runParser parseCmd (map toLower s)
