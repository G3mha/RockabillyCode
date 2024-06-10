%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "rockabilly.tab.h"

void yyerror(const char *s);
extern int yylex();
%}

%union {
    int ival;
    char *sval;
}

%token <ival> NUMBER
%token <sval> IDENTIFIER STRING
%token EOL COMMA RPAREN LPAREN LOCAL FUNCTION END RETURN WHILE DO IF THEN ELSE PRINT OR AND EQ GT LT PLUS MINUS CONCAT MUL DIV NOT READ ASSIGN

/* %type <sval> block statement statement_list
%type <ival> bool_expression bool_term relation_expression expression term factor */

%%
block
    : statement_list
    ;

statement_list
    : statement
    | statement_list statement
    ;

statement
    : IDENTIFIER ASSIGN bool_exp EOL
    | IDENTIFIER LPAREN opt_bool_exp_list RPAREN EOL
    | LOCAL IDENTIFIER opt_is_bool_exp EOL
    | PRINT bool_exp EOL
    | WHILE bool_exp EOL DO EOL statement_list END EOL
    | IF bool_exp EOL THEN EOL statement_list opt_else_statement END EOL
    | FUNCTION IDENTIFIER LPAREN opt_identifier_list RPAREN EOL statement_list END EOL
    | RETURN bool_exp EOL
    | EOL // Allow empty lines
    ;

opt_bool_exp_list
    : /* empty */
    | bool_exp_list
    ;

bool_exp_list
    : bool_exp
    | bool_exp_list COMMA bool_exp
    ;

opt_is_bool_exp
    : /* empty */
    | ASSIGN bool_exp
    ;

opt_else_statement
    : /* empty */
    | ELSE EOL statement_list
    ;

opt_identifier_list
    : /* empty */
    | identifier_list
    ;

identifier_list
    : IDENTIFIER
    | identifier_list COMMA IDENTIFIER
    ;

bool_exp
    : bool_term
    | bool_exp OR bool_term
    ;

bool_term
    : rel_exp
    | bool_term AND rel_exp
    ;

rel_exp
    : expression
    | rel_exp EQ expression
    | rel_exp GT expression
    | rel_exp LT expression
    ;

expression
    : term
    | expression PLUS term
    | expression MINUS term
    | expression CONCAT term
    ;

term
    : factor
    | term MUL factor
    | term DIV factor
    ;

factor
    : NUMBER
    | STRING
    | IDENTIFIER
    | IDENTIFIER LPAREN opt_bool_exp_list RPAREN
    | PLUS factor
    | MINUS factor
    | NOT factor
    | LPAREN bool_exp RPAREN
    | READ
    ;
%%
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    return yyparse();
}
