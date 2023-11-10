%x ER_MANUTENCAO ER_BATERIA ER_ENTREGA ER_RECOLHE ER_ESTADO


%{
    #include <stdio.h>
    #include <math.h>
    #include <string.h>

    int manutencao=2, estado_bateria=2, quantidade=0, num_manutencao=0, tarefas=0, perc_bateria;
    char *instrucao="", *posicao="Posto de Carregamento", *linha="", *quant_str="", *material_entrega="", *material_carro="", *id_estado="",*aux_material="", *aux_estado="";


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
                                                                        material_entrega = strtok(NULL, ",");
                                                                        quant_str = strtok(NULL, ")");
                                                                        
                                                                        quantidade=atoi(quant_str);

                                                                        
                                                                        printf("linha de montagem: %s\n",linha);
                                                                        printf("Material: %s\n",material_entrega);
                                                                        printf("Quantidade: %d\n", quantidade);

                                                                        quantidade = 0;
                                                                        material_carro = "";
                                                                        tarefas = 0;

                                                                    }

<ER_ENTREGA>\) BEGIN 0;


{RECOLHE}\[ BEGIN(ER_RECOLHE);
<ER_RECOLHE>(\([A-Za-z0-9]{5},[1-9][0-9]*\)(,\([A-Za-z0-9]{5},[1-9][0-9]*\))*)   {  aux_material = strtok(yytext, ",");
                                                                                    material_carro = aux_material + 1;

                                                                                    quant_str = strtok(NULL, ")");
                                                                                    quantidade=atoi(quant_str);

                                                                                    printf("Material: %s\n",material_carro);
                                                                                    printf("Quantidade: %d\n", quantidade);
                                                                                    
                                                                                    tarefas = tarefas + 1;
                                                                                    
                                                                                    
                                                                       
                                                                        
                                                                        }
                                                                        

                                                                        
                                                                       
<ER_RECOLHE>\] BEGIN 0;


{ESTADO}\( BEGIN(ER_ESTADO);
<ER_ESTADO>([BTM]|<ER_ESTADO>[BTM],[BTM],[BTM]|<ER_ESTADO>[BTM],[BTM]) {  aux_estado = yytext;

                                                    if (strcmp(aux_estado, "B") == 0){
                                                        printf("Bateria: %d \n", estado_bateria);
                                                    }
                                                    else if (strcmp(aux_estado, "T") == 0){
                                                        printf("Tarefas pendentes: %d \n", tarefas);
                                                    }
                                                    else if (strcmp(aux_estado, "M") == 0){
                                                        printf("Materiais: %s \nQuantidade: %d \n", quantidade);
                                                    }



                                                }




<ER_ESTADO>\) BEGIN 0; 

%%





int main (void){
     yylex();
    printf("\nLocalização: %s \n\n", posicao);
    
}