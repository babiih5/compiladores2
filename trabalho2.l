%x ER_MANUTENCAO ER_BATERIA ER_ENTREGA ER_RECOLHE ER_ESTADO


%{
    #include <stdio.h>
    #include <math.h>
    #include <string.h>

    int manutencao=2, estado_bateria=2, quantidade=0, num_manutencao=0, tarefas=0, total_quantidade=0;
    char *instrucao="", *posicao="Posto de Carregamento", *linha="", *quant_str="", *material_entrega="", *material_carro="",*material_recolha="",*aux_material="", *aux_estado="", *total_materiais="";
    float perc_bateria=100.0,aux_quant=0.0,bateria_necessaria=0.0;

%}


MANUTENCAO MANUTEN"Ç"AO
CARREGA-BATERIA CARREGA"-"BATERIA
ENTREGA ENTREGA 
RECOLHE RECOLHE 
ESTADO ESTADO 


%%
{MANUTENCAO}\( BEGIN(ER_MANUTENCAO);
<ER_MANUTENCAO>([0-2]) {    manutencao = atoi(yytext);


                            if (posicao != "Posto de Manutencao"){
                                perc_bateria= perc_bateria - (100*0.1) - (total_quantidade*0.01);
                            }
                            

                            if (manutencao==0){
                                posicao="Posto de Manutencao";
                                num_manutencao = num_manutencao + 1;
                                manutencao=2;
                            }
                            else if (manutencao==1){
                                if (tarefas==0){
                                    posicao="Posto de Manutencao";
                                    num_manutencao = num_manutencao + 1;
                                    manutencao=2;
                                }

                            }

                            if (num_manutencao >= 3) {
                                if (num_manutencao==3){
                                    printf("\nAtencao! O veículo foi chamado a manutencao 3 vezes");
                                }
                                
                                else if ((num_manutencao % 3) == 0) {
                                    printf("\nAtencao! O veiculo foi chamado a manutencao %d vezes", num_manutencao);
                                }
                            }

                            printf("\n----------------------------------");
                            printf("\nEstado da Bateria: %d ", estado_bateria);
                            printf("\nLocalização: %s", posicao);
                            printf("\nMateriais: %s", material_carro);
                            printf("\nQuantidade: %d", total_quantidade);
                            printf("\nVezes que foi a manutencao: %d", num_manutencao);
                            printf("\n----------------------------------\n\n");

                         }


<ER_MANUTENCAO>\) BEGIN 0;


{CARREGA-BATERIA}\( BEGIN(ER_BATERIA);
<ER_BATERIA>([0-2]) {        estado_bateria = atoi(yytext);

                            if (perc_bateria == 100) {
                                printf("\nA bateria está completamente carregada, não é necessário um novo carregamento");
                            }

                            if (posicao != "Posto de Carregamento"){
                                perc_bateria= perc_bateria - (100*0.1) - (total_quantidade*0.01);
                            }

                            if (estado_bateria==0){
                                posicao="Posto de Carregamento";
                                perc_bateria=100;
                                estado_bateria=2;
                                
                            }
                            else if (estado_bateria==1){
                                if (tarefas==0){
                                    posicao="Posto de Carregamento";
                                    perc_bateria=100;
                                    estado_bateria=2;
                                }

                            }
                            printf("\n----------------------------------");
                            printf("\nEstado da Bateria: %d ", estado_bateria);
                            printf("\nLocalização: %s", posicao);
                            printf("\nMateriais: %s", material_carro);
                            printf("\nQuantidade: %d", total_quantidade);
                            printf("\nVezes que foi a manutencao: %d", num_manutencao);
                            printf("\n----------------------------------\n\n");



                         }


<ER_BATERIA>\) BEGIN 0;


