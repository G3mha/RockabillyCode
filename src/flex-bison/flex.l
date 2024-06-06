%{
#include "bison.tab.h"
%}

%option noyywrap

%%

"\n" { ++yylineno; return NEWLINE; }
[ \t]+ { /* ignore whitespace */ }

"one"   { yylval.int_val = 1; return NUMBER; }
"two"   { yylval.int_val = 2; return NUMBER; }
"three" { yylval.int_val = 3; return NUMBER; }
"four"  { yylval.int_val = 4; return NUMBER; }
"five"  { yylval.int_val = 5; return NUMBER; }
"six"   { yylval.int_val = 6; return NUMBER; }
"seven" { yylval.int_val = 7; return NUMBER; }
"eight" { yylval.int_val = 8; return NUMBER; }
"nine"  { yylval.int_val = 9; return NUMBER; }
"zero"  { yylval.int_val = 0; return NUMBER; }

"is" { return DECLARATOR; }
"To say the words he truly feels:" { return PRINT; }
"While I can think" { return WHILE_CONDITION; }
"while I can talk" { return WHILE_STATEMENTS; }
"While I can stand" { return WHILE_END; }
"If I can dream" { return IF_CONDITION; }
"So please let my dream" { return IF_STATEMENTS; }
"But" { return ELSE; }
"Come true" { return IF_END; }
"It's Now or Never" { return OR; }
"Oh, there's black Jack and poker" { return AND; }
"Treat me like equal to" { return COMP_EQUAL; }
"Treat me like more than" { return COMP_MORE; }
"Treat me like less than" { return COMP_LESS; }
"Love me tender" { return SUM; }
"So don't you mess around with me" { return SUBTRACT; }
"You were always on my mind" { return MULTIPLY; }
"They're so lonely" { return DIVIDE; }
"Can't Help Falling in Love" { return PLUS; }
"I'm evil" { return MINUS; }
"You're the devil in disguise" { return NOT; }
"When you don't believe a word I say:" { return INPUT; }

[a-zA-Z]+ { yylval.str_val = strdup(yytext); return IDENTIFIER; }

%%
