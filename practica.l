%{
/* Seccion definiciones */
%}

/* Seccion reglas */

%%
[0-9]+    { printf("He encontrado un número: %s\n", yytext); }
[a-z]+    { printf("He encontrado una palabra: %s\n", yytext); }
.         { }
%%

/* llamada a la funcion yylex con el main */
int main() {
    yylex(); // Llama al analizador
    return 0;
}