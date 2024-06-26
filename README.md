# RockabillyCode

Author: Enricco Gemha

## How to compile the code?

You can verify the lexical and sintatic adherence, with Flex and Bison, respectively.

```bash
flex rockabilly.l; bison -d rockabilly.y
gcc lex.yy.c rockabilly.tab.c -o rockabilly
./rockabilly < ../test.ep
```

In order to compile and run the code, you can use the compiler written in Swift, with the following command.

```bash
cd src/compiler
swift rockabilly.swift ../test.ep
```

## Description

RockabillyCode is a dynamic and expressive programming language designed to capture the vibrant energy and timeless charm of Elvis Presley's music. It features a syntax that's easy on the eyes, much like the smooth lines of a classic Cadillac, and it's built to encourage developers to be as creative and innovative as Elvis was on stage.

## File format

RockabillyCode programs are UTF-8 files with the `.ep` file extension.

## Comments handling

While comments are generally discouraged in the lyrical style of RockabillyCode, if you must include them, always start them with `--`.

## Numbers

In keeping with the lyrical nature of RockabillyCode, numbers should be written out in full words (e.g., "one", "two", "three").

## Variable naming

Variable names are case-sensitive and can only contain letters from a to Z.

## EBNF

The following Extended Backus-Naur Form (EBNF) defines the grammar of RockabillyCode:

```EBNF
BLOCK = { STATEMENT };

STATEMENT = ( 
    IDENTIFIER, ( "is", BOOL_EXP | "(" , ( | BOOL_EXP, { ( "," ) , BOOL_EXP } ), ")" )
    | "Memphis", IDENTIFIER, ["is", BOOL_EXP] 
    | "To say the words he truly feels:", BOOL_EXP 
    | "While I can think", BOOL_EXP, "\n", "While I can talk", "\n", {STATEMENT}, "While I can stand" 
    | "If I can dream", BOOL_EXP, "\n", "So please let my dream", "\n", {STATEMENT}, (|"But I can't help", "\n", {STATEMENT}), "Come true" 
    | "Blue Hawaii", IDENTIFIER, "(", ( | IDENTIFIER, { ( "," ), IDENTIFIER } ), ")", "\n", { ( STATEMENT ) }, "We can't go on together" 
    | "Return to sender", BOOL_EXP 
    ), "\n" ;

BOOL_EXP = BOOL_TERM, { ("It's Now or Never"), BOOL_TERM };

BOOL_TERM = REL_EXP, { ("Oh, there's black Jack and poker"), REL_EXP };

REL_EXP = EXPRESSION, { ("equal to" | "more than" | "less than"), EXPRESSION };

EXPRESSION = TERM, { ("Love me tender" | "So don't you mess around with me" | "Follow That Dream"), TERM } ;

TERM = FACTOR, { ("You were always on my mind" | "They're so lonely"), FACTOR } ;

FACTOR = NUMBER 
    | STRING 
    | IDENTIFIER, ( | "(" , ( | BOOL_EXP, { ( "," ) , BOOL_EXP } ), ")" ) 
    | ("Can't Help Falling in Love" | "I'm evil" | "You're the devil in disguise"), FACTOR 
    | "(", BOOL_EXP, ")" 
    | "When you don't believe a word I say:" ;

IDENTIFIER = LETTER, { LETTER };

NUMBER = DIGIT, { DIGIT } ;

LETTER = ( "a" | "..." | "z" | "A" | "..." | "Z" ) ;

DIGIT = ( "one" | "two" | "three" | "four" | "five" | "six" | "seven" | "eight" | "nine" | "zero" ) ;

STRING = '"', ({LETTER}), '"';
```

## Railroad Diagram

![Railroad Diagram](./docs/img/railroad_diagram.png)

_Generated by: [DrawGrammar](https://jacquev6.github.io/DrawGrammar/)_
