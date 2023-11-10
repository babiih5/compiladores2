%x ER_MANUTENCAO ER_BATERIA ER_ENTREGA ER_RECOLHE 


%{
    #include <stdio.h>
    #include <math.h>

    int manutencao=2, estado_bateria=2, quantidade=0, num_manutencao=0,tarefas=0,perc_bateria;
    char *materiais="", *instrucao="", *posicao="Posto de Carregamento", *linha="";


%}


MANUTENCAO MANUTEN"Ç"AO
CARREGA-BATERIA CARREGA"-"BATERIA
ENTREGA ENTREGA 
RECOLHE RECOLHE 
ESTADO ESTADO 


%%
{MANUTENCAO}\( BEGIN(ER_MANUTENCAO);
<ER_MANUTENCAO>([0-2]) {    manutencao = atoi(yytext);
                            if (manutencao==0){
                                posicao="Posto de Manutencao";
                            }
                            else if (manutencao==1){
                                if (tarefas==0){
                                    posicao="Posto de Manutencao";
                                }

                            }


                         }


<ER_MANUTENCAO>\) BEGIN 0;


{CARREGA-BATERIA}\( BEGIN(ER_BATERIA);
<ER_BATERIA>([0-2]) {    estado_bateria = atoi(yytext);
                            if (estado_bateria==0){
                                posicao="Posto de Carregamento";
                            }
                            else if (estado_bateria==1){
                                if (tarefas==0){
                                    posicao="Posto de Carregamento";
                                }

                            }


                         }


<ER_BATERIA>\) BEGIN 0;

{ENTREGA}\( BEGIN(ER_ENTREGA);
<ER_ENTREGA>([A-Z]{2}([1-9][0-9]?|100),[A-Za-z0-9]{5},[1-9][0-9]*) {   *linha = atoi(yytext);
                                                                        *materiais = atoi(yytext);
                                                                        quantidade=atoi(yytext);

                                                                        
                                                                        printf("%s",linha);
                                                                        printf("%s",materiais);
                                                                        printf("%d", quantidade);

                                                                    }

<ER_ENTREGA>\) BEGIN 0;

{RECOLHE}\( BEGIN(ER_ENTREGA);
<ER_RECOLHE>(\[\([A-Za-z0-9]{5},[1-9][0-9]*\)+\])                   {   *linha = atoi(yytext);
                                                                        *materiais = atoi(yytext);
                                                                        quantidade=atoi(yytext);

                                                                        
                                                                        printf("%s",linha);
                                                                        printf("%s",materiais);
                                                                        printf("%d", quantidade);

                                                                    }

<ER_RECOLHE>\) BEGIN 0;


%%





int main (void){
     yylex();
    printf("\n%s \n\n", posicao);
    printf("%s",materiais);
}