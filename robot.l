%x ER_MANUTENCAO ER_BATERIA ER_ENTREGA ER_RECOLHE ER_ESTADO

%{
  #include "robot.tab.h"
%}

MANUTENCAO MANUTEN"Ç"AO
CARREGA-BATERIA CARREGA"-"BATERIA
ENTREGA ENTREGA 
RECOLHE RECOLHE 
ESTADO ESTADO


%%

{INICIO}       return INICIO;
{FIM}         return FIM;

{MANUTENCAO}\( {BEGIN(ER_MANUTENCAO); return INICIO_MANUTENCAO;}
<ER_MANUTENCAO>([0-2]) {    yylval.inteiro=atoi(yytext); return _MANUTENCAO;
}
<ER_MANUTENCAO>\) {BEGIN 0; return FIM_MANUTENCAO;}


{CARREGA-BATERIA}\( {BEGIN(ER_BATERIA); return INICIO_BATERIA;}
<ER_BATERIA>([0-2]) {        yylval.inteiro=atoi(yytext); return _BATERIA;
}
<ER_BATERIA>\) {BEGIN 0; return FIM_BATERIA;}


{RECOLHE}\( {BEGIN(ER_RECOLHE); return INICIO_RECOLHE;}
<ER_RECOLHE>(\([A-Za-z0-9]{5},[1-9][0-9]*\)(,\([A-Za-z0-9]{5},[1-9][0-9]*\))*) { yylval.inteiro=atoi(yytext); return _RECOLHE;
}
<ER_RECOLHE>\) {BEGIN 0; return FIM_RECOLHE;}


{ENTREGA}\( {BEGIN(ER_ENTREGA); return INICIO_ENTREGA;}
<ER_ENTREGA>([A-Z]{2}(([0-9]){3}|100),[A-Za-z0-9]{5},[1-9][0-9]*) { yylval.inteiro=atoi(yytext); return _ENTREGA;
}
<ER_ENTREGA>\) {BEGIN 0; return FIM_ENTREGA;}


{ESTADO}\( BEGIN(ER_ESTADO);
<ER_ESTADO>([BTM]|<ER_ESTADO>[BTM],[BTM],[BTM]|<ER_ESTADO>[BTM],[BTM]) { yylval.inteiro=atoi(yytext); return _ESTADO;
}
<ER_ESTADO>\) {BEGIN 0; return FIM_ESTADO;}


(","|")"|"{"|"}")    return yytext[0];
[/t ]	;
.	;

%%