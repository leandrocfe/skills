---
name: writing-for-agents
description: Writing documents for agents. Use when creating or editing skills, or modifying AGENTS.md or CLAUDE.md.
---

Referência para escrever qualquer documento que um agent consome — uma skill, um `AGENTS.md` / `CLAUDE.md`, um doc alcançado por um pointer. O empacotamento difere; a escrita não: as mesmas alavancas tornam cada um previsível — o agent tomando o mesmo _processo_ toda execução, não produzindo o mesmo output.

Quando o documento que você está escrevendo é uma skill, leia [`SKILL-MECHANICS.md`](SKILL-MECHANICS.md) para frontmatter, escolha de invocação e router skills.

## Context pointers

Um **context pointer** é uma referência mantida no contexto do agent que nomeia algum material fora-de-contexto e codifica a condição para alcançá-lo. A description de uma skill é um; uma linha no `AGENTS.md` nomeando um doc é o mesmo objeto. A _redação_ do pointer, não o seu alvo, decide quando o agent alcança o material — e com que confiabilidade. Um alvo must-have atrás de um pointer mal redigido é um bug de variância: afie a redação primeiro, e inline o material só se afiar falhar.

Um pointer faz dois trabalhos — dizer o que o material é, e listar os **branches** que deveriam disparar o alcance dele (um branch é um caso distinto que o documento trata, então execuções diferentes tomam caminhos diferentes por ele). Cada palavra de um pointer sempre-carregado custa a cada turno, então ele merece poda ainda mais dura do que o corpo:

- **Front-load da leading word** — o pointer é onde ela faz seu trabalho de disparo.
- **Um trigger por branch.** Sinônimos que renomeiam um único branch são um branch escrito duas vezes; colapse-os e mantenha só branches genuinamente distintos.
- **Corte a identidade que o corpo já carrega.**

## As duas cargas

Todo documento e pointer que você adiciona gasta um de dois orçamentos:

- **Context load** — o custo de material sempre-carregado na janela do agent: uma linha de `AGENTS.md`, uma description de skill, qualquer coisa parada no contexto a cada turno, gastando tokens e atenção dispare ou não.
- **Cognitive load** — o custo no humano: quais documentos existem e quando alcançar cada um. O humano é o índice. Não é um custo a minimizar — é o preço da agência humana; gaste-o onde o julgamento humano importa, remova-o onde não importa.

Material alcançado só por um pointer escapa da context load ao preço da própria linha do pointer; material sem pointer algum viaja inteiramente na cognitive load.

## Information hierarchy

Um documento é construído a partir de dois tipos de conteúdo — **steps** (as ações ordenadas que o agent executa) e **reference** (definições, regras, fatos consultados sob demanda) — que se misturam livremente: só steps (uma receita), só reference (as regras de uma review, esta skill), ou ambos. A decisão central é onde cada peça fica na **information hierarchy**, uma escada ranqueada por quão imediatamente o agent precisa do material:

1. **In-file step** — o tier primário: o que o agent faz, em ordem.
2. **In-file reference** — consultado sob demanda. Frequentemente um peer-set legitimamente flat (toda regra de uma review num degrau) — um arranjo bom, não um smell.
3. **Disclosed reference** — empurrado para um arquivo separado, alcançado por um context pointer, carregado só quando o pointer dispara. Vai de um arquivo irmão na mesma pasta até reference totalmente externa que vive em qualquer lugar e qualquer documento pode apontar.

Empurre pouco demais para baixo e o topo incha; empurre demais e você esconde material que o agent de fato precisa. Essa tensão é a decisão inteira.

**Progressive disclosure** é o movimento escada abaixo — para fora do arquivo principal e atrás de um pointer — para o topo ficar legível. Não é primariamente uma otimização de tokens: é como a hierarquia é protegida. Branching é o teste de disclosure mais limpo: inline o que todo branch precisa, e empurre atrás de um pointer o que só alguns branches alcançam. Quando um documento tem steps, in-file reference que deveria ser disclosed os soterra e transforma prestar atenção neles num cara-ou-coroa — uma alavanca de variância, não só de legibilidade.

**Co-location** é o companheiro dentro-do-arquivo: onde a escada decide _quão fundo_ uma peça fica, co-location decide _o que fica ao lado dela_ uma vez lá. Mantenha a definição, regras e caveats de um conceito sob um heading em vez de espalhados, para ler uma parte trazer as vizinhas junto. O teste: o documento deveria ler como documentação escrita para o agent — material agrupado lê assim; material espalhado não. (Distinto de duplicação: aquela repete um significado em dois lugares; espalhar fragmenta um significado por muitos.)

**Sprawl** é o modo de falha aqui: um documento simplesmente longo demais, mesmo quando cada linha é viva e única. A atenção afina pelo excesso, e cada linha extra é mais uma a manter relevante. A cura é a escada: disclose reference atrás de pointers, e divida por branch ou sequência para cada caminho carregar só o que precisa.

## Steps e completion criteria

Todo step termina num **completion criterion** — a condição que diz ao agent que o trabalho acabou. Duas propriedades o tornam uma alavanca:

