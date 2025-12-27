%{
#include <stdio.h>
int n_media = 0; 
%}

%option noyywrap

/* estado para comentarios */
%x COM

%% 


"/*"            { BEGIN(COM); }
<COM>.|\n       { ; }
<COM>"*/"       { BEGIN(INITIAL); }

"@media"        { n_media++; }

.|\n            { ; }

%%

/* main para pasar el CSS por consola */
int main(int argc, char **argv)
{
    if(argc > 1) {
        if(!(yyin = fopen(argv[1], "r"))) {
            perror(argv[1]);
            return (1);
        }
    }
    yylex();
    printf("- Número de bloques @media: %d\n", n_media);
    return 0;
}