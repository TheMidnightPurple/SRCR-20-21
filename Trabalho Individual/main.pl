% Dados para a base de conhecimento obtidos pelo parser
:- include('pontosRecolha').

% ficheiro com algoritmos de procura não informada
:- include('procuraNaoInformada').

% ficheiro com algoritmos de procura não informada
:- include('procuraInformada').

% ficheiro com predicados auxiliares
:- include('predicadosAuxiliares').

%(1) Gerar os circuitos de recolha tanto indiferenciada como seletiva, caso existam, que cubram um determinado território
%--Não-Informada
%--depth-First
circuitosRecolha_Depth(Territorio) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    findall(Path, depthFirst(NodoInicial, NodoFinal, Path), Caminho),
    escrever(Caminho).

%--breath-First
circuitosRecolha_Breadth(Territorio) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    findall(Path, breadthFirst(NodoInicial, NodoFinal, Path), Caminho),
    escrever(Caminho).

%--profundidadeIterativa
circuitosRecolha_DepthLimited(Territorio, Nivel) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    findall(Path, depthFirstLimited(NodoInicial, NodoFinal, Nivel, Path), Caminho),
    escrever(Caminho).


%--Informada
%--Gulosa
circuitosRecolha_Gulosa(Territorio) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    findall(Path, gulosaSearch(NodoInicial, NodoFinal, Path), Caminho),
    escrever(Caminho).

%--Gulosa
circuitosRecolha_Astar(Territorio) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    findall(Path, astarSearch(NodoInicial, NodoFinal, Path), Caminho),
    escrever(Caminho).


%(2) Identificar  quais os  circuitos  com mais  pontos  de  recolha  (por  tipo  de  resíduo  a recolher)
maisPontosRecolha(Paths, C, NumeroPontosRecolha) :-
    maisPontos(Paths, [], 0, C, NumeroPontosRecolha).

maisPontos([], Caminho, NumeroPontosRecolha, Caminho, NumeroPontosRecolha).
maisPontos([P|Caminhos], MelhorCaminhoAtual, MaiorNrPontosRecolhaAtual, Caminho, NumeroPontosRecolha) :-
    length(P, Tamanho),
    Tamanho > MaiorNrPontosRecolhaAtual,
    maisPontos(Caminhos, P, Tamanho, Caminho, NumeroPontosRecolha).
maisPontos([P|Caminhos], MelhorCaminhoAtual, MaiorNrPontosRecolhaAtual, Caminho, NumeroPontosRecolha) :-
    length(P, Tamanho),
    Tamanho =< MaiorNrPontosRecolhaAtual,
    maisPontos(Caminhos, MelhorCaminhoAtual, MaiorNrPontosRecolhaAtual, Caminho, NumeroPontosRecolha).

restringeTipo([],_,[]).
restringeTipo([Caminho1], TipoLixo ,[Caminho1]) :- 
    temTipo(Caminho1, TipoLixo, Bool),
    Bool == 1, !.
restringeTipo([Caminho1|Caminhos], TipoLixo, [Caminho1|Solucao]) :-
    temTipo(Caminho1, TipoLixo, Bool),
    Bool == 1, !,
    restringeTipo(Caminhos, TipoLixo, Solucao).
restringeTipo([_|Caminhos], TipoLixo, Solucao) :-
    restringeTipo(Caminhos, TipoLixo, Solucao).

temTipo([], _, B) :- B is 1.
temTipo(_,'Garagem',B) :- B is 1.
temTipo(_,'Deposito',B) :- B is 1.
temTipo([Nodo|RestoNodos], TipoLixo, Bool) :-
    findall(Tipo, pontoRecolha(_,_,_,_,Nodo,Tipo,_), Solucao),
    existeTipo(Solucao, TipoLixo, B),
    B == 1,
    temTipo(RestoNodos, TipoLixo, Bool).

existeTipo([],_,0) :- !.
existeTipo([A|B], Tipo, Bool) :-
    A == Tipo,
    Bool is 1, !.
existeTipo([A|B], Tipo, Bool) :-
    A == 'Garagem',
    Bool is 1, !.
existeTipo([A|B], Tipo, Bool) :-
    A == 'Deposito',
    Bool is 1, !.