{RECOLHE}\[ BEGIN(ER_RECOLHE);
<ER_RECOLHE>(\([A-Za-z0-9]{5},[1-9][0-9]*\)(,\([A-Za-z0-9]{5},[1-9][0-9]*\))*)   {  

                                                                                    aux_material = strtok(yytext, ",");

                                                                                    quant_str = strtok(NULL, ")");
                                                                                    quantidade=atoi(quant_str);
                                                                                    aux_quant=total_quantidade;

                                                                                    if (total_quantidade + quantidade > 80) {
                                                                                        printf("\nAtencao! Excedeu a capacidade do veiculo, impossivel realizar o transporte");
                                                                                    } 
                                                                                    else{
                                                                                        if (posicao != "Armazem"){
                                                                                        bateria_necessaria= (100*0.1) + (aux_quant*0.01);
                                                                                        }
                                                                                        else{
                                                                                            bateria_necessaria=0;
                                                                                        }
    
                                                                                        if (perc_bateria >= 10.8 && perc_bateria <= 21.6){
                                                                                            estado_bateria=0;
                                                                                        }
                                                                                        else if(perc_bateria > 21.6 && perc_bateria <= 32.4){
                                                                                            estado_bateria=1;
                                                                                        }
                                                                                        else if(perc_bateria > 32.4){
                                                                                            estado_bateria=2;
                                                                                        }
        

                                                                                        if (estado_bateria==0){
                                                                                            printf("\nAtencao! Bateria insuficiente, por favor enviar para o posto de carregamento!");
                                                                                        }
                                                                                        else if(estado_bateria==1 || estado_bateria==2){
                                                                                            if (estado_bateria==1){
                                                                                                printf("\nNo final desta acao, a bateria será insuficiente. Por favor, enviar para o posto de carregamento");
                                                                                            }

                                                                                            material_recolha = aux_material;
                                                                                            material_recolha++;

                                                                                            printf("\nMaterial: %s",material_recolha);
                                                                                            printf("\nQuantidade: %d", quantidade);

                                                                                            if (posicao != "Armazem"){
                                                                                                perc_bateria= perc_bateria - (100*0.1) - (total_quantidade*0,01);
                                                                                            }
                                                                                            
                                                                                            posicao = "Armazem";

                                                                                            if(tarefas>0){
                                                                                                total_quantidade = total_quantidade + quantidade;
                                                                                                material_carro = strdup(material_recolha);

                                                                                            }
                                                                                            else if (tarefas == 0) {
                                                                                                total_quantidade = quantidade;
                                                                                                tarefas = tarefas + 1;
                                                                                                material_carro = strdup(material_recolha);

                                                                                            }
                                                                                            

                                                                                        }

                                                                                    }

                                                                                    printf("\n----------------------------------");
                                                                                    printf("\nEstado da Bateria: %d ", estado_bateria);
                                                                                    printf("\nLocalização: %s", posicao);
                                                                                    printf("\nMateriais: %s", material_carro);
                                                                                    printf("\nQuantidade: %d", total_quantidade);
                                                                                    printf("\nVezes que foi a manutencao: %d", num_manutencao);
                                                                                    printf("\n----------------------------------\n\n");

                                                                                }
                                                                        

                                                                        
                                                                       
<ER_RECOLHE>\] BEGIN 0;

