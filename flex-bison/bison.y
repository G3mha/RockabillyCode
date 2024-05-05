%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
extern int yylineno;
%}

%token <int> NUMBER IDENTIFIER VARIABLE CONSTANT PRINT WHILE_CONDITION WHILE_STATEMENTS WHILE_END IF_CONDITION IF_STATEMENTS ELSE IF_END OR_INIT OR OR_END AND_INIT AND AND_END COMP_INIT COMP_EQUAL COMP_MORE COMP_LESS COMP_END SUM SUBTRACT MULTIPLY DIVIDE PLUS MINUS NOT INPUT NEWLINE
%type <int> number sequence

%%

program: block
       ;

block: statements
     ;

statements: /* empty */
          | statement statements
          ;

statement: print NEWLINE
         | identifier NEWLINE
         | while NEWLINE
         | if NEWLINE
         ;

print: PRINT bool_exp
     { $$ = $2; }
     ;

identifier: chaining IDENTIFIER
          { $$ = strdup($2); }
          ;

chaining: VARIABLE
        { $$ = strdup("unchained"); }
        | CONSTANT
        { $$ = strdup("chained"); }
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
      | IDENTIFIER
      { $$ = $1; }
      | factor_op factor
      { $$ = $2; }
      | DONT_BELIEVE
      ;

factor_op: CANT_HELP
         | IM_EVIL
         | DEVIL_DISGUISE
         ;

number:
    NUMBER
    ;

sequence:
    number
    | sequence number { $$ = $1 * 10 + $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "%s at line %d\n", s, yylineno);
}

int main(void) {
    return yyparse();
}
