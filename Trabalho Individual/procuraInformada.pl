%---------------------------------Algoritmos de procura informada

%--------------------------------------- Gulosa
gulosaSearch(Partida, Destino, Caminho) :-
	distancia(Partida, Destino,Estimativa),
	agulosa([[Partida]/0/Estimativa],Destino,InvCaminho/Custo/_),
    inverteLista(InvCaminho, Caminho, []).

agulosa(Caminhos, Destino ,Caminho) :-
	obtem_melhor_gulosa(Caminhos, Caminho),
    Caminho = [Nodo|_]/_/_,
    Nodo == Destino.

agulosa(Caminhos, Destino ,SolucaoCaminho) :-
	obtem_melhor_gulosa(Caminhos,MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_gulosa(MelhorCaminho, ExpCaminhos,Destino),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    agulosa(NovoCaminhos,Destino ,SolucaoCaminho).	


expande_gulosa(Caminho, ExpCaminhos, Destino) :-
    findall(NovoCaminho, adjacenteGulosa(Caminho,NovoCaminho,Destino), ExpCaminhos).


adjacenteGulosa([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/Est,Destino) :-
    caminho(Nodo, ProxNodo),
    distancia(Nodo, ProxNodo, PassoCusto),
    \+ member(ProxNodo, Caminho),
    NovoCusto is Custo + PassoCusto,
    distancia(ProxNodo,Destino ,Est).

obtem_melhor_gulosa([Caminho], Caminho) :- !.

obtem_melhor_gulosa([Caminho1/Custo1/Est1,_/_/Est2|Caminhos], MelhorCaminho) :-
	Est1 =< Est2, !,
	obtem_melhor_gulosa([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).
	
obtem_melhor_gulosa([_|Caminhos], MelhorCaminho) :- 
	obtem_melhor_gulosa(Caminhos, MelhorCaminho).


%--------------------------------------- A*(A estrela)
astarSearch(Nodo, Destino, Caminho) :-
    distancia(Nodo,Destino,Estima),
    astar([[Nodo]/0/Estima], Destino, InvCaminho/Custo/_),
    inverteLista(InvCaminho, Caminho, []).

astar(Caminhos,Destino, Caminho) :-
    obtem_melhor_astar(Caminhos, Caminho),
    Caminho = [Nodo|_]/_/_,
    Nodo == Destino.

astar(Caminhos,Destino, SolucaoCaminho) :-
    obtem_melhor_astar(Caminhos, MelhorCaminho),
    seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
    expande_astar(MelhorCaminho, Destino,ExpCaminhos),
    append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    astar(NovoCaminhos, Destino,SolucaoCaminho).	

expande_astar(Caminho,Destino, ExpCaminhos) :-
    findall(NovoCaminho, move_astar(Caminho,Destino,NovoCaminho), ExpCaminhos).

move_astar([Nodo|Caminho]/Custo/_, Destino,[ProxNodo,Nodo|Caminho]/NovoCusto/Est) :-
    caminho(Nodo, ProxNodo),
    distancia(Nodo, ProxNodo, PassoCusto),
    \+ member(ProxNodo, Caminho),
    NovoCusto is Custo + PassoCusto,
    distancia(ProxNodo,Destino,Est).
    
obtem_melhor_astar([Caminho], Caminho) :- !.
obtem_melhor_astar([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
    Custo1 + Est1 =< Custo2 + Est2, !,
    obtem_melhor_astar([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).    
obtem_melhor_astar([_|Caminhos], MelhorCaminho) :- 
    obtem_melhor_astar(Caminhos, MelhorCaminho).