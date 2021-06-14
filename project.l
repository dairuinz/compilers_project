%option noyywrap

%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "project.tab.h"
  //EXEI SIMASIA ME POIA SEIRA TA GRAFOYME TA PARAKATO YPOSINOLO PIO PSILA APO YPERSINOLO
  //idia seira me kanones isos na doyleyei sosta
  extern int yylex();
%}

%option noyywrap

comment       [%]+.*
program       (PROGRAM)
function      (FUNCTION)
vars          (VARS)
mychar        (CHAR)
myinteger     (INTEGER)
end_function  (END_FUNCTION)
start_main    (STARTMAIN)
end_main      (ENDMAIN)
return        (RETURN)
while         (WHILE)
end_while     (ENDWHILE)
and           (AND)
or            (OR)
for           (FOR)
to            (TO)
step          (STEP)
end_for       (ENDFOR)
if            (IF)
then          (THEN)
else          (ELSE)
else_if       (ELSEIF)
end_if        (ENDIF)
switch        (SWITCH)
case          (CASE)
default       (DEFAULT)
end_switch    (ENDSWITCH)
print         (PRINT)
break         (BREAK)
struct        (STRUCT)
endstruct     (ENDSTRUCT)
typedef       (TYPEDEF)
thetikos_aker [0-9]+
myfloat       [0-9]+\.[0-9]+
mystring      [A-Za-z]+[A-Za-z0-9]*


%%

{comment}         {};
"("               return A_PARENTHESI;
")"               return D_PARENTHESI;
","               return KOMMA;
";"               return Q_MARK;
"["               return A_BRACKET;
"]"               return D_BRACKET;
"+"               return ADD;
"-"               return SUBTRACT;
"^"               return POWER_OF;
"*"               return MULTIPLY;
"/"               return DIVIDE;
"="               return EQUALS;
">"               return BIGGER_THAN;
"<"               return SMALLER_THAN;
"=="              return LOG_EQUALS;
"!="              return NOT_EQUAL;
":"               return COLON;
"'"               return ARIST; 
{while}           return WHILE;
{end_while}       return ENDWHILE;
{and}             return AND;
{or}              return OR;
{for}             return FOR;
{to}              return TO;
{step}            return STEP;
{end_for}         return ENDFOR;
{if}              return IF;
{then}            return THEN;
{else}            return ELSE;
{else_if}         return ELSEIF;
{end_if}          return ENDIF;
{switch}          return SWITCH;
{case}            return CASE;
{default}         return DEFAULT;
{end_switch}      return ENDSWITCH;
{print}           return PRINT;
{break}           return BREAK;
{program}         return PROGRAM;
{return}          return RETURN;
{thetikos_aker}   return THETIKOS_AKER;
{myfloat}         return FLOAT;
{start_main}      return STARTMAIN;
{end_main}        return ENDMAIN;
{function}        return FUNCTION;
{vars}            return VARS;
{end_function}    return END_FUNCTION;
{struct}          return STRUCT;
{endstruct}       return ENDSTRUCT;
{typedef}         return TYPEDEF;
{mychar}          return CHAR;
{myinteger}       return INTEGER;
{mystring}        {yylval.sval = strdup(yytext);  return STRING;}


%%
