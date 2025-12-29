%{
#include <stdio.h>

/* Variables globales */
int n_media = 0;       
int n_propiedades = 0; 
int n_reglas = 0;      
int n_important = 0;  
%}

%option noyywrap

/* estado para comentarios*/
%x COM

/* Una propiedad es una palabra (letras y guiones) seguida de ":" */
propiedad   [a-zA-Z\-]+[ \t]*:

/* signo "!" seguido opcionalmente de espacios y la palabra important) */
important   "!"[ \t]*"important"

%%

"/*"            { BEGIN(COM); }
<COM>.|\n       { ; }
<COM>"*/"       { BEGIN(INITIAL); }

\"[^\"]*\"      { ; }
\'[^\']*\'      { ; }

"@media"        { n_media++; }

"{"             { n_reglas++; }

{important}     { n_important++; }

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
    printf("- Número total de propiedades: %d\n", n_propiedades);
    printf("- Número de reglas: %d\n", n_reglas);
    printf("- Número de propiedades !important: %d\n", n_important);
    
    return 0;
}