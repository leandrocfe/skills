---
name: writing-great-skills
description: Referência para escrever e editar skills bem — o vocabulário e princípios que tornam uma skill previsível.
disable-model-invocation: true
---

Uma skill existe para arrancar determinismo de um sistema estocástico. **Previsibilidade** — o agent seguir o mesmo _processo_ toda execução, não produzir o mesmo output — é a virtude raiz; todo mecanismo abaixo a serve.

**Termos em negrito** estão definidos em [`GLOSSARY.md`](GLOSSARY.md); consulte lá para o significado completo.

## Invocation

Duas escolhas, trocando custos diferentes:

- Uma skill **model-invoked** mantém uma **description**, de forma que o agent pode dispará-la autonomamente _e_ outras skills podem alcançá-la (você ainda pode digitar o nome). Ela contribui para **context load** — a description fica na janela todo turno. Mecânica: omita `disable-model-invocation`, e escreva uma description voltada para model com rich trigger phrasing ("Use when the user wants…, mentions…").
- Uma skill **user-invoked** remove a description do alcance do agent: só você, digitando o nome, pode invocá-la — e nenhuma outra skill pode. Zero context load, mas gasta **cognitive load**: _você_ é o índice que precisa lembrar que ela existe. Mecânica: defina `disable-model-invocation: true`; a `description` vira human-facing — um resumo de uma linha, listas de triggers removidas.

Escolha model-invocation só quando o agent precisa alcançar a skill por conta própria, ou outra skill precisa. Se ela só é disparada à mão, torne user-invoked e pague zero context load.

Quando skills user-invoked se multiplicam além do que você consegue lembrar, esse cognitive load acumulado é curado por uma **router skill**: uma skill user-invoked que nomeia as outras e quando recorrer a cada uma.

## Escrevendo a description

Uma **description** model-invoked faz dois trabalhos — declara o que a skill é, e lista os **branches** que devem dispará-la. Cada palavra aumenta **context load**, então uma description merece poda ainda mais dura que o corpo:

- **Front-load a leading word da skill** — a description é onde ela faz seu trabalho de invocação.
- **Um trigger por branch.** Sinônimos que renomeiam um único branch são **duplication** — "build features using TDD … asks for test-first development" é um branch escrito duas vezes. Colapse; mantenha só branches genuinamente distintos.
- **Corte identidade que já está no corpo.** Mantenha a description só para triggers, mais qualquer cláusula de alcance "when another skill needs…".

## Hierarquia de informação

Uma skill é construída de dois tipos de conteúdo — **steps** e **reference** — que se misturam livremente: uma skill pode ser só steps, só reference, ou ambos. A decisão central é qual usar e onde cada um senta na **information hierarchy**, uma escada ranqueada por quão imediatamente o agent precisa do material:

1. **In-skill step** — uma ação ordenada em `SKILL.md`, o tier primário: o que o agent faz, em ordem. Cada step termina em um **completion criterion**, a condição que diz ao agent que o trabalho está feito. Torne _checkable_ (o agent consegue distinguir feito de não-feito?) e, onde importa, _exhaustive_ ("todo model modificado contabilizado", não "produza uma change list") — um critério vago convida **premature completion**.
2. **In-skill reference** — uma definição, regra ou fato em `SKILL.md`, consultado sob demanda. Frequentemente um set plano legítimo (toda regra de uma review num mesmo degrau) — um arranjo fino, não um smell. _Esta skill é toda reference._
3. **External reference** — reference empurrada para fora de `SKILL.md` para um arquivo separado, alcançado por um **context pointer**, carregado só quando o pointer dispara. (Vai de reference _disclosed_ — um arquivo irmão como `GLOSSARY.md`, ainda parte da skill — até reference **external** que vive fora do sistema de skills e qualquer skill pode apontar.)

Um completion criterion exigente dirige **legwork** profundo — a escavação que o agent faz dentro do trabalho — quer a skill tenha steps ou não, já que "toda regra aplicada" vincula reference plana tanto quanto "todo step feito" vincula uma sequência.

Empurre pouco demais para baixo e o topo incha; empurre demais e você esconde material que o agent realmente precisa. Essa tensão é toda a decisão.

**Progressive disclosure** é o movimento descendo a escada — para fora de `SKILL.md` para um arquivo linkado — para o topo ficar legível. Mecânica: um arquivo `.md` linkado na pasta da skill, nomeado pelo que contém (esta skill divulga suas definições completas para `GLOSSARY.md`). Algumas skills são usadas de mais de uma forma, e cada forma distinta é um **branch** — execuções diferentes tomando caminhos diferentes pela skill. Branching é o teste mais limpo de disclosure: inline o que todo branch precisa, e empurre por trás de um pointer o que só alguns branches alcançam. O _wording_ de um **context pointer**, não seu alvo, decide quando e quão confiavelmente o agent alcança o material.

