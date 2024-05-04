%{
#include "main.tab.h"
%}

%option noyywrap

%%

"unchained" { return VARIABLE; }
"chained" { return CONSTANT; }

"To say the words he truly feels:" { return PRINT; }

"While I can think" { return WHILE_CONDITION; }
"While I can stand" { return WHILE_STATEMENTS; }
"while I can talk" { return WHILE_END; }

"If I can dream" { return IF_CONDITION; }
"so please let my dream" { return IF_STATEMENTS; }
"but" { return ELSE; }
"come true" { return IF_END; }

"It's Now" { return OR_INIT; }
"or" { return OR; }
"Never" { return OR_END; }

"Oh, there's black Jack" { return AND_INIT; }
"and" { return AND; }
"poker" { return AND_END; }

"Treat me like" { return COMP_INIT; }
"equal" { return COMP_EQUAL; }
"more" { return COMP_MORE; }
"less" { return COMP_LESS; }
"treat me nice" { return COMP_END; }

"Love me tender" { return SUM; }
"So don't you mess around with me" { return SUBTRACT; }

"You were always on my mind" { return MULTIPLY; }
"They're so lonely" { return DIVIDE; }

"Can't Help Falling in Love" { return PLUS; }
"I'm evil" { return MINUS; }
"You're the devil in disguise" { return NOT; }

"When you don't believe a word I say:" { return INPUT; }

[a-zA-Z]+ { yylval.str = strdup(yytext); return IDENTIFIER; }
[0-9]+ { yylval.val = atoi(yytext); return NUMBER; }
\n { return NEWLINE; }
[ \t]+ { /* ignore whitespace */ }
. { return *yytext; }

%%