{ENTREGA}\( BEGIN(ER_ENTREGA);
<ER_ENTREGA>([A-Z]{2}([1-9][0-9]?|100),[A-Za-z0-9]{5},[1-9][0-9]*) {   
                                                                        linha = strtok(yytext, ",");
                                                                        material_entrega = strtok(NULL, ",");
                                                                        quant_str = strtok(NULL, ")");
                                                                        quantidade=atoi(quant_str);
                                                                        aux_quant=total_quantidade;

                                                                        if (total_quantidade < quantidade) {
                                                                            printf("\nAtencao! Esta quantidade de material nao esta a ser transportada, impossivel realizar a entrega!");
                                                                        }
                                                                        else if (strcmp(material_carro, material_entrega) != 0) {
                                                                            printf("\nAtencao! Este tipo de material nao esta a ser transportado, impossivel realizar a entrega!");
                                                                        }
                                                                        else{

                                                                            if (posicao != "Linhas de Montagem"){
                                                                            bateria_necessaria= (100*0.1) + (aux_quant*0.01);

                                                                                if (perc_bateria >= 10.8 && perc_bateria <= 21.6){
                                                                                    estado_bateria=0;
                                                                                }
                                                                                else if(perc_bateria > 21.6 && perc_bateria <= 32.4){
                                                                                    estado_bateria=1;
                                                                                }
                                                                                else if(perc_bateria > 32.4){
                                                                                    estado_bateria=2;
                                                                                }
                                                                            }

                                                                            else{
                                                                                bateria_necessaria=(100*0.05)+(total_quantidade*0.01);

                                                                                if (perc_bateria >= 10.8 && perc_bateria <= 16.6){
                                                                                    estado_bateria=0;
                                                                                }
                                                                                else if(perc_bateria > 16.6 && perc_bateria <= 22.4){
                                                                                    estado_bateria=1;
                                                                                }
                                                                                else if(perc_bateria > 22.4){
                                                                                    estado_bateria=2;
                                                                                }

                                                                            }
                                                                        

                                                                        if (estado_bateria==0){
                                                                            printf("\nAtencao! Bateria insuficiente, por favor enviar para o posto de carregamento!");
                                                                        }
                                                                        else if(estado_bateria==1 || estado_bateria==2){

                                                                            if (estado_bateria==1){
                                                                                printf("\nNo final desta acao, a bateria será insuficiente. Por favor, enviar para o posto de carregamento");
                                                                            }

                                                                            total_quantidade = total_quantidade - quantidade;

                                                                            if (posicao != "Linhas de Montagem"){
                                                                                perc_bateria= perc_bateria - (100*0.1) - (total_quantidade*0.01);
                                                                            }
                                                                            else{
                                                                                perc_bateria= perc_bateria - (100*0.05)-(total_quantidade*0.01);
                                                                            }


                                                                            printf("\nLinha de montagem: %s",linha);
                                                                            printf("\nMaterial: %s",material_entrega);
                                                                            printf("\nQuantidade: %d", quantidade);

                                                                            posicao = "Linhas de Montagem";

                                                                            if (total_quantidade == 0){
                                                                                material_carro = "";
                                                                                tarefas = tarefas - 1;
                                                                            }
                                                                            else {
                                                                                material_carro = "";
                                                                                material_carro = material_entrega;
                                                                                }

                                                                            
                                                                        }
                                                                                                                                               
                                                                        printf("\n----------------------------------");
                                                                        printf("\nEstado da Bateria: %d ", estado_bateria);
                                                                        printf("\nLocalização: %s", posicao);
                                                                        printf("\nMateriais: %s", material_carro);
                                                                        printf("\nQuantidade: %d", total_quantidade);
                                                                        printf("\nVezes que foi a manutencao: %d", num_manutencao);
                                                                        printf("\n----------------------------------\n\n");


                                                                        }
                                                                    }

<ER_ENTREGA>\) BEGIN 0;

{ESTADO}\( BEGIN(ER_ESTADO);
<ER_ESTADO>([BTM]|<ER_ESTADO>[BTM],[BTM],[BTM]|<ER_ESTADO>[BTM],[BTM]) {    aux_estado = yytext;

                                                                            if (strcmp(aux_estado, "B") == 0){
                                                                                printf("\nBateria: %d", estado_bateria);
                                                                            }
                                                                            else if (strcmp(aux_estado, "T") == 0){
                                                                                printf("\nTarefas pendentes: %d", tarefas);
                                                                            }
                                                                            else if (strcmp(aux_estado, "M") == 0){
                                                                                printf("\nMateriais: %s",material_carro);
                                                                                printf("\nQuantidade: %d", total_quantidade);

                                                                            }


                                                                        }



<ER_ESTADO>\) BEGIN 0; 

%%





int main (void){
     yylex();
     printf("\n----------------------------------\n");
     printf("ESTADO FINAL DO VEICULO\n");
     printf("Estado da Bateria: %d \n", estado_bateria);
     printf("Localização: %s \n", posicao);
     printf("Materiais: %s \n", material_carro);
     printf("Quantidade: %d \n", total_quantidade);
     printf("Vezes que foi a manutencao: %d \n", num_manutencao);
     printf("----------------------------------\n\n");
    
}