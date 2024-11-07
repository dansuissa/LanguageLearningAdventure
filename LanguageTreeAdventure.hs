module Main where

import LanguageTree
import Parser
import Cmd
import System.IO
import System.Exit (exitSuccess, exitFailure)
import Data.Char (toLower)
import Text.Read (readMaybe)
import Data.List (find)


main :: IO ()
main = do
    putStrLn "Welcome to the Language Learning Adventure!\n"
    targetLang <- selectLanguage
    let langData = generateLanguageData targetLang
    level <- selectLevel (levels langData)
    let initialZip = initializeGame level
    putStrLn $ "You have chosen " ++ show targetLang ++ ", Level " ++ show (levelNumber level) ++ ". Let's begin!\n"
    displayHelp
    gameLoop initialProgress initialZip

type Progress = [String]

initialProgress :: Progress
initialProgress = []

updateProgress :: String -> Progress -> Progress
updateProgress item progress = if item `elem` progress then progress else item : progress

viewProgress :: Progress -> IO ()
viewProgress [] = putStrLn "You have not completed any lessons yet."
viewProgress progress = do
    putStrLn "\nLessons completed:"
    mapM_ putStrLn (reverse progress)

selectLanguage :: IO TargetLanguage
selectLanguage = do
    putStrLn "Please choose a target language: Spanish, French, or German."
    putStr "> "
    hFlush stdout
    input <- getLine
    case parseLang input of
        Just lang -> return lang
        Nothing -> putStrLn "Invalid language. Please try again." >> selectLanguage

parseLang :: String -> Maybe TargetLanguage
parseLang input =
    case map toLower input of
        "spanish" -> Just Spanish
        "french" -> Just French
        "german" -> Just German
        _ -> Nothing

selectLevel :: [Level] -> IO Level
selectLevel availableLevels = do
    putStrLn "Please choose a level:"
    mapM_ (\lvl -> putStrLn $ "Level " ++ show (levelNumber lvl)) availableLevels
    putStr "> "
    hFlush stdout
    input <- getLine
    case readMaybe input :: Maybe Int of
        Just num ->
            case find (\lvl -> levelNumber lvl == num) availableLevels of
                Just lvl -> return lvl
                Nothing -> putStrLn "Invalid level number. Please try again." >> selectLevel availableLevels
        Nothing -> putStrLn "Invalid input. Please enter a level number." >> selectLevel availableLevels

initializeGame :: Level -> LangZip
initializeGame level =
    let (l:ls) = lessons level
        (n:ns) = nodes l
        lessonCxt = LessonCxt (title l) [] ns
        levelCxt = LevelCxt [] ls (Just lessonCxt)
    in (InLevel levelCxt, n)

-- Game Loop
gameLoop :: Progress -> LangZip -> IO ()
gameLoop progress z@(cxt, node) = do
    putStrLn $ "\nYou are at: " ++ getNodeTitle node
    putStrLn "What would you like to do? (Type 'help' for commands)"
    putStr "> "
    hFlush stdout
    input <- getLine
    case parseInput input of
        Just Next -> case go_next z of
            Just z' -> gameLoop progress z'
            Nothing -> endOfLesson progress z
        Just Back -> case go_back z of
            Just z' -> gameLoop progress z'
            Nothing -> putStrLn "You are at the beginning." >> gameLoop progress z
        Just Learn -> do
            putStrLn $ "\n" ++ drawLangNode node ++ "\n"
            gameLoop progress z
        Just Quiz -> case node of
            QuizNode questions -> do
                putStrLn "\nStarting Quiz! Type 'exitquiz' or 'eq' to leave the quiz early."
                score <- takeQuiz questions 0
                putStrLn $ "\nYou scored " ++ show score ++ " out of " ++ show (length questions)
                gameLoop progress z
            _ -> do
                putStrLn "No quiz available here."
                gameLoop progress z
        Just ExitQuiz -> putStrLn "You are not in a quiz to exit." >> gameLoop progress z
        Just Progress -> do
            viewProgress progress
            gameLoop progress z
        Just Quit -> do
            putStrLn "Thank you for playing!"
            exitSuccess
        Just Help -> do
            displayHelp
            gameLoop progress z
        Nothing -> do
            putStrLn "Invalid command. Please try again."
            gameLoop progress z

getNodeTitle :: LangNode -> String
getNodeTitle (WordNode word _) = "Word: " ++ word
getNodeTitle (GrammarNode rule _) = "Grammar Rule: " ++ rule
getNodeTitle (QuizNode _) = "Quiz Section"

-- Quiz Functionality with Early Exit
takeQuiz :: [QuizQuestion] -> Int -> IO Int
takeQuiz [] score = return score
takeQuiz (q:qs) score = do
    putStrLn $ "\nQuestion: " ++ question q
    putStr "> "
    hFlush stdout
    userAnswer <- getLine
    case parseInput userAnswer of
        Just ExitQuiz -> do
            putStrLn "Exiting the quiz."
            return score
        _ -> if map toLower userAnswer == map toLower (answer q)
             then do
                putStrLn "Correct!"
                takeQuiz qs (score + 1)
             else do
                putStrLn $ "Incorrect. The correct answer is: " ++ answer q
                takeQuiz qs score

