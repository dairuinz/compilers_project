%{
  
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  
  extern int yylex();
  extern int yyparse();
  extern FILE *yyin;
  extern int yylineno;

  void yyerror(const char *s);
  
  typedef struct metabliti{
      char onoma[32];
  } metabliti;

  metabliti* structs_list;
  int structs_count;

  metabliti* tempvar_list;
  int tempvar_count;

  metabliti* var_list;
  int var_count;

  void newstruct(char* str) {
      structs_count += 1;
      structs_list = realloc(structs_list, structs_count * sizeof(metabliti));
      strcpy(structs_list[structs_count - 1].onoma, str);
  }

  int foundstruct(char* str){
      int flag = 0;
      for (int i = 0; i < structs_count; i++){
          if (!strcmp(str, structs_list[i].onoma)){
            flag = 1;
            return flag;
          }
      }
      return flag;
  }

  void tempvar(char* str) {
      tempvar_count += 1;
      tempvar_list = realloc(tempvar_list, tempvar_count * sizeof(metabliti));
      strcpy(tempvar_list[tempvar_count - 1].onoma, str); 
  }

  void cleartempvar() {
      tempvar_count = 0;
      tempvar_list = calloc(1, sizeof(metabliti));
  }

  void newvar(char* str) {
      var_count += 1;
      var_list = realloc(var_list, var_count * sizeof(metabliti));
      strcpy(var_list[var_count - 1].onoma, str);
  }

  int foundvar(char* str){
      int flag = 0;
      for (int i = 0; i < var_count; i++){
          if (!strcmp(str, var_list[i].onoma)){
            flag = 1;
            return flag;
          }
      }
      return flag;
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
main: program list_structs list_function startmain {
    
}
    | program list_function startmain {

    }
    | program list_structs startmain {

    }
    | program startmain {

    }
    | program {
        
    }     
;

program: PROGRAM STRING{

}
;

list_structs: list_structs structs
    | structs
;

structs: STRUCT STRING vars ENDSTRUCT
    | TYPEDEF STRUCT STRING vars STRING ENDSTRUCT{
        if (!foundstruct($3)) {
            newstruct($3);
        } else {
            printf("\n\n [LINE %d] Struct \"%s\" was already defined\n\n", yylineno, $3);
            exit(1);
        }
    }
;

vars: VARS vars_list{
    for (int i = 0; i < tempvar_count; i++) {
        if (!foundvar(tempvar_list[i].onoma)) {
            newvar(tempvar_list[i].onoma);
        } else {
            printf("\n[LINE %d] Variable \"%s\" already defined\n", yylineno, tempvar_list[i].onoma);
            exit(1);
        }
    }
    cleartempvar();
}
;

vars_list: CHAR string_list Q_MARK vars_list{

}
    | INTEGER string_list Q_MARK vars_list {

    }
    | CHAR string_list Q_MARK
    | INTEGER string_list Q_MARK
;

string_list: STRING A_BRACKET THETIKOS_AKER D_BRACKET KOMMA string_list {
        tempvar($1);
    }
    | STRING KOMMA string_list {
        tempvar($1);
    }
    | STRING A_BRACKET THETIKOS_AKER D_BRACKET {
        tempvar($1);
    }
    | STRING {
        tempvar($1);
    }
;

list_function: list_function function
    | function
;

function: FUNCTION STRING A_PARENTHESI string_list D_PARENTHESI vars entoles return END_FUNCTION {
        if(!foundvar($2)) {
            newvar($2);
        } else {
            printf("[LINE %d] Function \"%s\" already declared\n", yylineno, $2);
            exit(1);
        }
        cleartempvar();
    }
    | FUNCTION STRING A_PARENTHESI D_PARENTHESI vars entoles return END_FUNCTION {
        if(!foundvar($2)) {
            newvar($2);
        } else {
            printf("[LINE %d] Function \"%s\" already declared\n", yylineno, $2);
            exit(1);
        }
        cleartempvar();
    }
    | FUNCTION STRING A_PARENTHESI string_list D_PARENTHESI entoles return END_FUNCTION {
        if(!foundvar($2)) {
            newvar($2);
        } else {
            printf("[LINE %d] Function \"%s\" already declared\n", yylineno, $2);
            exit(1);
        }
        cleartempvar();
    }
    | FUNCTION STRING A_PARENTHESI D_PARENTHESI entoles return END_FUNCTION {
        if(!foundvar($2)) {
            newvar($2);
        } else {
            printf("[LINE %d] Function \"%s\" already declared\n", yylineno, $2);
            exit(1);
        }
        cleartempvar();
    }
;

return: RETURN THETIKOS_AKER Q_MARK
    | RETURN STRING Q_MARK
;

list_entoles: list_entoles entoles
    | entoles
;

entoles: anathesi
    | while
    | for
    | if
    | switch 
    | print 
    | break 
;

print: PRINT A_PARENTHESI ARIST STRING ARIST D_PARENTHESI Q_MARK
    | PRINT A_PARENTHESI ARIST STRING ARIST KOMMA string_list Q_MARK {
        for (int i = 0; i < tempvar_count; i++) {
            if (!foundvar(tempvar_list[i].onoma)) {
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno, tempvar_list[i].onoma);
                exit(1);
            }
        }
        cleartempvar();
    }
;

break: BREAK Q_MARK
;

anathesi: STRING EQUALS prajeis Q_MARK {
    if (!foundvar($1)) { 
        printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$1);
        exit(1);
    }
}
;

