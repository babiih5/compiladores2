%x ER_MANUTENCAO ER_BATERIA ER_ENTREGA ER_RECOLHE ER_ESTADO


%{
    #include <stdio.h>
    #include <math.h>

    int manutencao=2, estado_bateria=2, quantidade=0, num_manutencao=0,tarefas=0,perc_bateria, quantidades[80], numrec=0;
    char *instrucao="", *posicao="Posto de Carregamento", *linha="", *quant_str="", *material="", *id_estado="",*aux_material="";


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
<ER_ENTREGA>([A-Z]{2}([1-9][0-9]?|100),[A-Za-z0-9]{5},[1-9][0-9]*) {    linha = strtok(yytext, ",");
                                                                        material = strtok(NULL, ",");
                                                                        quant_str = strtok(NULL, ")");
                                                                        
                                                                        quantidade=atoi(quant_str);

                                                                        
                                                                        printf("%s\n",linha);
                                                                        printf("%s\n",material);
                                                                        printf("%d\n", quantidade);

                                                                    }

<ER_ENTREGA>\) BEGIN 0;


{RECOLHE}\[ BEGIN(ER_RECOLHE);
<ER_RECOLHE>(\([A-Za-z0-9]{5},[1-9][0-9]*\)(,\([A-Za-z0-9]{5},[1-9][0-9]*\))*)   {  aux_material = strtok(yytext, ",");
                                                                                    material = aux_material + 1;

                                                                                    quant_str = strtok(NULL, ")");
                                                                                    quantidade=atoi(quant_str);

                                                                                    printf("%s\n",material);
                                                                                    printf("%d\n", quantidade);
                                                                       
                                                                        
                                                                        }
                                                                        

                                                                        
                                                                       
<ER_RECOLHE>\] BEGIN 0;


{ESTADO}\( BEGIN(ER_BATERIA);
<ER_ESTADO>([BTM]|[BTM],[BTM],[BTM]|[BTM],[BTM]) {  



                                                }




<ER_ESTADO>\) BEGIN 0; 
%%





int main (void){
     yylex();
    printf("\n%s \n\n", posicao);
}