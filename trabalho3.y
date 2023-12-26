%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
%}



int yyerror(char* s) {
    fprintf(stderr, "Erro: %s\n", s);
    return 1;
}

int yylex(void);

int main(void) {
    yyparse();
    return 0;
}