Onde a escada decide _quão longe_ uma peça senta, **co-location** decide _o que senta ao lado_ uma vez lá: mantenha a definição de um conceito, regras e caveats sob um heading em vez de espalhados, para que ler uma parte traga seus vizinhos junto.

## Quando dividir

**Granularity** é quão finamente você divide skills, e cada corte gasta uma das duas loads, então divida só quando o corte valer. Dois cortes:

- **Por invocation** — separe uma skill **model-invoked** quando você tem uma **leading word** distinta que deve dispará-la sozinha, ou outra skill precisa alcançá-la. Você paga **context load** pela nova **description** sempre-carregada, então esse alcance independente precisa valer a pena.
- **Por sequência** — separe uma sequência de **steps** quando os steps ainda à frente (os **post-completion steps** de um step) tentam o agent a apressar o que está na frente (**premature completion**). Mantê-los fora de vista encoraja o agent a fazer mais **legwork** na tarefa atual.

## Pruning

Mantenha cada significado em uma **single source of truth**: um lugar autoritativo, para que mudar o comportamento seja uma edição em um só lugar.

Cheque cada linha por **relevance**: ela ainda impacta o que a skill faz?

Depois cace **no-ops** frase por frase, não só linha por linha: rode o no-op test em cada frase isoladamente, e quando uma falhar, delete a frase inteira em vez de aparar palavras dela. Seja agressivo — a maioria da prosa que falha deve ir, não ser reescrita.

## Leading words

Uma **leading word** é um conceito compacto que já vive no pretraining do modelo e com o qual o agent pensa enquanto roda a skill (ex.: _lesson_, _fog of war_, _tracer bullets_). Repetida ao longo do texto (embora não necessariamente — uma leading word forte pode bastar uma vez só), ela acumula uma definição distribuída e ancora uma região inteira de comportamento no menor número de tokens, recrutando priors que o modelo já tem.

Ela serve à predictability duas vezes. No corpo, ancora a _execution_: o agent alcança o mesmo comportamento toda vez que a palavra aparece. Na description, ancora a _invocation_: quando a mesma palavra vive nos seus prompts, docs e código, o agent liga essa linguagem compartilhada à skill e a dispara com mais confiabilidade.

Cace oportunidades de refatorar skills para usar leading words. Uma tríade soletrada em três lugares (**duplication**), uma description gastando uma frase para gesticular na direção de uma ideia — cada uma é uma passagem implorando para **colapsar** em um único token. Exemplos:

- "rápido, determinístico, baixo overhead" -> _tight_ — uma qualidade reenunciada ao longo de uma fase — numa única palavra pré-treinada (um loop _tight_).
- "um loop no qual você acredita" -> _red_ — converte um gate difuso num estado binário observável (o loop fica _red_ no bug, ou não fica).

Você ganha duas vezes: menos tokens, _e_ um gancho mais afiado para o agent pendurar o raciocínio. Assuma que toda skill carrega reenunciações que leading words aposentam — vá achá-las.

## Failure modes

Use estes para diagnosticar problemas que o usuário possa estar tendo com a skill.

- **Premature completion** — encerrar um step antes de estar genuinamente feito, com a atenção escorregando para _estar pronto_. Defesa, nesta ordem: afie primeiro o completion criterion (barato, local); só se ele for irredutivelmente difuso _e_ você observar a pressa, esconda os post-completion steps dividindo a sequência (o corte por sequência).
- **Duplication** — o mesmo significado em mais de um lugar. Custa manutenção e tokens, e infla a proeminência de um significado na escada acima do seu rank real.
- **Sediment** — camadas obsoletas que se depositam porque adicionar parece seguro e remover parece arriscado. O destino default de qualquer skill sem disciplina de pruning.
- **Sprawl** — uma skill simplesmente longa demais, mesmo quando cada linha está viva e é única. Prejudica legibilidade e manutenibilidade, e desperdiça tokens. A cura é a escada: divulgue **reference** atrás de pointers, e divida por **branch** ou sequência para que cada caminho carregue só o que precisa.
- **No-op** — uma linha que o modelo já obedece por default, então você paga load para não dizer nada. O teste: ela muda o comportamento em relação ao default? Uma leading word fraca (_seja thorough_ quando o agent já é meio thorough) é um no-op; a correção é uma palavra mais forte (_relentless_), não uma técnica diferente.
- **Negation** — dirigir por proibição sai pela culatra: _não pense num elefante_ nomeia o elefante e o torna mais disponível, não menos. Prompt o **positivo** — enuncie o comportamento alvo, para que o proibido nunca seja falado; guarde uma proibição só como guardrail duro que você não consegue formular positivamente, e mesmo aí emparelhe-a com o que fazer em vez disso.
