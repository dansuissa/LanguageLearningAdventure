# LanguageTreeAdventure
Functional Programming Project 2024
Dan Suissa, Karel Moryoussef, Adan Fhima, Maximillien Bruck
Creating a comprehensive README file for your university project is crucial, as it will be one of the key factors in determining your grade. Here's a detailed README template that covers all the essential elements:

# Language Learning Adventure

## Table of Contents
1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Installation and Setup](#installation-and-setup)
4. [Usage](#usage)
   - [Navigating the Application](#navigating-the-application)
   - [Completing Lessons](#completing-lessons)
   - [Taking Quizzes](#taking-quizzes)
   - [Tracking Progress](#tracking-progress)
5. [Architecture](#architecture)
   - [Data Structures](#data-structures)
   - [Game Loop](#game-loop)
   - [Navigation Logic](#navigation-logic)
6. [Challenges and Considerations](#challenges-and-considerations)
7. [Future Enhancements](#future-enhancements)
8. [Contributing](#contributing)
9. [License](#license)

## Project Overview
The Language Learning Adventure is an interactive language learning application that allows users to explore and master different target languages, such as Spanish, French, and German. The application presents a structured curriculum with progressive levels, lessons, and quizzes to help users develop their language skills.

The project was developed as part of a university course, with the goal of creating an engaging and effective language learning experience. The application is built using Haskell, a functional programming language, and leverages various data structures and algorithms to manage the learning content and user progress.

## Features
- **Structured Curriculum**: The application organizes language content into levels, lessons, and individual language nodes (words, grammar rules, and quizzes).
- **Interactive Lessons**: Users can navigate through the lessons, view language content, and complete associated quizzes.
- **Progress Tracking**: The application keeps track of the user's progress, allowing them to view their completed lessons and lessons remaining.
- **Customizable Language Selection**: Users can choose from Spanish, French, or German as their target language.
- **Intuitive Command-line Interface**: The application provides a user-friendly command-line interface for interacting with the language learning content.

## Installation and Setup
To run the Language Learning Adventure application, follow these steps:

1. Install a Haskell compiler, such as [GHC](https://www.haskell.org/ghc/) or [Stack](https://docs.haskellstack.org/en/stable/README/), on your system.
2. Clone the project repository from GitHub:
   ```
   git clone https://github.com/your-username/language-learning-adventure.git
   ```
3. Navigate to the project directory:
   ```
   cd language-learning-adventure
   ```
4. Compile the project:
   ```
   ghc LanguageTreeAdventure.hs
   ```
5. Run the application:
   ```
   ./LanguageTreeAdventure
   ```

## Usage

### Navigating the Application
When the application starts, you will be prompted to select a target language (Spanish, French, or German). After selecting a language, you can choose a level to begin your language learning journey.

The application provides the following commands for navigation:
- `next` or `n`: Proceed to the next content item (word, grammar rule, or quiz)
- `back` or `b`: Go back to the previous content item
- `learn` or `l`: View the current content item
- `quiz` or `qz`: Take a quiz (if available)
- `exitquiz` or `eq`: Exit the current quiz
- `progress` or `p`: View your progress
- `quit` or `q`: Exit the application
- `help`: Display the available commands

### Completing Lessons
As you progress through the lessons, the application will keep track of your completed content. When you reach the end of a lesson, the application will automatically move you to the next lesson (if available) or inform you that you have completed the current level.

### Taking Quizzes
Certain content items in the lessons will be designated as quizzes. When you encounter a quiz, you can type `quiz` or `qz` to start the quiz. The quiz will present you with a series of questions, and you can type the answer to each question. If you answer correctly, your score will be incremented. You can type `exitquiz` or `eq` at any time to exit the quiz early.

### Tracking Progress
The application provides a `progress` or `p` command that allows you to view your completed lessons. This will help you keep track of your learning progress and identify areas where you may need to focus more.

## Architecture

### Data Structures
The application uses several custom data structures to represent the language content and the user's progress:

- `TargetLanguage`: Defines the available target languages (Spanish, French, German).
- `LanguageData`: Encapsulates the language content, including levels, lessons, and language nodes.
- `Level`: Represents a level of the language curriculum, containing a list of lessons.
- `Lesson`: Holds a collection of language nodes (words, grammar rules, and quizzes).
- `LangNode`: Represents a single language learning item, such as a word, grammar rule, or quiz.
- `QuizQuestion`: Defines a quiz question with a question and an answer.
- `LangCxt`: Maintains the user's navigation context within the language content.
- `LevelCxt`: Tracks the user's progress within a specific level.
- `LessonCxt`: Keeps track of the user's progress within a lesson.

### Game Loop
The main game loop is responsible for managing the user's interactions with the application. It handles user input, updates the game state, and displays the appropriate content to the user.

The game loop is implemented in the `gameLoop` function, which takes the user's progress and the current navigation context as input. It continuously prompts the user for commands, processes the input, and updates the game state accordingly.

### Navigation Logic
The application provides several functions to handle user navigation within the language content:

- `go_next`: Moves the user to the next language node within the current lesson, or to the next lesson if the current lesson has been completed.
- `go_back`: Allows the user to go back to the previous language node within the current lesson.
- `go_to_next_lesson`: Transitions the user to the next lesson within the current level.

These navigation functions update the user's navigation context, ensuring a seamless and consistent experience as the user progresses through the language curriculum.

## Challenges and Considerations
During the development of the Language Learning Adventure, the following challenges and design considerations were addressed:

1. **Representation of Language Content**: Deciding on the appropriate data structures to represent the language content, including levels, lessons, and individual language nodes, was a key challenge. The chosen data structures needed to be flexible enough to accommodate different languages and their content.

2. **Navigation and Progress Tracking**: Implementing efficient algorithms for user navigation and progress tracking was essential to provide a smooth and engaging learning experience. The application needed to handle transitions between lessons and levels, as well as keep track of the user's completed content.

3. **Command-line Interface**: Designing a user-friendly command-line interface that allows for intuitive interaction with the language content was a priority. The interface needed to be responsive, provide clear feedback, and handle various user commands.

4. **Extensibility and Maintainability**: The application was designed with future enhancements and maintainability in mind. The modular structure and use of custom data structures facilitate the addition of new languages, levels, and features without significantly altering the core codebase.

## Future Enhancements
To further improve the Language Learning Adventure, the following enhancements could be considered:

1. **Multimedia Integration**: Incorporate audio recordings, images, and interactive exercises to enhance the language learning experience.
2. **Spaced Repetition**: Implement a spaced repetition algorithm to optimize the presentation of language content based on the user's retention and performance.
3. **Personalized Learning Paths**: Adapt the language curriculum based on the user's proficiency and learning preferences, providing a more personalized experience.
4. **Mobile/Web-based Interface**: Develop a mobile application or a web-based version of the Language Learning Adventure to improve accessibility and user convenience.
5. **Multiplayer and Collaborative Features**: Add the ability for users to connect and learn with others, fostering a sense of community and shared learning.