existeTipo([A|B], Tipo, Bool) :-
    A \= Tipo,
    existeTipo(B, Tipo, Bool).

%--Não-Informada
%--depth-First
circuitoMaisPontosRecolha_Depth(Territorio, TipoLixo) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    findall(Path, depthFirst(NodoInicial, NodoFinal, Path), Solucao),
    restringeTipo(Solucao, TipoLixo, SolucaoFiltrada),
    maisPontosRecolha(SolucaoFiltrada, Caminho, NrNodos), !, 
    write('\nMelhor Caminho: '),
    write(Caminho),
    write('\nNumero de Pontos de Recolha: '),
    write(NrNodos),
    write(' Pontos de Recolha.').
%--breadth-First
circuitoMaisPontosRecolha_Breadth(Territorio, TipoLixo) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    findall(Path, breadthFirst(NodoInicial, NodoFinal, Path), Solucao),
    restringeTipo(Solucao, TipoLixo, SolucaoFiltrada),
    maisPontosRecolha(SolucaoFiltrada, Caminho, NrNodos), !, 
    write('\nMelhor Caminho: '),
    write(Caminho),
    write('\nNumero de Pontos de Recolha: '),
    write(NrNodos),
    write(' Pontos de Recolha.').

%--profundidadeIterativa
circuitoMaisPontosRecolha_DepthLimited(Territorio, TipoLixo, Nivel) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    findall(Path, depthFirstLimited(NodoInicial, NodoFinal, Nivel, Path), Solucao),
    restringeTipo(Solucao, TipoLixo, SolucaoFiltrada),
    maisPontosRecolha(SolucaoFiltrada, Caminho, NrNodos), !, 
    write('\nMelhor Caminho: '),
    write(Caminho),
    write('\nNumero de Pontos de Recolha: '),
    write(NrNodos),
    write(' Pontos de Recolha.').

%--Informada
%--Gulosa
circuitoMaisPontosRecolha_Gulosa(Territorio, TipoLixo) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    findall(Path, gulosaSearch(NodoInicial, NodoFinal, Path), Solucao),
    restringeTipo(Solucao, TipoLixo, SolucaoFiltrada),
    maisPontosRecolha(SolucaoFiltrada, Caminho, NrNodos), !, 
    write('\nMelhor Caminho: '),
    write(Caminho),
    write('\nNumero de Pontos de Recolha: '),
    write(NrNodos),
    write(' Pontos de Recolha.').

%--Astar
circuitoMaisPontosRecolha_Astar(Territorio, TipoLixo) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    findall(Path, astarSearch(NodoInicial, NodoFinal, Path), Solucao),
    restringeTipo(Solucao, TipoLixo, SolucaoFiltrada),
    maisPontosRecolha(SolucaoFiltrada, Caminho, NrNodos), !, 
    write('\nMelhor Caminho: '),
    write(Caminho),
    write('\nNumero de Pontos de Recolha: '),
    write(NrNodos),
    write(' Pontos de Recolha.').

%(3) Comparar circuitos de recolha tendo em conta os indicadores de produtividade;
maiorLixoRecolhido(Paths, C, L) :-
    maisLixo(Paths, [], -1, C, L).

maisLixo([], Caminho, Lixo, Caminho,Lixo).
maisLixo([P|Caminhos], MelhorCaminhoAtual, MenorLixoAtual, Caminho, Total) :-
    lixoRecolhido(P, Lixo),
    Lixo > MenorLixoAtual,
    maisLixo(Caminhos, P, Lixo, Caminho, Total).
maisLixo([P|Caminhos], MelhorCaminhoAtual, MenorLixoAtual, Caminho, Total) :-
    lixoRecolhido(P, Lixo),
    Lixo =< MenorLixoAtual,
    maisLixo(Caminhos, MelhorCaminhoAtual, MenorLixoAtual, Caminho, Total).

lixoRecolhido([], 0).
lixoRecolhido([A|B], Total) :- 
    somaLixoCaminho([A|B], 0, Total).