- **Clareza** — o agent consegue distinguir feito de não-feito? Um limite vago ("entendimento alcançado") convida a **premature completion**: terminar o step antes de ele estar genuinamente feito, a atenção escorregando para _estar feito_. Os steps ainda visíveis à frente — os **post-completion steps** — fornecem o puxão; a clareza do critério é a resistência. Defenda em ordem: **afie o limite primeiro** (local e barato); só se ele for irredutivelmente difuso _e_ você observar a pressa, esconda os steps posteriores dividindo a sequência — e esconder só funciona através de uma fronteira de contexto real (um hand-off ou dispatch de subagent; uma chamada inline deixa os steps posteriores no contexto e não limpa nada).
- **Demand** — quanto ele exige. "Todo model modificado contabilizado" força trabalho minucioso onde "produza uma lista de mudanças" não força. Demand dirige **legwork** — a escavação que o agent faz dentro do trabalho, latente na redação em vez de escrita como step próprio — e não é presa a step: "toda regra aplicada" prende um corpo de reference flat tanto quanto "todo step feito" prende uma sequência, que é como um documento só-reference ainda carrega uma barra de exaustividade.

Os critérios mais fortes são checáveis e exaustivos ao mesmo tempo.

## Quando dividir

Dividir um documento em dois gasta uma das duas cargas, então divida só quando o corte compensar:

- **Por sequência** — divida uma corrida de steps onde os post-completion steps tentam o agent a apressar o que está na frente. Mantê-los fora de vista dirige mais legwork na tarefa atual. Cuidado com o reverso: fundir sequências expõe os steps posteriores de cada step ao que segue, convidando premature completion.
- **Por invocação** — específico de skill: veja [`SKILL-MECHANICS.md`](SKILL-MECHANICS.md).

## Leading words

Uma **leading word** é um conceito compacto já vivendo no pretraining do modelo que o agent usa para pensar enquanto roda o documento (_lesson_, _fog of war_, _tracer bullets_). Repetida como token, nunca como frase, ela acumula uma definição distribuída e ancora toda uma região de comportamento nos menores tokens, recrutando priors que o modelo já tem. Cunhar a sua própria funciona se você a definir claramente, mas uma palavra inventada não recruta prior algum — você paga em tokens de definição o que uma palavra pré-treinada dá de graça; recorra primeiro a uma palavra existente.

Ela ancora duas vezes. No corpo, _execução_: o agent recorre ao mesmo comportamento toda vez que a palavra aparece, e dentro de reference flat ela foca a atenção numa classe de coisa a procurar. Num pointer, _invocação_: quando a mesma palavra vive nos seus prompts, seus docs e sua codebase, o agent liga essa linguagem compartilhada ao material e o alcança com mais confiabilidade.

Cace oportunidades de refatorar com leading words. Uma tríade soletrada em três sítios, um pointer gastando uma frase para gesticular sobre uma ideia — cada um é uma passagem implorando para colapsar num único token:

- "fast, deterministic, low-overhead" → _tight_ (um loop _tight_).
- "a loop you believe in" → _red_ — um gate difuso vira um estado observável binário (o loop fica _red_ no bug, ou não fica).

Você ganha duas vezes: menos tokens, e um hook mais afiado para o agent pendurar seu pensamento. Assuma que todo documento carrega restatements que leading words aposentam — vá achá-los.

**Negação** é o modo de falha ao lado desta alavanca: dirigir por proibição arrasta o comportamento proibido para o contexto e o torna _mais_ disponível, não menos. _Não pense num elefante_, e o elefante é tudo que há; a negação é um modificador fraco que o conceito fortemente-ativado atropela, então o banimento meio-lê como uma instrução para fazer a coisa. Prompte o **positivo** — declare o comportamento-alvo ("escreva comentários de uma linha") para o banido nunca ser falado. Uma proibição merece seu lugar só como guardrail duro que você não consegue frasear no positivo; mesmo aí, pareie com o alvo positivo para a atenção pousar no que fazer.

## Poda

- Mantenha cada significado numa **single source of truth**: um lugar autoritativo, para mudar o comportamento ser um edit de um-lugar-só. **Duplicação** — o mesmo significado em mais de um lugar — custa manutenção e tokens, e infla a proeminência de um significado na escada além do seu rank real. (O inverso acidental de uma leading word, que repete um token de propósito, nunca o significado.)
- O **ambiente** é uma source of truth também — scripts do `package.json`, arquivos de config, o layout de diretórios, output de `--help` — e um documento que o restata é um **cache**: uma cópia de um lookup, merecendo sua carga só quando o lookup é caro. Cache o que o agent não consegue achar olhando: a convenção não-escrita, a razão por trás de uma escolha, o gotcha que nenhum config confessa. Deixe os lookups de um-arquivo, um-comando para o ambiente, onde não podem ficar obsoletos.
- Cheque cada linha por **relevância**: ela ainda incide sobre o que o documento faz? Uma linha perde relevância por nunca incidir sobre a tarefa (mera exposição, ou um branch que deveria ser disclosed) ou por ficar obsoleta conforme o comportamento ou o mundo que descreve muda. Documentos mais curtos são mais fáceis de manter relevantes. Sem uma disciplina de poda, o destino default é **sedimento**: camadas obsoletas que assentam porque adicionar parece seguro e remover parece arriscado, até você ter que perfurar por elas para achar o que ainda é vivo.
- Cace **no-ops** frase por frase: uma instrução que o modelo já obedece por default paga carga para não dizer nada. O teste — ela muda o comportamento versus o default? — é relativo-ao-modelo, não relativo-ao-leitor: duas pessoas discordando sobre um no-op discordam sobre o default, e resolvem rodando o documento, não debatendo. Quando uma frase falha, delete a frase inteira em vez de aparar palavras dela. O teste também gradua leading words: uma palavra fraca demais para bater o default (_seja minucioso_ quando o agent já é meio-minucioso) é um no-op, e a correção é uma palavra mais forte (_implacável_), não uma técnica diferente.