prajeis:  prajeis ADD prajeis
        | prajeis SUBTRACT prajeis
        | prajeis MULTIPLY prajeis
        | prajeis DIVIDE prajeis
        | prajeis POWER_OF prajeis
        | A_PARENTHESI prajeis D_PARENTHESI
        | STRING ADD prajeis {
            if (!foundvar($1)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$1);
                exit(1);
            }
        }
        | THETIKOS_AKER ADD prajeis
        | STRING SUBTRACT prajeis {
            if (!foundvar($1)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$1);
                exit(1);
            }
        }
        | THETIKOS_AKER SUBTRACT prajeis
        | STRING MULTIPLY prajeis {
            if (!foundvar($1)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$1);
                exit(1);
            }
        }
        | THETIKOS_AKER MULTIPLY prajeis
        | STRING DIVIDE prajeis {
            if (!foundvar($1)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$1);
                exit(1);
            }
        }
        | THETIKOS_AKER DIVIDE prajeis
        | STRING POWER_OF prajeis {            
            if (!foundvar($1)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$1);
                exit(1);
            }
        }
        | THETIKOS_AKER POWER_OF prajeis
        | STRING {    
            if (!foundvar($1)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$1);
                exit(1);
            }
        }
        | STRING A_PARENTHESI string_list D_PARENTHESI {
            if (!foundvar($1)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$1);
                exit(1);
            }
            for (int i = 0; i < tempvar_count; i++) {
                if (!foundvar(tempvar_list[i].onoma)) {
                    printf("[LINE %d] Variable \"%s\" not declared\n", yylineno, tempvar_list[i].onoma);
                    exit(1);
                }
                cleartempvar();
            }
        }
        | STRING A_PARENTHESI D_PARENTHESI {
            if (!foundvar($1)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$1);
                exit(1);
            }
        }
        | THETIKOS_AKER
;

while: WHILE condition list_entoles ENDWHILE {
    
}  
;

for: FOR STRING COLON EQUALS THETIKOS_AKER TO THETIKOS_AKER STEP THETIKOS_AKER list_entoles ENDFOR{
            if (!foundvar($2)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$2);
                exit(1);
            }
        }
;

list_elseif: list_elseif elseif
    | elseif
;

elseif: ELSEIF condition list_entoles
;

if: IF condition THEN list_entoles ENDIF
    | IF condition THEN list_entoles ELSE list_entoles ENDIF
    | IF condition THEN list_entoles list_elseif ENDIF
    | IF condition THEN list_entoles list_elseif ELSE list_entoles ENDIF
;

list_case: list_case case
    | case
;

case: CASE prajeis COLON list_entoles
;

switch: SWITCH prajeis list_case DEFAULT COLON list_entoles ENDSWITCH{

}
    | SWITCH prajeis list_case ENDSWITCH{

    }
;

and_or: AND 
    | AND and_or
    | OR
    | OR and_or
;

