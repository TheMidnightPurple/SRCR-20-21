%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCINIO - MIEI 


% Carlos João Teixeira Preto  - A89587

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% PROLOG: definicoes iniciais

:- op( 900,xfy,'::' ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).

membro(X, [X|_]).
membro(X, [_|Xs]):-
	membro(X, Xs).

escrever([]) :- fail.
escrever([H|T]) :- 
    write('Caminho: '),
    write(H),
    write('\n'),
    escrever(T).

%--atualizar
atualizar([], _, _, X-X).
atualizar([(_,Estado)|Ls], Vs, Historico, Xs-Ys) :- 
    membro(Estado, Historico), !, 
    atualizar(Ls, Vs, Historico, Xs-Ys).
atualizar([(Move, Estado)|Ls], Vs, Historico, [(Estado,[Move|Vs])|Xs]-Ys):- 
    atualizar(Ls, Vs, Historico, Xs-Ys).


%--inverter
inverteraux([],A,A).
inverteraux([H|T],A,R) :- inverteraux(T,[H|A],R).

inverso(L,R) :- inverteraux(L,[],R).

inverteLista([],Z,Z).
inverteLista([H|T],Z,Acc) :- inverteLista(T,Z,[H|Acc]).

%--calcular distancias
distancia(Nodo, ProxNodo, DistanciaTotal) :-
    pontoRecolha(Lat1,Long1,_,_,Nodo,_,_),
    pontoRecolha(Lat2,Long2,_,_,ProxNodo,_,_),
    ValPi is pi,
    Fi1 is Lat1 * (ValPi/180),
    Fi2 is Lat2 * (ValPi/180),
    DeltaFi is (Lat2-Lat1) * (ValPi/180),
    DeltaLambda is (Long2-Long1) * (ValPi/180),
    A1 is sin(DeltaFi/2) * sin(DeltaFi/2),
    A2 is cos(Fi1) * cos(Fi2),
    A3 is sin(DeltaLambda/2) * sin(DeltaLambda/2),
    ASum is A1 + A2 * A3,
    C1 is sqrt(ASum),
    C2 is sqrt(1.0 - ASum),
    C is 2 * atan2(C1, C2),
    Dist is 6.371*1000 * C,
    DistanciaTotal is Dist*1000, !.%para dar em metros

menorEurist([],A,A).
menorEurist([(N,P,K)|T],(BN,BP,BK),R) :- K < BK, menorEurist(T,(N,P,K),R). 
menorEurist([(N,P,K)|T],(BN,BP,BK),R) :- menorEurist(T,(BN,BP,BK),R). 

seleciona(E,[E|Xs],Xs).
seleciona(E,[X|Xs], [X|Ys]) :- seleciona(E,Xs,Ys). 

lixoTotal(Lista, LixoTotal) :-
    somaLixo(Lista, 0, LixoTotal).

somaLixo([],L,L).
somaLixo([A|B], LT, L) :-
    SumLixo is A + LT,
    somaLixo(B, SumLixo, L).


tempoExecucao(A) :-
    statistics(runtime,[Start|_]),
    A,
    statistics(runtime,[Stop|_]), !,
    Runtime is Stop - Start,
    write('\nTempo de Execucao : '),
    write(Runtime),
    write(' milisegundos.').
     

