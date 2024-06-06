# RockabillyCode

Author: Enricco Gemha

## How to compile its code?

You can verify the lexical and sintatic adherence, with Flex and Bison, respectively.

```bash

```

In order to compile and run the code, you can use the compiler written in Swift, with the following command.

```bash
swift main.swift <filename>.ep
```

## Description

RockabillyCode is a dynamic and expressive programming language designed to capture the vibrant energy and timeless charm of Elvis Presley's music. It features a syntax that's easy on the eyes, much like the smooth lines of a classic Cadillac, and it's built to encourage developers to be as creative and innovative as Elvis was on stage.

## File format

RockabillyCode programs are UTF-8 files with the .ep file extension.

## Comments handling

Although it's not recommended to add comments to the lyrics of your song, if you really need it, always put them into parenthesis.

## Numbers

Numbers aren't much of a concern in songs, so if you wish to use them, write them out in full.

## Variable naming

The only characters allowed are from a to Z, as capital sensitive.

## EBNF

```EBNF
BLOCK = { STATEMENT };

STATEMENT = ( | DECLARATION | PRINT | WHILE | IF ), "\n";

DECLARATION = IDENTIFIER, "is", BOOL_EXP;

PRINT = "To say the words he truly feels:", BOOL_EXP;

WHILE = "While I can think", "\n", BOOL_EXP, "\n", "While I can talk", "\n", {STATEMENT}, "While I can stand";

IF = "If I can dream","\n", BOOL_EXP, "\n", "So please let my dream", "\n", {STATEMENT}, (|"But", "\n", {STATEMENT}), "Come true";

BOOL_EXP = BOOL_TERM, { ("It's Now or Never"), BOOL_TERM };

BOOL_TERM = REL_EXP, { ("Oh, there's black Jack and poker"), REL_EXP };

REL_EXP = EXPRESSION, { "Treat me like", ("equal" | "more" | "less"), EXPRESSION };

EXPRESSION = TERM, { ("Love me tender" | "So don't you mess around with me"), TERM } ;

TERM = FACTOR, { ("You were always on my mind" | "They're so lonely"), FACTOR } ;

FACTOR = NUMBER | IDENTIFIER | (("Can't Help Falling in Love" | "I'm evil" | "You're the devil in disguise"), FACTOR ) | "When you don't believe a word I say:" ;

IDENTIFIER = LETTER, { LETTER };

NUMBER = DIGIT, { DIGIT } ;

LETTER = ( "a" | "..." | "z" | "A" | "..." | "Z" ) ;

DIGIT = ( "one" | "two" | "three" | "four" | "five" | "six" | "seven" | "eight" | "nine" | "zero" ) ;
```

## Railroad Diagram

![Railroad Diagram](./docs/img/railroad_diagram.png)
