# Tabela de Conceitos — Mundo dos Blocos com Tamanhos Variáveis

Esta tabela descreve todos os conceitos, predicados e estruturas usados no domínio e no planejador lógico
implementado em Prolog, relacionando-os aos elementos físicos do problema.

| Conceito / Predicado | Tipo | Valores / Domínio | Descrição |
|----------------------|------|-------------------|------------|
| **Bloco** | objeto | `{a, b, c, d}` | Entidades físicas que podem estar sobre a mesa ou empilhadas. |
| `block(B)` | fato estático | B ∈ {a,b,c,d} | Define os blocos existentes no domínio. |
| **Tamanho** | propriedade | inteiro positivo | Número de *slots* de largura ocupados pelo bloco na mesa. |
| `size(B, W)` | fato estático | `size(a,1)`, `size(b,1)`, `size(c,2)`, `size(d,2)` | Define a largura dos blocos em unidades de mesa. |
| **Mesa / Slots** | domínio de posições | `{0,1,2,3,4,5,6}` | A mesa é representada como uma grade de sete posições discretas (slots). |
| `table_slot(S)` | fato estático | S ∈ {0..6} | Cada posição possível para início de um bloco na mesa. |
| `table_width(N)` | fato estático | N = 7 | Largura total da mesa (número de slots). |
| **Posição** | relação dinâmica | `pos(Block, table(Slot))` ou `pos(Block, on(Target))` | Indica onde o bloco está: sobre a mesa (começando no `Slot`) ou sobre outro bloco `Target`. |
| `pos/2` | fato dinâmico | - | Representa a posição atual de cada bloco. É o núcleo do estado. |
| **Topo livre** | relação dinâmica | `clear(Block)` | Verdadeiro se nenhum outro bloco está sobre `Block`. |
| `clear/1` | fato dinâmico | - | Usado como pré-condição de ações. |
| **Slots ocupados** | derivado | lista de inteiros | Conjunto de slots ocupados por um bloco com base em seu tamanho e posição. |
| `busy_slots(Block, State, Slots)` | predicado derivado | - | Calcula os slots ocupados por `Block` em um determinado estado. |
| **Posição absoluta** | derivado | inteiro | Slot inicial absoluto de um bloco (considerando empilhamentos). |
| `absolute_pos(Block, State, Slot)` | predicado derivado | - | Retorna o slot mais à esquerda ocupado pelo bloco. |
| **Espaço livre** | derivado | booleano | Indica se um slot está disponível na mesa. |
| `is_free(Slot, State)` | predicado derivado | - | Verdadeiro se nenhum bloco ocupa o slot no estado atual. |
| **Verificação de espaço** | pré-condição | booleano | Garante que há espaço contíguo para um bloco na mesa. |
| `holds(space_check(Block, Slot))` | predicado | - | Verdadeiro se o bloco cabe nos slots `[Slot .. Slot+W-1]` e todos estão livres. |
| **Verificação de estabilidade** | pré-condição | booleano | Garante que blocos só fiquem sobre blocos maiores ou de tamanho igual. |
| `holds(size_check(BlockA, BlockB))` | predicado | - | Verdadeiro se `size(BlockA) ≤ size(BlockB)`. |
| **Ações** | operador | `move(Block, table(Slot))` ou `move(Block, on(Target))` | Representa mover um bloco para uma posição na mesa ou sobre outro bloco. |
| `can(Action, State)` | regra de aplicabilidade | - | Define se uma ação pode ser executada (pré-condições válidas). |
| `adds(Action, State, NewState)` | efeito | - | Adiciona os efeitos positivos de uma ação a um estado. |
| `deletes(Action, State, NewState)` | efeito | - | Remove os efeitos negativos (fatos que deixam de ser verdadeiros). |
| `apply(Action, State, NewState)` | transição | - | Atualiza o estado aplicando `adds` e `deletes`. |
| **Planejamento** | meta | `plan(State, Goal, Plan)` | Busca uma sequência de ações que transforma `State` em `Goal`. |
| `satisfied(State, Goal)` | teste | - | Verifica se todas as metas do `Goal` estão presentes em `State`. |
| **Situações** | cenário | `initial_state_n` / `goal_state_n` | Representam o estado inicial e o objetivo de cada caso de teste. |

---

## Estrutura do Estado

Um estado é representado por uma lista de literais verdadeiros, por exemplo:

```prolog
[
  pos(d, table(0)),
  pos(b, on(d)),
  pos(a, on(b)),
  pos(c, on(a)),
  clear(c)
]
