%{
#include <stdio.h>

/* Variables globales */
int n_media = 0;       
int n_propiedades = 0; 
int n_reglas = 0;      
int n_important = 0;   
%}

%option noyywrap

/* estado para comentarios y para las reglas*/
%x COM
%x REGLA

/* signo "!" seguido opcionalmente de espacios y la palabra important) */
important   "!"[ \t\n\r]*"important"

/* Una propiedad es una palabra (letras y guiones) seguida de ":" */
propiedad   [a-zA-Z\-]+[ \t]*:

%%


"/*"            { BEGIN(COM); }
<COM>.|\n       { ; }
<COM>"*/"       { BEGIN(INITIAL); }


\"[^\"]*\"      { ; }
\'[^\']*\'      { ; }


"@media"        { n_media++; }


"{"             { n_reglas++; BEGIN(REGLA); }


<REGLA>{important} { n_important++; }
<REGLA>{propiedad} { n_propiedades++; }


<REGLA>"}"         { BEGIN(INITIAL); }


<REGLA>.|\n        { ; }
.|\n               { ; }

%%

/* main para pasar el CSS por consola y printear resultados por pantalla */
int main(int argc, char **argv)
{
    /* Lógica de archivos de eje29wc1file.l */
    if(argc > 1) {
        if(!(yyin = fopen(argv[1], "r"))) {
            perror(argv[1]);
            return (1);
        }
    }

    yylex();

    printf("- Número de bloques @media: %d\n", n_media);
    printf("- Número total propiedades: %d\n", n_propiedades);
    printf("- Número de reglas: %d\n", n_reglas);
    printf("- Número de propiedades !important: %d\n", n_important);
    
    return 0;
}