condition: A_PARENTHESI STRING BIGGER_THAN THETIKOS_AKER D_PARENTHESI {
            if (!foundvar($2)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$2);
                exit(1);
            }
        }
    | A_PARENTHESI STRING BIGGER_THAN THETIKOS_AKER D_PARENTHESI and_or condition {
            if (!foundvar($2)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$2);
                exit(1);
            }
        }
    | A_PARENTHESI STRING BIGGER_THAN STRING D_PARENTHESI {
            if (!foundvar($2)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$2);
                exit(1);
            }
            if (!foundvar($4)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$4);
                exit(1);
            }
        }
    | A_PARENTHESI STRING BIGGER_THAN STRING D_PARENTHESI and_or condition {
            if (!foundvar($2)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$2);
                exit(1);
            }
            if (!foundvar($4)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$4);
                exit(1);
            }
        }
    | A_PARENTHESI STRING SMALLER_THAN THETIKOS_AKER D_PARENTHESI {
            if (!foundvar($2)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$2);
                exit(1);
            }
        }
    | A_PARENTHESI STRING SMALLER_THAN THETIKOS_AKER D_PARENTHESI and_or condition {
            if (!foundvar($2)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$2);
                exit(1);
            }
        }  
    | A_PARENTHESI STRING SMALLER_THAN STRING D_PARENTHESI {
            if (!foundvar($2)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$2);
                exit(1);
            }
        }
    | A_PARENTHESI STRING SMALLER_THAN STRING D_PARENTHESI and_or condition {
            if (!foundvar($2)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$2);
                exit(1);
            }
        }
    | A_PARENTHESI STRING LOG_EQUALS THETIKOS_AKER D_PARENTHESI {
            if (!foundvar($2)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$2);
                exit(1);
            }
        }
    | A_PARENTHESI STRING LOG_EQUALS THETIKOS_AKER D_PARENTHESI and_or condition {
            if (!foundvar($2)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$2);
                exit(1);
            }
        }
    | A_PARENTHESI STRING LOG_EQUALS STRING D_PARENTHESI {
            if (!foundvar($2)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$2);
                exit(1);
            }
            if (!foundvar($4)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$4);
                exit(1);
            }
        }
    | A_PARENTHESI STRING LOG_EQUALS STRING D_PARENTHESI and_or condition {
            if (!foundvar($2)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$2);
                exit(1);
            }
            if (!foundvar($4)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$4);
                exit(1);
            }
        }
    | A_PARENTHESI STRING NOT_EQUAL THETIKOS_AKER D_PARENTHESI {
            if (!foundvar($2)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$2);
                exit(1);
            }
        }
    | A_PARENTHESI STRING NOT_EQUAL THETIKOS_AKER D_PARENTHESI and_or condition {
            if (!foundvar($2)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$2);
                exit(1);
            }
        }
    | A_PARENTHESI STRING NOT_EQUAL STRING D_PARENTHESI {
            if (!foundvar($2)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$2);
                exit(1);
            }
            if (!foundvar($4)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$4);
                exit(1);
            }
        }
    | A_PARENTHESI STRING NOT_EQUAL STRING D_PARENTHESI and_or condition {
            if (!foundvar($2)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$2);
                exit(1);
            }
            if (!foundvar($4)) { 
                printf("[LINE %d] Variable \"%s\" not declared\n", yylineno ,$4);
                exit(1);
            }
        }
    | A_PARENTHESI condition D_PARENTHESI
;

startmain: STARTMAIN vars list_entoles ENDMAIN
    | STARTMAIN list_entoles ENDMAIN
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
  structs_list = malloc(1 * sizeof(metabliti));

  tempvar_count = 0;
  tempvar_list = malloc(1 * sizeof(metabliti));

  var_count = 0;
  var_list = malloc(1 * sizeof(metabliti));

  yyin = myfile;
  
  yyparse();

  printf("===== END =====\n\n");
  for (int i = 0; i < structs_count; i++) {
      printf("[STRUCT] %d -- %s\n", i, structs_list[i].onoma);
  }
  for (int i = 0; i < var_count; i++) {
      printf("[VAR]    %d -- %s\n", i, var_list[i].onoma);
  }
}

void yyerror(const char *s) {
  
  return;
}