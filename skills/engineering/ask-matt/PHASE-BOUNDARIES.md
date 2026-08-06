# Phase boundaries

Uma **fase** é um pedaço de trabalho dentro de uma sessão — a sabatina, a implementação, o QA. A definição é nebulosa de propósito: uma fase termina quando você pensa *"ok, terminamos isso"*.

O **phase boundary** é o vão entre duas fases, e é o único lugar onde esta decisão cabe. No meio da fase não há decisão a tomar — continue, ou divida o trabalho que resta em subagents. Compactar no meio da fase faz o agent perder o fio.

## As cinco opções

| Opção        | O que faz                                                          |
| ------------ | ----------------------------------------------------------------- |
| **Continue** | Fique na sessão. Nenhuma troca de contexto.                       |
| **`/clear`** | Esvazie a janela de contexto e comece do zero.                    |
| **`/handoff`** | Escreva um arquivo markdown portável e semeie uma sessão em qualquer lugar com ele. |
| **Subagent** | Mande a tarefa para a própria janela de contexto e receba um relatório de volta. |
| **`/compact`** | Comprima este contexto e semeie uma sessão fresca com o resumo.  |

## A árvore

Trabalhe de cima para baixo no boundary. O primeiro **sim** vence.

**1. Você consegue continuar nesta sessão?** Duas coisas fazem a resposta ser sim: a próxima fase precisa desta fase como **fonte primária**, ou você tem [smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone) suficiente sobrando (~150k tokens) para a próxima fase caber. Sabatina → implementação é o sim padrão: a implementação quer o raciocínio verbatim, não um resumo dele. Continue não custa nada e não perde nada, então descarte-a antes de qualquer outra coisa.

**2. O contexto é irrelevante para o que vem a seguir?** Tudo nesta sessão — a exploração, as decisões, os becos sem saída — é descartável? Se sim, **`/clear`**. É a jogada mais barata do tabuleiro: não leva tempo e devolve a janela inteira. `/clear` também não é terminal — a sessão antiga continua resumível.

O custo de errar isto é de mão única. Limpe um contexto *relevante* e você perde o **porquê** por trás do que construiu, e nenhuma quantidade de reler o diff o traz de volta.

**3. Você precisa fazer handoff?** `/handoff` é estreito. Você precisa dele só quando está:

- trocando para um **novo harness** (Claude → Codex),
- movendo para um **novo diretório** ou repo,
- mandando o trabalho para um **colega**,
- ou bifurcando uma tarefa lateral que você achou **no meio da fase** sem descarrilhar o que está fazendo.

Essa lista é a cláusula inteira. O que `/handoff` compra é **portabilidade** — um arquivo que viaja. Se nada está viajando, você não precisa dele.

**4. A tarefa pode ser feita AFK?** Está escopada apertada o bastante para rodar com você longe do teclado, sem direção? Então mande-a para um **subagent** e deixe esta sessão intocada. Review automatizado é o caso padrão: o agent lê o diff e reporta, e você não é necessário enquanto ele faz.

**5. Senão, `/compact`.** Contexto relevante, mesmo harness, mesmo diretório, e você precisa ficar no loop — é onde a árvore aterrissa, e aterrissa aqui com frequência. Passe uma instrução (`/compact vamos fazer QA desta área`) para o resumo guardar o que a próxima fase precisa.

`/compact` é o **default, não a primeira escolha**. Fica no fundo porque as quatro perguntas acima dele são todas mais baratas ou mais precisas. O modo de falha quando as pessoas começam por aqui é uma sessão fresca que está confiantemente errada sobre uma decisão que o resumo achatou.

## Fontes primárias e secundárias

Toda jogada exceto **Continue** transforma uma **fonte primária** numa **fonte secundária** — a sessão como ela aconteceu, substituída por um resumo dela. A troca tem sempre o mesmo formato:

| Fonte                              | Informação | Ruído | Espaço de manobra |
| ---------------------------------- | ---------- | ----- | ----------------- |
| Primária (Continue)                | Total      | Muito | Pouco             |
| Secundária (`/compact`, `/handoff`) | Com perdas | Menos | Muito             |

É por isso que a pergunta 1 vem primeiro. Você só paga a perda quando ficar custa mais do que economiza.

## Estas são judgement calls

As perguntas não são objetivas — cada uma tem gosto nela, e o mesmo boundary pode ir para dois lados em dois dias. O valor está em fazê-las **em ordem**, no boundary em vez de no meio do trabalho.
