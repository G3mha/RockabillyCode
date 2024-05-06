%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
extern int yylineno;
%}

%union {
    int int_val;
    char *str_val;
}

%token <int_val> NUMBER
%type <int_val> sequence
%token <str_val> IDENTIFIER DECLARATOR PRINT WHILE_CONDITION WHILE_STATEMENTS WHILE_END IF_CONDITION IF_STATEMENTS ELSE IF_END OR_INIT OR OR_END AND_INIT AND AND_END COMP_INIT COMP_EQUAL COMP_MORE COMP_LESS COMP_END SUM SUBTRACT MULTIPLY DIVIDE PLUS MINUS NOT INPUT NEWLINE


%%

block: /* empty */
       | statement
       | block statement
       ;

statement: print NEWLINE
         | declaration NEWLINE
         | while NEWLINE
         | if NEWLINE
         ;

print: PRINT bool_exp
     ;

declaration: IDENTIFIER DECLARATOR bool_exp
           ;

while: WHILE_CONDITION bool_exp WHILE_STATEMENTS NEWLINE block WHILE_END
     ;

if: IF_CONDITION bool_exp IF_STATEMENTS NEWLINE block optional_else IF_END
  ;

optional_else: /* empty */
             | ELSE NEWLINE block
             ;

bool_exp: OR_INIT bool_term OR_END
        | bool_exp OR bool_term
        ;

bool_term: AND_INIT rel_exp AND_END
         | bool_term AND rel_exp
         ;

rel_exp: COMP_INIT expression
       | rel_exp rel_op expression
       ;

rel_op: COMP_EQUAL { printf("EQUAL\n"); }
      | COMP_MORE { printf("MORE\n"); }
      | COMP_LESS { printf("LESS\n"); }
      ;

expression: term
          | expression expr_op term
          ;

expr_op: SUM { printf("SUM\n"); }
       | SUBTRACT { printf("SUBTRACT\n"); }
       ;

term: factor
    | term term_op factor
    ;

term_op: MULTIPLY { printf("MULTIPLY\n"); }
       | DIVIDE { printf("DIVIDE\n"); }
       ;

factor: sequence
       | IDENTIFIER { printf("IDENTIFIER\n"); }
       | factor_op factor
       | INPUT { printf("INPUT\n"); }
       ;

factor_op: PLUS { printf("PLUS\n"); }
         | MINUS { printf("MINUS\n"); }
         | NOT { printf("NOT\n"); }
         ;

sequence: NUMBER
        | sequence NUMBER
        ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "%s at line %d\n", s, yylineno);
}

int main(void) {
    return yyparse();
}