somaLixoCaminho([], A, A).
somaLixoCaminho([A|B], LixoAtual, Total) :-
    findall(L, pontoRecolha(_,_,_,_,A,_,L), Solucao),
    lixoNaLista(Solucao, LixoNoNodo),
    SumLixo is LixoAtual + LixoNoNodo,
    somaLixoCaminho(B, SumLixo, Total).

lixoNaLista([],0).
lixoNaLista([A|B], Total) :-
    somarValores([A|B], 0, Total).

somarValores([], A, A).
somarValores([A|B], LixoAtual, Total) :-
    SumLixo is A + LixoAtual,
    somarValores(B, SumLixo, Total).


maiorDistancia(Paths, C, D) :-
    maisLongo(Paths, [], -1, C, D).

maisLongo([], Caminho, Distancia, Caminho, Distancia).
maisLongo([P|Caminhos], MelhorCaminhoAtual, MaiorDistanciaAtual, Caminho, Distancia) :-
    distanciaPercorrida(P, Dist),
    Dist > MaiorDistanciaAtual,
    maisLongo(Caminhos, P, Dist, Caminho, Distancia).
maisLongo([P|Caminhos], MelhorCaminhoAtual, MaiorDistanciaAtual, Caminho, Distancia) :-
    distanciaPercorrida(P, Dist),
    Dist =< MaiorDistanciaAtual,
    maisLongo(Caminhos, MelhorCaminhoAtual, MaiorDistanciaAtual, Caminho, Distancia).

distanciaPercorrida([], 0).
distanciaPercorrida([A|B], Total) :- 
    somaDistancia([A|B], A, 0, Total).%saber qual nodo anterior

somaDistancia([], _, D, D).
somaDistancia([A|B], C, DistanciaAtual, Distancia) :-
    distancia(C,A,Dist),
    SumDist is DistanciaAtual + Dist,
    somaDistancia(B, A, SumDist, Distancia).

%--Não-Informada
%--depth-First
compararCircuitos_Depth(Territorio, IndicadorProdutividade) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    IndicadorProdutividade = 'Distancia',
    findall(Path, depthFirst(NodoInicial, NodoFinal, Path), Solucao),
    maiorDistancia(Solucao, Caminho, Valor), !,
    write('Caminho: '),
    write(Caminho),
    write('\nDistancia: '),
    write(Valor),
    write(' metros\n').

compararCircuitos_Depth(Territorio, IndicadorProdutividade) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    IndicadorProdutividade = 'Lixo',
    findall(Path, depthFirst(NodoInicial, NodoFinal, Path), Solucao),
    maiorLixoRecolhido(Solucao, Caminho, Valor), !,
    write('Caminho: '),
    write(Caminho),
    write('\nLixo Recolhido: '),
    write(Valor),
    write(' cm3 \n').

%--breath-First
compararCircuitos_Breadth(Territorio, IndicadorProdutividade) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    IndicadorProdutividade = 'Distancia',
    findall(Path, breadthFirst(NodoInicial, NodoFinal, Path), Solucao),
    maiorDistancia(Solucao, Caminho, Valor), !,
    write('Caminho: '),
    write(Caminho),
    write('\nDistancia: '),
    write(Valor),
    write(' metros\n').

compararCircuitos_Breadth(Territorio, IndicadorProdutividade) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    IndicadorProdutividade = 'Lixo',
    findall(Path, breadthFirst(NodoInicial, NodoFinal, Path), Solucao),
    maiorLixoRecolhido(Solucao, Caminho, Valor), !,
    write('Caminho: '),
    write(Caminho),
    write('\nLixo Recolhido: '),
    write(Valor),
    write(' cm3 \n').

%--profundidadeIterativa
compararCircuitos_DepthLimited(Territorio, Nivel, IndicadorProdutividade) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    IndicadorProdutividade = 'Distancia',
    findall(Path, depthFirstLimited(NodoInicial, NodoFinal, Nivel, Path), Solucao),
    maiorDistancia(Solucao, Caminho, Valor), !,
    write('Caminho: '),
    write(Caminho),
    write('\nDistancia: '),
    write(Valor),
    write(' metros\n').

