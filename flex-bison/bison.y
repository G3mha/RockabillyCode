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
%token <str_val> IDENTIFIER DECLARATOR PRINT WHILE_CONDITION WHILE_STATEMENTS WHILE_END IF_CONDITION IF_STATEMENTS ELSE IF_END OR_INIT OR OR_END AND_INIT AND AND_END COMP_INIT COMP_EQUAL COMP_MORE COMP_LESS COMP_END SUM SUBTRACT MULTIPLY DIVIDE PLUS MINUS NOT INPUT NEWLINE
%type <int_val> expression bool_exp bool_term term factor sequence

%%

block: /* empty */
       | statement
       | block statement
       ;

statement: NEWLINE
         | print NEWLINE
         | declaration NEWLINE
         | while NEWLINE
         | if NEWLINE
         ;

print: PRINT bool_exp
     { printf("Print result: %d\n", $2); }
     ;

declaration: IDENTIFIER DECLARATOR bool_exp
           { printf("Declaring Identifier: %s\n", $1); }
           ;

while: WHILE_CONDITION NEWLINE bool_exp NEWLINE WHILE_STATEMENTS NEWLINE block WHILE_END
     ;

if: IF_CONDITION NEWLINE bool_exp NEWLINE IF_STATEMENTS NEWLINE block optional_else IF_END
  ;

optional_else: /* empty */
             | ELSE NEWLINE block
             ;

bool_exp: bool_term
        | bool_exp OR bool_exp
        ;

bool_term: rel_exp
         | bool_term AND bool_term
         ;

rel_exp: expression
       | rel_exp rel_op rel_exp
       ;

rel_op: COMP_EQUAL { printf("Equal\n"); }
      | COMP_MORE { printf("More\n"); }
      | COMP_LESS { printf("Less\n"); }
      ;

expression: term
          | expression expr_op expression
          ;

expr_op: SUM { printf("Sum\n"); }
       | SUBTRACT { printf("Subtract\n"); }
       ;

term: factor
    | term term_op term
    ;

term_op: MULTIPLY { printf("Multiply\n"); }
       | DIVIDE { printf("Divide\n"); }
       ;

factor: sequence
      | IDENTIFIER { printf("Identifier\n"); }
      | factor_op factor
      | INPUT { printf("Input\n"); }
      ;

factor_op: PLUS { printf("Plus\n"); }
         | MINUS { printf("Minus\n"); }
         | NOT { printf("Not\n"); }
         ;

sequence: NUMBER
        { $$ = $1; }  // Assigns the value of NUMBER to sequence
        | sequence NUMBER
        { $$ = $1 * 10 + $2; }  // Multiplies the current sequence by 10 and adds the new digit
        ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "%s at line %d\n", s, yylineno);
}

int main(void) {
    if (yyparse() == 0) {
       printf("Analysis concluded sucessfully.\n");
    } else {
       printf("Analysis failed.\n");
    }
    return 0;
}