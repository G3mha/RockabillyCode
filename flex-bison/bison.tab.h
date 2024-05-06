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
     DECLARATOR = 260,
     PRINT = 261,
     WHILE_CONDITION = 262,
     WHILE_STATEMENTS = 263,
     WHILE_END = 264,
     IF_CONDITION = 265,
     IF_STATEMENTS = 266,
     ELSE = 267,
     IF_END = 268,
     OR_INIT = 269,
     OR = 270,
     OR_END = 271,
     AND_INIT = 272,
     AND = 273,
     AND_END = 274,
     COMP_INIT = 275,
     COMP_EQUAL = 276,
     COMP_MORE = 277,
     COMP_LESS = 278,
     COMP_END = 279,
     SUM = 280,
     SUBTRACT = 281,
     MULTIPLY = 282,
     DIVIDE = 283,
     PLUS = 284,
     MINUS = 285,
     NOT = 286,
     INPUT = 287,
     NEWLINE = 288
   };
#endif
/* Tokens.  */
#define NUMBER 258
#define IDENTIFIER 259
#define DECLARATOR 260
#define PRINT 261
#define WHILE_CONDITION 262
#define WHILE_STATEMENTS 263
#define WHILE_END 264
#define IF_CONDITION 265
#define IF_STATEMENTS 266
#define ELSE 267
#define IF_END 268
#define OR_INIT 269
#define OR 270
#define OR_END 271
#define AND_INIT 272
#define AND 273
#define AND_END 274
#define COMP_INIT 275
#define COMP_EQUAL 276
#define COMP_MORE 277
#define COMP_LESS 278
#define COMP_END 279
#define SUM 280
#define SUBTRACT 281
#define MULTIPLY 282
#define DIVIDE 283
#define PLUS 284
#define MINUS 285
#define NOT 286
#define INPUT 287
#define NEWLINE 288




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 11 "bison.y"
{
    int int_val;
    char *str_val;
}
/* Line 1529 of yacc.c.  */
#line 120 "bison.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