compararCircuitos_DepthLimited(Territorio, Nivel, IndicadorProdutividade) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    IndicadorProdutividade = 'Lixo',
    findall(Path, depthFirstLimited(NodoInicial, NodoFinal, Nivel, Path), Solucao),
    maiorLixoRecolhido(Solucao, Caminho, Valor), !,
    write('Caminho: '),
    write(Caminho),
    write('\nLixo Recolhido: '),
    write(Valor),
    write(' cm3 \n').

%--Informada
%--Gulosa
compararCircuitos_Gulosa(Territorio, IndicadorProdutividade) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    IndicadorProdutividade = 'Distancia',
    findall(Path, gulosaSearch(NodoInicial, NodoFinal, Path), Solucao),
    maiorDistancia(Solucao, Caminho, Valor), !,
    write('Caminho: '),
    write(Caminho),
    write('\nDistancia: '),
    write(Valor),
    write(' metros\n').

compararCircuitos_Gulosa(Territorio, IndicadorProdutividade) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    IndicadorProdutividade = 'Lixo',
    findall(Path, gulosaSearch(NodoInicial, NodoFinal, Path), Solucao),
    maiorLixoRecolhido(Solucao, Caminho, Valor), !,
    lixoRecolhido(Caminho, Valor),
    write('Caminho: '),
    write(Caminho),
    write('\nLixo Recolhido: '),
    write(Valor),
    write(' cm3 \n').

%--Astar
compararCircuitos_Astar(Territorio, IndicadorProdutividade) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    IndicadorProdutividade = 'Distancia',
    findall(Path, astarSearch(NodoInicial, NodoFinal, Path), Solucao),
    maiorDistancia(Solucao, Caminho, Valor), !,
    write('Caminho: '),
    write(Caminho),
    write('\nDistancia: '),
    write(Valor),
    write(' metros\n').

compararCircuitos_Astar(Territorio, IndicadorProdutividade) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    IndicadorProdutividade = 'Lixo',
    findall(Path, astarSearch(NodoInicial, NodoFinal, Path), Solucao),
    maiorLixoRecolhido(Solucao, Caminho, Valor), !,
    write('Caminho: '),
    write(Caminho),
    write('\nLixo Recolhido: '),
    write(Valor),
    write(' cm3 \n').


%(4) Escolher o circuito mais rápido (usando o critério da distância).
menorDistancia(Paths, C, D) :-
    maisCurto(Paths, [], 10000000, C, D).

maisCurto([], Caminho, Distancia, Caminho, Distancia).
maisCurto([P|Caminhos], MelhorCaminhoAtual, MenorDistanciaAtual, Caminho, Distancia) :-
    distanciaPercorrida(P, Dist),
    Dist =< MenorDistanciaAtual,
    maisCurto(Caminhos, P, Dist, Caminho, Distancia).
maisCurto([P|Caminhos], MelhorCaminhoAtual, MenorDistanciaAtual, Caminho, Distancia) :-
    distanciaPercorrida(P, Dist),
    Dist > MenorDistanciaAtual,
    maisCurto(Caminhos, MelhorCaminhoAtual, MenorDistanciaAtual, Caminho, Distancia).

%--Não-Informada
%--depth-First
circuitoMaisCurto_Depth(Territorio) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    findall(Path, depthFirst(NodoInicial, NodoFinal, Path), Solucao),
    menorDistancia(Solucao, Caminho, Distancia), !,
    write('Menor Caminho: '),
    write(Caminho),
    write('\nDistancia: '),
    write(Distancia),
    write(' metros\n').

%--breadth-First
circuitoMaisCurto_Breadth(Territorio) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    findall(Path, breadthFirst(NodoInicial, NodoFinal, Path), Solucao),
    menorDistancia(Solucao, Caminho, Distancia), !,
    write('Menor Caminho: '),
    write(Caminho),
    write('\nDistancia: '),
    write(Distancia),
    write(' metros\n').

%--profundidadeIterativa
circuitoMaisCurto_DepthLimited(Territorio, Nivel) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    findall(Path, depthFirstLimited(NodoInicial, NodoFinal, Nivel, Path), Solucao),
    menorDistancia(Solucao, Caminho, Distancia), !,
    write('Menor Caminho: '),
    write(Caminho),
    write('\nDistancia: '),
    write(Distancia),
    write(' metros\n').

