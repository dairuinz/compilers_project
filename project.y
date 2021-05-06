%{
  
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  
  extern int yylex();
  extern int yyparse();
  extern FILE *yyin;
 
  void yyerror(const char *s);
  
  typedef struct metabliti{
      char onoma[32];
  } metabliti;

  metabliti* structs_list;
  int structs_count;

  void newstruct(char* str) {
      structs_count += 1;
      structs_list = calloc(structs_count, sizeof(metabliti));
      strcpy(structs_list[structs_count - 1].onoma, str);
      printf("\n\n\n%d\n\n\n\n", structs_count);
      printf("\n%s\n\n", (structs_list[structs_count - 1].onoma));
  }

  void foundstruct(char* str){
      int flag = 0;
      for (int i = 0; i < structs_count; i++){
          if (!strcmp(str, structs_list[i].onoma)){
            flag = 1;
            break;
          }
      }

      if (flag == 1){
          printf("\n\nto onoma sinartisis iparxei idi\n\n");
      }
      else{
          printf("\n\nden einai dilomeni h: %s\n\n", str);
          exit(1);
      }
  }

%}

%union {
  char* sval;
}


%token FLOAT;
%token PROGRAM;
%token <sval> STRING;
%token FUNCTION;
%token VARS;
%token CHAR;
%token INTEGER;
%token A_PARENTHESI;
%token D_PARENTHESI;
%token KOMMA;
%token Q_MARK;
%token THETIKOS_AKER;
%token A_BRACKET;
%token D_BRACKET;
%token END_FUNCTION;
%token RETURN;
%token STARTMAIN;
%token ENDMAIN;
%token ADD;
%token SUBTRACT;
%token POWER_OF;
%token MULTIPLY;
%token DIVIDE;
%token EQUALS;
%token WHILE;
%token ENDWHILE;
%token BIGGER_THAN;
%token SMALLER_THAN;
%token LOG_EQUALS;
%token NOT_EQUAL;
%token AND;
%token OR;
%token FOR;
%token COUNTER;
%token TO;
%token STEP;
%token ENDFOR;
%token IF;
%token THEN;
%token ELSE;
%token ELSEIF;
%token ENDIF;
%token SWITCH;
%token CASE;
%token COLON;   
%token DEFAULT;
%token ENDSWITCH;
%token PRINT;
%token BREAK;
%token ARIST;
%token STRUCT;
%token ENDSTRUCT;
%token TYPEDEF;

%%
main: program structs function entoles function_end code{
    printf("\nfoyl komple\n\n");
}
    | program {
        printf("\nfoyl komple allo\n\n");
    }     
;

program: PROGRAM STRING {
     printf("\nprogramma komple\n\n"); 
}
;

structs: STRUCT STRING VARS CHAR STRING Q_MARK ENDSTRUCT{
    printf("\n\n======= VRHKA TO: %s\n\n", $2);
    newstruct($2);
}
    | STRUCT STRING VARS CHAR STRING A_BRACKET THETIKOS_AKER D_BRACKET Q_MARK ENDSTRUCT{
        newstruct($2);
    }
    | STRUCT STRING VARS CHAR THETIKOS_AKER Q_MARK ENDSTRUCT{
        newstruct($2);
    }
    | TYPEDEF STRUCT STRING VARS CHAR STRING Q_MARK STRING ENDSTRUCT{
        printf("\n\n======= VRHKA TO: %s\n\n", $3);
        newstruct($3);
    }
    | TYPEDEF STRUCT STRING VARS CHAR STRING A_BRACKET THETIKOS_AKER D_BRACKET Q_MARK STRING ENDSTRUCT{
        newstruct($3);
    }
    | TYPEDEF STRUCT STRING VARS CHAR THETIKOS_AKER Q_MARK STRING ENDSTRUCT{
        newstruct($3);
    }
;

function: FUNCTION STRING A_PARENTHESI list D_PARENTHESI function_body{
    printf("\nfunction komple\n\n");
} 
    | FUNCTION STRING function_body { 
        printf("\nfunction xoris parameters komple\n\n");
    }
;

code: STARTMAIN function_body ENDMAIN{
    printf("\ncode komple\n\n");
} 
    | STARTMAIN ENDMAIN { 
    printf("\ncode komple xoris metablites\n\n");
    }
    | STARTMAIN function_body entoles ENDMAIN {
        printf("\ncode komple me metablites kai entoles\n\n");
    }
    | STARTMAIN entoles ENDMAIN {
        printf("\ncode komple xoris metablites me entoles\n\n");
    }
    | STARTMAIN function_body entoles a_entoles ENDMAIN {
        printf("\ncode komple me metablites kai entoles kai entoles programmatos\n\n");
    }
;

a_entoles: p_entoles
    | p_entoles a_entoles
    | e_entoles
    | e_entoles a_entoles
;

p_entoles: entoles_while
    | entoles_while p_entoles
    | entoles_for
    | entoles_for p_entoles
;

e_entoles: entoles_if
    | entoles_if e_entoles
    | entoles_switch
    | entoles_switch e_entoles
;

case_s: CASE prajeis COLON entoles
    | CASE prajeis COLON entoles case_s
;

entoles_switch: SWITCH prajeis case_s DEFAULT COLON entoles ENDSWITCH{
    printf("\nswitch\n\n");
}
    | SWITCH prajeis case_s ENDSWITCH{
        printf("\nswitch\n\n");
    }
;

if_comp: ELSEIF condition
    | ELSE
;

