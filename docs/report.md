# Relatório — Planejador Automático: Mundo dos Blocos

## Introdução
Este trabalho implementa um planejador automático em Prolog para o domínio do mundo dos blocos com tamanhos variáveis. O objetivo é gerar planos válidos que respeitem restrições físicas e lógicas, utilizando o formalismo de Planning as Model Checking.

## Estrutura do Código

### Fatos Estáticos
- `block/1`: Define os blocos existentes.
- `size/2`: Define os tamanhos dos blocos.
- `table_slot/1`: Define os slots da mesa.
- `table_width/1`: Define a largura total da mesa.

### Predicados Dinâmicos e Auxiliares
- `pos/2`: Representa a posição de um bloco.
- `clear/1`: Indica se o topo de um objeto está livre.
- `is_free/2`: Verifica se um slot está livre.
- `busy_slots/3`: Retorna os slots ocupados por um bloco.
- `absolute_pos/3`: Retorna a posição absoluta de um bloco.
- `holds/1`: Verifica condições como estabilidade e espaço livre.

### Regras de Física e Validade
- `can/2`: Define as pré-condições para ações.
- `holds/1`: Verifica se um estado satisfaz condições de estabilidade e mobilidade.

### Efeitos das Ações
- `adds/2`: Adiciona efeitos ao estado.
- `deletes/3`: Remove efeitos do estado.

### Planejador
- `plan/3`: Implementa busca em profundidade para gerar planos.
- `apply/3`: Aplica ações ao estado.
- `achieves/2`: Verifica se uma ação alcança um objetivo.
- `satisfied/2`: Verifica se um estado satisfaz o objetivo.

### Estados e Consultas
- Estados iniciais e objetivos para as Situações 1, 2 e 3.
- Consultas para testar planos válidos e explorar estados impossíveis.

## Resultados
Os testes realizados confirmaram que o planejador é capaz de:
1. Gerar planos válidos para as Situações 1, 2 e 3.
2. Detectar estados impossíveis ao negar os objetivos.

## Conclusão
O planejador desenvolvido atende aos requisitos do trabalho, demonstrando a capacidade de raciocinar sobre o mundo dos blocos com tamanhos variáveis e gerar planos válidos.

## Repositório
O código completo está disponível no repositório GitHub: [IA-mundo-blocos-AGS](https://github.com/okiyud/IA-mundo-blocos-AGS).

## Execução
Para executar os testes, carregue o arquivo `blocks_and_table.pl` no interpretador Prolog e utilize as consultas fornecidas.

```prolog
?- initial_state_1(S0), goal_state_1(Goal), plan(S0, Goal, Plan).
?- initial_state_2(S0), goal_state_2(Goal), plan(S0, Goal, Plan).
?- initial_state_3(S0), goal_state_3(Goal), plan(S0, Goal, Plan).
```