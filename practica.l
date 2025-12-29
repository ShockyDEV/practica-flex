%{
#include <stdio.h>

/* Variables globales basadas en eje03parts.l */
int n_media = 0;        
int n_propiedades = 0;  
int n_reglas = 0;       
int n_important = 0;    
int n_medidas = 0;
int n_colores = 0;
int colores_regla_actual = 0;
int max_colores_regla = 0;
%}

%option noyywrap

/* estado para comentarios y para las reglas */
%x COM REGLA

/* signo "!" seguido opcionalmente de espacios y la palabra important) */
important   "!"[ \t\n\r]*"important"

/* Una propiedad es una palabra (letras y guiones) seguida de ":" */
propiedad   [a-zA-Z\-]+[ \t]*:

/* medida es un número (entero o decimal) seguido de la unidad */
num         [0-9]*\.?[0-9]+
unidades    (pt|mm|cm|pc|in|px|em|ex)
medida      {num}{unidades}

/* Formato HEX para colores, #3, #6 o #8 dígitos */
hex         [0-9a-fA-F]
colorHEX      #({hex}{3}|{hex}{6}|{hex}{8})

/* Formato RGB/RGBA: componentes como valor (0-255) o porcentaje y transparencia */
valor       ([0-9]+%|[0-9]+)
alpha       (\.[0-9]+|[0-9]*\.[0-9]+|[0-9]+)
colorRGB      rgba?\({valor},[ \t]*{valor},[ \t]*{valor}(,[ \t]*{alpha})?\)

/* Formato nombre para colores */
colornombre      (black|gray|silver|white|maroon|red|purple|fuchsia|green|lime|olive|yellow|navy|blue|teal|aqua|orange)

%%

"/*"            { BEGIN(COM); }
<COM>.|\n       { ; }
<COM>"*/"       { BEGIN(INITIAL); }

\"[^\"]*\"      { ; }
\'[^\']*\'      { ; }

"@media"        { n_media++; }

"{"             { 
    n_reglas++; 
    colores_regla_actual = 0; 
    BEGIN(REGLA); 
}

<REGLA>{important} { n_important++; }
<REGLA>{medida}    { n_medidas++; }

<REGLA>({colorHEX}|{colorRGB}|{colornombre}) { 
    n_colores++; 
    colores_regla_actual++;
}

<REGLA>{propiedad} { n_propiedades++; }

<REGLA>"}"         { 
    /* al salir de la regla, reviso si es el nuevo máximo */
    if (colores_regla_actual > max_colores_regla) {
        max_colores_regla = colores_regla_actual;
    }
    BEGIN(INITIAL); 
}

<REGLA>.|\n        { ; }
.|\n               { ; }

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
    printf("- Número total propiedades: %d\n", n_propiedades);
    printf("- Número de reglas: %d\n", n_reglas);
    printf("- Número de propiedades !important: %d\n", n_important);
    printf("- Número de valores de medida: %d\n", n_medidas);
    printf("- Número de especificaciones de color: %d\n", n_colores);
    printf("- Máximo número de colores en una sola regla: %d\n", max_colores_regla);
    
    return 0;
}