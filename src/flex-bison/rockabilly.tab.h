/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     NUMBER = 258,
     IDENTIFIER = 259,
     STRING = 260,
     EOL = 261,
     COMMA = 262,
     RPAREN = 263,
     LPAREN = 264,
     LOCAL = 265,
     FUNCTION = 266,
     END = 267,
     RETURN = 268,
     WHILE = 269,
     DO = 270,
     IF = 271,
     THEN = 272,
     ELSE = 273,
     PRINT = 274,
     OR = 275,
     AND = 276,
     EQ = 277,
     GT = 278,
     LT = 279,
     PLUS = 280,
     MINUS = 281,
     CONCAT = 282,
     MUL = 283,
     DIV = 284,
     NOT = 285,
     READ = 286,
     ASSIGN = 287
   };
#endif
/* Tokens.  */
#define NUMBER 258
#define IDENTIFIER 259
#define STRING 260
#define EOL 261
#define COMMA 262
#define RPAREN 263
#define LPAREN 264
#define LOCAL 265
#define FUNCTION 266
#define END 267
#define RETURN 268
#define WHILE 269
#define DO 270
#define IF 271
#define THEN 272
#define ELSE 273
#define PRINT 274
#define OR 275
#define AND 276
#define EQ 277
#define GT 278
#define LT 279
#define PLUS 280
#define MINUS 281
#define CONCAT 282
#define MUL 283
#define DIV 284
#define NOT 285
#define READ 286
#define ASSIGN 287




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 11 "rockabilly.y"
{
    int ival;
    char *sval;
}
/* Line 1529 of yacc.c.  */
#line 118 "rockabilly.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