entoles_if: if_comp entoles entoles_if{
    printf("\nelseif or else\n\n");
}
    | IF condition THEN entoles{
        printf("\nif\n\n");
    }
    | IF condition THEN entoles entoles_if{
        printf("\nif\n\n");
    }
    | ENDIF
;

entoles_for: FOR COUNTER THETIKOS_AKER TO THETIKOS_AKER STEP THETIKOS_AKER entoles ENDFOR{
    printf("\nfor loop\n\n");
}
    | FOR COUNTER THETIKOS_AKER TO THETIKOS_AKER STEP THETIKOS_AKER entoles ENDFOR entoles_for{
    printf("\nfor loop\n\n");
    }
;

and_or: AND 
    | AND and_or
    | OR
    | OR and_or
;

condition: A_PARENTHESI STRING BIGGER_THAN THETIKOS_AKER D_PARENTHESI 
    | A_PARENTHESI STRING BIGGER_THAN THETIKOS_AKER D_PARENTHESI and_or condition
    | A_PARENTHESI STRING BIGGER_THAN STRING D_PARENTHESI
    | A_PARENTHESI STRING BIGGER_THAN STRING D_PARENTHESI and_or condition
    | A_PARENTHESI STRING SMALLER_THAN THETIKOS_AKER D_PARENTHESI
    | A_PARENTHESI STRING SMALLER_THAN THETIKOS_AKER D_PARENTHESI and_or condition  
    | A_PARENTHESI STRING SMALLER_THAN STRING D_PARENTHESI
    | A_PARENTHESI STRING SMALLER_THAN STRING D_PARENTHESI and_or condition
    | A_PARENTHESI STRING LOG_EQUALS THETIKOS_AKER D_PARENTHESI
    | A_PARENTHESI STRING LOG_EQUALS THETIKOS_AKER D_PARENTHESI and_or condition
    | A_PARENTHESI STRING LOG_EQUALS STRING D_PARENTHESI
    | A_PARENTHESI STRING LOG_EQUALS STRING D_PARENTHESI and_or condition
    | A_PARENTHESI STRING NOT_EQUAL THETIKOS_AKER D_PARENTHESI
    | A_PARENTHESI STRING NOT_EQUAL THETIKOS_AKER D_PARENTHESI and_or condition
    | A_PARENTHESI STRING NOT_EQUAL STRING D_PARENTHESI
    | A_PARENTHESI STRING NOT_EQUAL STRING D_PARENTHESI and_or condition
    | A_PARENTHESI condition D_PARENTHESI
;

entoles_while: WHILE condition entoles ENDWHILE {
    printf("\nwhile loop\n\n");
}
    | WHILE condition entoles ENDWHILE p_entoles {
        printf("\nwhile loop\n\n");
    }
    
;

prajeis:  prajeis ADD prajeis
        | prajeis SUBTRACT prajeis
        | prajeis MULTIPLY prajeis
        | prajeis DIVIDE prajeis
        | prajeis POWER_OF prajeis
        | A_PARENTHESI prajeis D_PARENTHESI
        | STRING ADD prajeis
        | THETIKOS_AKER ADD prajeis
        | STRING SUBTRACT prajeis
        | THETIKOS_AKER SUBTRACT prajeis
        | STRING MULTIPLY prajeis
        | THETIKOS_AKER MULTIPLY prajeis
        | STRING DIVIDE prajeis
        | THETIKOS_AKER DIVIDE prajeis
        | STRING POWER_OF prajeis
        | THETIKOS_AKER POWER_OF prajeis
        | STRING
        | THETIKOS_AKER
;

entoli_print: PRINT A_PARENTHESI ARIST STRING ARIST D_PARENTHESI Q_MARK
    | PRINT A_PARENTHESI ARIST  STRING ARIST KOMMA A_BRACKET STRING D_BRACKET D_PARENTHESI Q_MARK 
;

entoles: STRING EQUALS prajeis Q_MARK entoles {
    foundstruct($1);
}
    | STRING EQUALS STRING A_PARENTHESI list D_PARENTHESI Q_MARK entoles{
    foundstruct($1);
    }
    | STRING EQUALS prajeis Q_MARK {
    foundstruct($1);
    }
    | STRING EQUALS STRING A_PARENTHESI list D_PARENTHESI Q_MARK {
    foundstruct($1);
    }
    | BREAK COLON
    | entoli_print
;

list: STRING A_BRACKET THETIKOS_AKER D_BRACKET KOMMA list{
    newstruct($1);
}
    | STRING KOMMA list{
        newstruct($1);
    }
    | STRING {
        newstruct($1);
    }
;

parameters: CHAR list Q_MARK parameters
    | INTEGER list Q_MARK parameters{}
    | CHAR list Q_MARK
    | INTEGER list Q_MARK
;

function_body: VARS parameters {
    printf("\nparametroi komple\n\n");
}
;

return: RETURN STRING
    | RETURN THETIKOS_AKER
;

function_end: return END_FUNCTION {
    printf("\nend of function\n\n");
}
;


%%

int main(int argc, char** argv) {
    #ifdef YYDEBUG
        yydebug = 1;
        // yydebug = 0;
    #endif
  FILE *myfile = fopen(argv[1], "r");

  if (!myfile) {
    printf("den yparxei arxeio");
    return -1;
  }

  structs_count = 0;
  structs_list = calloc(structs_list, 1 * sizeof(metabliti));

  yyin = myfile;
  
  yyparse();
  
}

void yyerror(const char *s) {
  
  return;
}