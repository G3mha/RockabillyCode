%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
extern int yylineno;
%}

%union {
    int val; // For numbers
    char* str; // For strings
}

%token <str> IDENTIFIER
%token <val> NUMBER
%token UNCHAINED CHAINED PRINT WHILE WHILE_END TALK IF LET_DREAM IF_END BUT NOW NEVER OR BLACK_JACK POKER AND TREAT_ME_LIKE EQUAL MORE LESS TREAT_NICE LOVE_TENDER DONT_MESS ALWAYS_ON_MIND SO_LONELY CANT_HELP IM_EVIL DEVIL_DISGUISE DONT_BELIEVE
%token NEWLINE

%type <str> identifier bool_exp bool_term rel_exp expression term factor
%type <str> optional_else statements statement print while if chaining

%%
program: block
       ;

block: '{' statements '}'
     ;

statements: /* empty */
          { $$ = strdup(""); }
          | statements statement
          ;

statement: identifier NEWLINE
         | print NEWLINE
         | while NEWLINE
         | if NEWLINE
         ;

identifier: chaining IDENTIFIER
          { $$ = strdup($2); }
          ;

chaining: UNCHAINED
        { $$ = strdup("unchained"); }
        | CHAINED
        { $$ = strdup("chained"); }
        ;

print: PRINT bool_exp
     { $$ = $2; }
     ;

while: WHILE bool_exp TALK NEWLINE statements WHILE_END
     { $$ = $2; }
     ;

if: IF bool_exp LET_DREAM NEWLINE statements optional_else IF_END
  { $$ = $2; }
  ;

optional_else: /* empty */
             { $$ = strdup(""); }
             | BUT NEWLINE statements
             { $$ = $3; }
             ;

bool_exp: NOW bool_term NEVER
        { $$ = $2; }
        | bool_exp OR bool_term
        { $$ = $1; }
        ;

bool_term: BLACK_JACK rel_exp POKER
         { $$ = $2; }
         | bool_term AND rel_exp
         { $$ = $1; }
         ;

rel_exp: TREAT_ME_LIKE expression
       { $$ = $2; }
       | rel_exp rel_op expression
       { $$ = $1; }
       ;

rel_op: EQUAL
      | MORE
      | LESS
      ;

expression: term
          { $$ = $1; }
          | expression expr_op term
          { $$ = $1; }
          ;

expr_op: LOVE_TENDER
       | DONT_MESS
       ;

term: factor
    { $$ = $1; }
    | term term_op factor
    { $$ = $1; }
    ;

term_op: ALWAYS_ON_MIND
       | SO_LONELY
       ;

factor: NUMBER
      { $$ = strdup(""); } // Convert number to string if needed or handle differently
      | IDENTIFIER
      { $$ = $1; }
      | factor_op factor
      { $$ = $2; }
      | DONT_BELIEVE
      { $$ = strdup(""); }
      ;

factor_op: CANT_HELP
         | IM_EVIL
         | DEVIL_DISGUISE
         ;

%%
void yyerror(const char *s) {
    fprintf(stderr, "%s at line %d\n", s, yylineno);
}

int main(void) {
    return yyparse();
}