%--Informada
%--Gulosa
circuitoMaisCurto_Gulosa(Territorio) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    gulosaSearch(NodoInicial, NodoFinal, Caminho), 
    distanciaPercorrida(Caminho, Distancia), !,
    write('Menor Caminho: '),
    write(Caminho),
    write('\nDistancia: '),
    write(Distancia),
    write(' metros\n').

%--Astar
circuitoMaisCurto_Astar(Territorio) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    astarSearch(NodoInicial, NodoFinal, Caminho),
    distanciaPercorrida(Caminho, Distancia), !,
    write('Menor Caminho: '),
    write(Caminho),
    write('\nDistancia: '),
    write(Distancia),
    write(' metros\n').


%(5) Escolher o circuito mais eficiente (usando um critério de eficiência à escolha);
menosPontosRecolha(Paths, C, NumeroPontosRecolha) :-
    menosPontos(Paths, [], 1000000, C, NumeroPontosRecolha).

menosPontos([], Caminho, NumeroPontosRecolha, Caminho, NumeroPontosRecolha).
menosPontos([P|Caminhos], MelhorCaminhoAtual, MaiorNrPontosRecolhaAtual, Caminho, NumeroPontosRecolha) :-
    length(P, Tamanho),
    Tamanho =< MaiorNrPontosRecolhaAtual,
    menosPontos(Caminhos, P, Tamanho, Caminho, NumeroPontosRecolha).
menosPontos([P|Caminhos], MelhorCaminhoAtual, MaiorNrPontosRecolhaAtual, Caminho, NumeroPontosRecolha) :-
    length(P, Tamanho),
    Tamanho > MaiorNrPontosRecolhaAtual,
    menosPontos(Caminhos, MelhorCaminhoAtual, MaiorNrPontosRecolhaAtual, Caminho, NumeroPontosRecolha).

%--Não-Informada
%--depth-First
circuitoMaisEficiente_Depth(Territorio) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    findall(Path, depthFirst(NodoInicial, NodoFinal, Path), Solucao),
    menosPontosRecolha(Solucao, Caminho, Pontos), !,
    write('Menor Caminho: '),
    write(Caminho),
    write('\nNodos: '),
    write(Pontos),
    write(' Pontos de Recolha\n').

%--breadth-First
circuitoMaisEficiente_Breadth(Territorio) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    findall(Path, breadthFirst(NodoInicial, NodoFinal, Path), Solucao),
    menosPontosRecolha(Solucao, Caminho, Pontos), !,
    write('Menor Caminho: '),
    write(Caminho),
    write('\nNodos: '),
    write(Pontos),
    write(' Pontos de Recolha\n').

%--profundidadeIterativa
circuitoMaisEficiente_DepthLimited(Territorio, Nivel) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    findall(Path, depthFirstLimited(NodoInicial, NodoFinal, Nivel, Path), Solucao),
    menosPontosRecolha(Solucao, Caminho, Pontos), !,
    write('Menor Caminho: '),
    write(Caminho),
    write('\nNodos: '),
    write(Pontos),
    write(' Pontos de Recolha\n').

%--Informada
%--Gulosa
circuitoMaisEficiente_Gulosa(Territorio) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    findall(Path, gulosaSearch(NodoInicial, NodoFinal, Path), Solucao),
    menosPontosRecolha(Solucao, Caminho, Pontos), !,
    write('Menor Caminho: '),
    write(Caminho),
    write('\nNodos: '),
    write(Pontos),
    write(' Pontos de Recolha\n').

%--Astar
circuitoMaisEficiente_Astar(Territorio) :-
    inicial(NodoInicial),
    final(NodoFinal),
    pontoRecolha(_,_,_,Territorio,NodoInicial,_,_),
    pontoRecolha(_,_,_,Territorio,NodoFinal,_,_),
    findall(Path, astarSearch(NodoInicial, NodoFinal, Path), Solucao),
    menosPontosRecolha(Solucao, Caminho, Pontos), !,
    write('Menor Caminho: '),
    write(Caminho),
    write('\nNodos: '),
    write(Pontos),
    write(' Pontos de Recolha\n').


