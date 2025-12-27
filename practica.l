%{
#include <stdio.h>

/* variables globales*/

int n_media = 0;       
int n_propiedades = 0; 
int n_reglas = 0;      
%}

%option noyywrap

/* estado para comentarios*/
%x COM

/* Una propiedad es una palabra (letras y guiones) seguida de ":" */
propiedad   [a-zA-Z\-]+[ \t]*:

%%

"/*"            { BEGIN(COM); }
<COM>.|\n       { ; }
<COM>"*/"       { BEGIN(INITIAL); }

"@media"        { n_media++; }

"{"             { n_reglas++; }

{propiedad}     { n_propiedades++; }

.|\n            { ; }

%%

/* main para pasar el CSS por consola y printear resultados por pantalla */
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
    printf("- Número de propiedades: %d\n", n_propiedades);
    printf("- Número de reglas: %d\n", n_reglas);
    
    return 0;
}