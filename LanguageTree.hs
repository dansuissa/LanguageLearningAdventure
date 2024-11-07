module LanguageTree where

-- Data structures
data TargetLanguage = Spanish | French | German deriving (Show, Read, Enum)

data LanguageData = LanguageData {
    language :: TargetLanguage,
    levels   :: [Level]
} deriving (Show)

data Level = Level {
    levelNumber :: Int,
    lessons     :: [Lesson]
} deriving (Show)

data Lesson = Lesson {
    title :: String,
    nodes :: [LangNode]
} deriving (Show)

data LangNode = WordNode String String
              | GrammarNode String String
              | QuizNode [QuizQuestion]
              deriving (Show, Eq)

data QuizQuestion = QuizQuestion {
    question :: String,
    answer   :: String
} deriving (Show, Eq)

-- Navigation Context
data LangCxt = TopLevel [Level] [Level]              -- Levels before and after the current one
             | InLevel LevelCxt                      -- Context within a level
             deriving (Show)

data LevelCxt = LevelCxt {
    completedLessons :: [Lesson],
    remainingLessons :: [Lesson],
    currentLessonCxt :: Maybe LessonCxt
} deriving (Show)

data LessonCxt = LessonCxt {
    lessonTitle     :: String,
    completedNodes  :: [LangNode],
    remainingNodes  :: [LangNode]
} deriving (Show)

type LangZip = (LangCxt, LangNode)

-- Sample Content for Each Language with Levels
generateLanguageData :: TargetLanguage -> LanguageData
generateLanguageData Spanish = LanguageData Spanish [level1Spanish, level2Spanish]
generateLanguageData French  = LanguageData French  [level1French, level2French]
generateLanguageData German  = LanguageData German  [level1German, level2German]

-- Level 1 Spanish
level1Spanish :: Level
level1Spanish = Level 1 [
    Lesson "Greetings" [
        WordNode "Hola" "Hello",
        WordNode "Adiós" "Goodbye",
        QuizNode [
            QuizQuestion "How do you say 'Hello' in Spanish?" "Hola",
            QuizQuestion "What is 'Goodbye' in Spanish?" "Adiós"
        ]
    ],
    Lesson "Basic Grammar" [
        GrammarNode "Definite Articles" "In Spanish, 'el' is used for masculine nouns, and 'la' for feminine nouns.",
        QuizNode [
            QuizQuestion "What is the definite article for feminine nouns?" "la",
            QuizQuestion "How do you pluralize a word ending in a vowel?" "Add 's'"
        ]
    ]
    ]

-- Level 2 Spanish
level2Spanish :: Level
level2Spanish = Level 2 [
    Lesson "Advanced Greetings" [
        WordNode "Encantado" "Pleased to meet you",
        WordNode "¿Cómo estás?" "How are you?",
        QuizNode [
            QuizQuestion "Translate 'Pleased to meet you' into Spanish." "Encantado",
            QuizQuestion "How do you ask 'How are you?' in Spanish?" "¿Cómo estás?"
        ]
    ],
    Lesson "Advanced Grammar" [
        GrammarNode "Verb Conjugations" "Understanding how to conjugate regular verbs in the present tense.",
        QuizNode [
            QuizQuestion "Conjugate 'hablar' for 'yo'." "hablo",
            QuizQuestion "Conjugate 'comer' for 'tú'." "comes"
        ]
    ]
    ]

-- Repeat similar structures for French and German
-- Level 1 French
level1French :: Level
level1French = Level 1 [
    Lesson "Greetings" [
        WordNode "Bonjour" "Hello",
        WordNode "Au revoir" "Goodbye",
        QuizNode [
            QuizQuestion "How do you say 'Hello' in French?" "Bonjour",
            QuizQuestion "What is 'Goodbye' in French?" "Au revoir"
        ]
    ],
    Lesson "Basic Grammar" [
        GrammarNode "Definite Articles" "In French, 'le' is masculine, 'la' is feminine, 'les' is plural.",
        QuizNode [
            QuizQuestion "What is the definite article for feminine nouns?" "la",
            QuizQuestion "How do you pluralize a noun in French?" "Add 's'"
        ]
    ]
    ]

-- Level 2 French
level2French :: Level
level2French = Level 2 [
    Lesson "Advanced Greetings" [
        WordNode "Enchanté" "Nice to meet you",
        WordNode "Comment ça va?" "How's it going?",
        QuizNode [
            QuizQuestion "Translate 'Nice to meet you' into French." "Enchanté",
            QuizQuestion "How do you ask 'How's it going?' in French?" "Comment ça va?"
        ]
    ],
    Lesson "Advanced Grammar" [
        GrammarNode "Verb Conjugations" "Understanding how to conjugate regular verbs in the present tense.",
        QuizNode [
            QuizQuestion "Conjugate 'parler' for 'je'." "parle",
            QuizQuestion "Conjugate 'finir' for 'tu'." "finis"
        ]
    ]
    ]

-- Level 1 German
level1German :: Level
level1German = Level 1 [
    Lesson "Greetings" [
        WordNode "Hallo" "Hello",
        WordNode "Auf Wiedersehen" "Goodbye",
        QuizNode [
            QuizQuestion "How do you say 'Hello' in German?" "Hallo",
            QuizQuestion "What is 'Goodbye' in German?" "Auf Wiedersehen"
        ]
    ],
    Lesson "Basic Grammar" [
        GrammarNode "Definite Articles" "In German, 'der' is masculine, 'die' is feminine, 'das' is neuter.",
        QuizNode [
            QuizQuestion "What is the definite article for masculine nouns?" "der",
            QuizQuestion "How do you pluralize a noun in German?" "Varies; often add 'e' or 'en'"
        ]
    ]
    ]

-- Level 2 German
level2German :: Level
level2German = Level 2 [
    Lesson "Advanced Greetings" [
        WordNode "Guten Morgen" "Good morning",
        WordNode "Gute Nacht" "Good night",
        QuizNode [
            QuizQuestion "Translate 'Good morning' into German." "Guten Morgen",
            QuizQuestion "How do you say 'Good night' in German?" "Gute Nacht"
        ]
    ],
    Lesson "Advanced Grammar" [
        GrammarNode "Verb Conjugations" "Understanding how to conjugate regular verbs in the present tense.",
        QuizNode [
            QuizQuestion "Conjugate 'kommen' for 'ich'." "komme",
            QuizQuestion "Conjugate 'sehen' for 'du'." "siehst"
        ]
    ]
    ]
