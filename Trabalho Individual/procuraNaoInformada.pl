%---------------------------------Algoritmos de procura não informada

%--------------------------------------- Depth-First-Search
depthFirst(NodoInicial, NodoFinal, [NodoInicial|Caminho]) :- 
    profundidadePrimeiro(NodoInicial, NodoFinal, [NodoInicial], Caminho).

profundidadePrimeiro(Nodo,Nodo,_,[]).
profundidadePrimeiro(NodoInicial, NodoFinal, Historico, [ProxNodo|Caminho]) :- 
    adjacenteDF(NodoInicial,ProxNodo), 
    nao(membro(ProxNodo,Historico)), 
    profundidadePrimeiro(ProxNodo, NodoFinal, [ProxNodo|Historico], Caminho).

adjacenteDF(Nodo,ProxNodo) :- 
    caminho(Nodo,ProxNodo).

  
%--------------------------------------- Breath-First-Search
breadthFirst(NodoInicial, NodoFinal, CaminhoFinal) :- 
    breadthPrimeiro([[NodoInicial]], NodoFinal, Solucao),
    inverteLista(Solucao, CaminhoFinal, []).

breadthPrimeiro([[Nodo|Caminho]|_], Nodo, [Nodo|Caminho]).
breadthPrimeiro([[Nodo|Caminho]|CaminhoList], NodoFinal, Solucao) :-
    bagof([ProxNodo, Nodo|Caminho],
    (adjacenteBF(Nodo, ProxNodo),\+ membro(ProxNodo, [Nodo|Caminho])), NovosCaminhos),
    append(CaminhoList, NovosCaminhos, Res), !,
    breadthPrimeiro(Res, NodoFinal, Solucao);
    breadthPrimeiro(CaminhoList, NodoFinal, Solucao).

adjacenteBF(Nodo, NodoAdj) :- 
    caminho(Nodo, NodoAdj).

%--------------------------------------- Depth-First-Search Limitado
depthFirstLimited(NodoInicial, NodoFinal, Nivel,[NodoInicial|Caminho]) :- 
    profundidadePrimeiroLimited(NodoInicial, NodoFinal, Nivel, [NodoInicial], 0, Caminho).

profundidadePrimeiroLimited(Nodo, Nodo,_,_,_,[]).
profundidadePrimeiroLimited(NodoInicial, NodoFinal, Nivel, Historico, Counter, [ProxNodo|Caminho]) :- 
    Counter < Nivel,
    adjacenteDF(NodoInicial,ProxNodo), 
    nao(membro(ProxNodo,Historico)), 
    NewCounter is Counter + 1, 
    profundidadePrimeiroLimited(ProxNodo, NodoFinal, Nivel,[ProxNodo|Historico], NewCounter, Caminho).



