-- Navigation Functions
go_next :: LangZip -> Maybe LangZip
go_next (InLevel levelCxt, node) =
    case currentLessonCxt levelCxt of
        Just lessonCxt ->
            case remainingNodes lessonCxt of
                (n:ns) ->
                    let newLessonCxt = lessonCxt { completedNodes = completedNodes lessonCxt ++ [node], remainingNodes = ns }
                        newLevelCxt = levelCxt { currentLessonCxt = Just newLessonCxt }
                    in Just (InLevel newLevelCxt, n)
                [] ->
                    -- End of nodes in current lesson
                    go_to_next_lesson (InLevel levelCxt { completedLessons = completedLessons levelCxt ++ [Lesson (lessonTitle lessonCxt) (completedNodes lessonCxt ++ [node])], currentLessonCxt = Nothing }, node)
        Nothing ->
            -- No current lesson, attempt to move to next lesson
            go_to_next_lesson (InLevel levelCxt, node)

go_to_next_lesson :: LangZip -> Maybe LangZip
go_to_next_lesson (InLevel levelCxt, _) =
    case remainingLessons levelCxt of
        (l:ls) ->
            let (n:ns) = nodes l
                newLessonCxt = LessonCxt (title l) [] ns
                newLevelCxt = levelCxt { completedLessons = completedLessons levelCxt, remainingLessons = ls, currentLessonCxt = Just newLessonCxt }
            in Just (InLevel newLevelCxt, n)
        [] ->
            -- End of level
            Nothing  -- Handle end of level in the game loop

go_back :: LangZip -> Maybe LangZip
go_back (InLevel levelCxt, node) =
    case currentLessonCxt levelCxt of
        Just lessonCxt ->
            case completedNodes lessonCxt of
                (b:bs) ->
                    let newLessonCxt = lessonCxt { completedNodes = bs, remainingNodes = node : remainingNodes lessonCxt }
                        newLevelCxt = levelCxt { currentLessonCxt = Just newLessonCxt }
                    in Just (InLevel newLevelCxt, b)
                [] -> Nothing  -- At the beginning of the lesson
        Nothing -> Nothing  -- No lesson context


-- End of Lesson Handling
endOfLesson :: Progress -> LangZip -> IO ()
endOfLesson progress z@(InLevel levelCxt, node) = do
    case currentLessonCxt levelCxt of
        Just lessonCxt -> do
            let completedLesson = Lesson (lessonTitle lessonCxt) (completedNodes lessonCxt ++ [node])
            let updatedLevelCxt = levelCxt {
                completedLessons = completedLessons levelCxt ++ [completedLesson],
                currentLessonCxt = Nothing
            }
            case remainingLessons updatedLevelCxt of
                (l:ls) -> do
                    let (n:ns) = nodes l
                    let newLessonCxt = LessonCxt (title l) [] ns
                    let newLevelCxt = updatedLevelCxt {
                        remainingLessons = ls,
                        currentLessonCxt = Just newLessonCxt
                    }
                    putStrLn "\nLesson completed. Moving to the next lesson."
                    gameLoop progress (InLevel newLevelCxt, n)
                [] -> do
                    putStrLn "\nCongratulations! You have completed this level!"
                    proceedToNextLevel progress (InLevel updatedLevelCxt, node)
        Nothing -> do
            putStrLn "Error: No current lesson to end."
            exitFailure




proceedToNextLevel :: Progress -> LangZip -> IO ()
proceedToNextLevel progress z@(InLevel levelCxt, _) = do
    putStrLn "Do you want to proceed to the next level? (yes/no)"
    input <- getLine
    case map toLower input of
        "yes" -> do
            let currentLevelNumber = levelNumberFromContext levelCxt
            let nextLevelNumber = currentLevelNumber + 1
            let allLevels = getAllLevelsForLanguage (languageFromContext levelCxt)
            case find (\lvl -> levelNumber lvl == nextLevelNumber) allLevels of
                Just nextLevel -> do
                    let initialZip = initializeGame nextLevel
                    gameLoop progress initialZip
                Nothing -> do
                    putStrLn "No more levels available."
                    exitSuccess
        _ -> do
            putStrLn "Thank you for playing!"
            exitSuccess

-- Helper functions to extract level number and language from context
levelNumberFromContext :: LevelCxt -> Int
levelNumberFromContext levelCxt = levelNumber $ getLevelFromContext levelCxt

getLevelFromContext :: LevelCxt -> Level
getLevelFromContext levelCxt = undefined  -- Implement this to retrieve the current level

getAllLevelsForLanguage :: TargetLanguage -> [Level]
getAllLevelsForLanguage lang = levels $ generateLanguageData lang

languageFromContext :: LevelCxt -> TargetLanguage
languageFromContext levelCxt = undefined  -- Implement this to retrieve the language

-- Pretty Printing
drawLangNode :: LangNode -> String
drawLangNode (WordNode word translation) =
    "Word: " ++ word ++ " - " ++ translation
drawLangNode (GrammarNode rule explanation) =
    "Grammar Rule: " ++ rule ++ "\nExplanation: " ++ explanation
drawLangNode (QuizNode _) =
    "Quiz Time! Type 'quiz' to start the quiz."

-- Display help commands
displayHelp :: IO ()
displayHelp = do
    putStrLn "\nAvailable commands:"
    putStrLn "Type 'next' or 'n' to proceed to the next content."
    putStrLn "Type 'back' or 'b' to go back."
    putStrLn "Type 'learn' or 'l' to see the content."
    putStrLn "Type 'quiz' or 'qz' to take a quiz (when available)."
    putStrLn "Type 'exitquiz' or 'eq' to exit a quiz early."
    putStrLn "Type 'progress' or 'p' to view your progress."
    putStrLn "Type 'quit' or 'q' to exit.\n"
