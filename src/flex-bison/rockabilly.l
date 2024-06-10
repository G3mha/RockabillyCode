%{
#include "rockabilly.tab.h"
#include <string.h>

// Function to map number words to their corresponding integer values
int word_to_num(const char *word) {
  if (strcmp(word, "zero") == 0) return 0;
  if (strcmp(word, "one") == 0) return 1;
  if (strcmp(word, "two") == 0) return 2;
  if (strcmp(word, "three") == 0) return 3;
  if (strcmp(word, "four") == 0) return 4;
  if (strcmp(word, "five") == 0) return 5;
  if (strcmp(word, "six") == 0) return 6;
  if (strcmp(word, "seven") == 0) return 7;
  if (strcmp(word, "eight") == 0) return 8;
  if (strcmp(word, "nine") == 0) return 9;
  return -1; // Invalid number word
}

// Function to convert a sequence of number words to an integer
int words_to_number(const char *words) {
  int num = 0;
  char word[10];
  const char *p = words;
  while (*p != '\0') {
    if (sscanf(p, "%s", word) == 1) {
      num = num * 10 + word_to_num(word);
      p += strlen(word);
      while (*p == ' ') p++;
    } else {
      break;
    }
  }
  return num;
}

%}

%%

[ \t]+ ;  // Ignore whitespaces
"\n" { printf("Token: EOL\n"); return EOL; }
"," { printf("Token: COMMA\n"); return COMMA; }
"(" { printf("Token: LPAREN\n"); return LPAREN; }
")" { printf("Token: RPAREN\n"); return RPAREN; }
\"([^\"]*)\" {
  // Remove the quotes from the string and store in yylval
  yylval.sval = strdup(yytext + 1);
  yylval.sval[strlen(yylval.sval) - 1] = '\0';
  printf("Token: STRING, Value: %s\n", yylval.sval);
  return STRING;
}

(one|two|three|four|five|six|seven|eight|nine|zero)+ {
  // Convert the sequence of number words to an integer and store in yylval
  yylval.ival = words_to_number(yytext);
  printf("Token: NUMBER, Value: %d\n", yylval.ival);
  return NUMBER;
}

"Memphis" { printf("Token: LOCAL\n"); return LOCAL; }
"Blue Hawaii" { printf("Token: FUNCTION\n"); return FUNCTION; }
"We can't go on together" { printf("Token: END\n"); return END; }
"Return to sender" { printf("Token: RETURN\n"); return RETURN; }
"While I can think" { printf("Token: WHILE\n"); return WHILE; }
"While I can talk" { printf("Token: DO\n"); return DO; }
"While I can stand" { printf("Token: END\n"); return END; }
"If I can dream" { printf("Token: IF\n"); return IF; }
"So please let my dream" { printf("Token: THEN\n"); return THEN; }
"But I can't help" { printf("Token: ELSE\n"); return ELSE; }
"Come true" { printf("Token: END\n"); return END; }
"To say the words he truly feels:" { printf("Token: PRINT\n"); return PRINT; }
"It's Now or Never" { printf("Token: OR\n"); return OR; }
"Oh, there's black Jack and poker" { printf("Token: AND\n"); return AND; }
"equal to" { printf("Token: EQ\n"); return EQ; }
"more than" { printf("Token: GT\n"); return GT; }
"less than" { printf("Token: LT\n"); return LT; }
"Love me tender" { printf("Token: PLUS\n"); return PLUS; }
"So don't you mess around with me" { printf("Token: MINUS\n"); return MINUS; }
"Follow That Dream" { printf("Token: CONCAT\n"); return CONCAT; }
"You were always on my mind" { printf("Token: MUL\n"); return MUL; }
"They're so lonely" { printf("Token: DIV\n"); return DIV; }
"Can't Help Falling in Love" { printf("Token: PLUS\n"); return PLUS; }
"I'm evil" { printf("Token: MINUS\n"); return MINUS; }
"You're the devil in disguise" { printf("Token: NOT\n"); return NOT; }
"When you don't believe a word I say:" { printf("Token: READ\n"); return READ; }
"is" { printf("Token: ASSIGN\n"); return ASSIGN; }

[a-zA-Z]+ {
  // if none of the reserved words are found, it is an identifier
  yylval.sval = strdup(yytext);
  printf("Token: IDENTIFIER, Value: %s\n", yylval.sval);
  return IDENTIFIER;
}

%%

int yywrap() {
  return 1;
}