% Fatos estáticos para o domínio do mundo dos blocos

% Define os blocos existentes
block(a).
block(b).
block(c).
block(d).

% Define os tamanhos dos blocos
size(a, 1).
size(b, 1).
size(c, 2).
size(d, 2).

% Define os slots da mesa
table_slot(0).
table_slot(1).
table_slot(2).
table_slot(3).
table_slot(4).
table_slot(5).
table_slot(6).

% Define a largura total da mesa
table_width(7).

% Predicados dinâmicos para representar o estado
:- dynamic(pos/2).
:- dynamic(clear/1).

% Predicados auxiliares

% Verifica se um slot está livre na mesa
is_free(Slot, State) :- \+ member(pos(_, table(Slot)), State).

% Retorna os slots ocupados por um bloco
busy_slots(Block, State, Slots) :-
    member(pos(Block, table(StartSlot)), State),
    size(Block, Width),
    findall(Slot, (between(StartSlot, StartSlot+Width-1, Slot)), Slots).

% Retorna a posição absoluta mais à esquerda de um bloco
absolute_pos(Block, State, StartSlot) :-
    member(pos(Block, table(StartSlot)), State).

% Verifica se um bloco pode ser empilhado sobre outro
holds(size_check(BlockA, BlockB)) :-
    size(BlockA, WidthA),
    size(BlockB, WidthB),
    WidthA =< WidthB.

% Verifica se há espaço livre na mesa para um bloco
holds(space_check(Block, StartSlot)) :-
    size(Block, Width),
    table_width(TableWidth),
    EndSlot is StartSlot + Width - 1,
    EndSlot =< TableWidth,
    findall(Slot, between(StartSlot, EndSlot, Slot), Slots),
    forall(member(Slot, Slots), is_free(Slot, _)).

% Regras de física e validade

% Verifica se uma ação é válida
can(move(Block, table(StartSlot)), State) :-
    clear(Block),
    holds(space_check(Block, StartSlot)),
    \+ member(pos(Block, table(_)), State).

can(move(Block, on(TargetBlock)), State) :-
    clear(Block),
    clear(TargetBlock),
    holds(size_check(Block, TargetBlock)),
    \+ member(pos(Block, on(TargetBlock)), State).

% Verifica se um estado satisfaz uma condição
holds(stable(Block, State)) :-
    member(pos(Block, table(_)), State).

holds(stable(Block, State)) :-
    member(pos(Block, on(TargetBlock)), State),
    holds(size_check(Block, TargetBlock)).

% Efeitos das ações

% Adiciona os efeitos de uma ação ao estado
adds(move(Block, table(StartSlot)), State, NewState) :-
    append(State, [pos(Block, table(StartSlot)), clear(Block)], NewState).

adds(move(Block, on(TargetBlock)), State, NewState) :-
    append(State, [pos(Block, on(TargetBlock)), clear(Block)], NewState).

% Remove os efeitos de uma ação do estado
deletes(move(Block, table(StartSlot)), State, NewState) :-
    select(pos(Block, table(StartSlot)), State, TempState),
    select(clear(Block), TempState, NewState).

deletes(move(Block, on(TargetBlock)), State, NewState) :-
    select(pos(Block, on(TargetBlock)), State, TempState),
    select(clear(Block), TempState, NewState).

% Planejador lógico com busca em profundidade

% Predicado principal para planejar
plan(State, Goal, [Action|Plan]) :-
    achieves(Action, Goal),
    can(Action, State),
    apply(Action, State, NewState),
    plan(NewState, Goal, Plan).

plan(State, Goal, []) :-
    satisfied(State, Goal).

% Verifica se um estado satisfaz o objetivo
satisfied(State, Goal) :-
    forall(member(Condition, Goal), member(Condition, State)).

% Aplica uma ação ao estado
apply(Action, State, NewState) :-
    adds(Action, State, TempState),
    deletes(Action, TempState, NewState).

% Verifica se uma ação alcança um objetivo
achieves(move(Block, table(StartSlot)), pos(Block, table(StartSlot))).
achieves(move(Block, on(TargetBlock)), pos(Block, on(TargetBlock))).

% Estados iniciais e objetivos para as situações

% Situação 1
initial_state_1([pos(c, table(0)), pos(a, table(3)), pos(b, table(4)), pos(d, table(5)), clear(c), clear(a), clear(b), clear(d)]).
goal_state_1([pos(c, table(0)), pos(a, on(c)), pos(b, on(a)), pos(d, on(b))]).

% Situação 2
initial_state_2([pos(a, table(0)), pos(b, table(1)), pos(c, table(2)), pos(d, table(3)), clear(a), clear(b), clear(c), clear(d)]).
goal_state_2([pos(c, table(0)), pos(a, on(c)), pos(b, on(a)), pos(d, on(b))]).

% Situação 3
initial_state_3([pos(c, table(0)), pos(a, table(3)), pos(b, table(4)), pos(d, table(5)), clear(c), clear(a), clear(b), clear(d)]).
goal_state_3([pos(c, table(0)), pos(d, on(c)), pos(a, on(d)), pos(b, on(a))]).

% Consultas para testar planos

%% Teste para Situação 1
%?- initial_state_1(S0), goal_state_1(Goal), plan(S0, Goal, Plan).
%
%% Teste para Situação 2
%?- initial_state_2(S0), goal_state_2(Goal), plan(S0, Goal, Plan).
%
%% Teste para Situação 3
%?- initial_state_3(S0), goal_state_3(Goal), plan(S0, Goal, Plan).
%
%% Teste para estados impossíveis
%?- initial_state_1(S0), \+ goal_state_1(Goal), plan(S0, Goal, Plan).
%?- initial_state_2(S0), \+ goal_state_2(Goal), plan(S0, Goal, Plan).
%?- initial_state_3(S0), \+ goal_state_3(Goal), plan(S0, Goal, Plan).