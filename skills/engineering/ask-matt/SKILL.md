---
name: ask-matt
description: Pergunte qual skill ou fluxo encaixa na sua situação. Um router sobre as skills deste repo.
disable-model-invocation: true
---

# Ask Matt

Você não lembra de todas as skills, então pergunte.

Um **flow** é um caminho através das skills. A maioria dos caminhos segue um **main flow**, e alguns **on-ramps** se fundem nele. Todo o resto é standalone, ou uma camada de vocabulário que roda por baixo.

## O main flow: ideia → ship

O caminho que a maioria do trabalho percorre. Você tem uma ideia e quer que seja construída.

1. **`/grill-with-docs`** — afie a ideia com uma entrevista. Comece aqui sempre que você estiver **trabalhando em um working directory**: é stateful, retém o que aprende em `CONTEXT.md` e ADRs. (Sem working directory? Use `/grill-me` — veja Standalone. Os dois rodam a mesma primitiva `/grilling`; `grill-with-docs` é o que deixa rastro em disco, o que faz dele o melhor dos dois sempre que houver um repo onde deixá-lo.)
2. **Branch — você consegue resolver toda questão na conversa?** Se uma questão precisa de uma resposta executável (estado, business logic, uma UI que você precisa ver), desvie por um prototype, conectado por **`/handoff`** em ambas direções (um prototype vive no próprio diretório, que é exatamente para o que `/handoff` serve — veja Phase boundaries):
   - **`/handoff`** para fora, depois abra uma sessão nova contra aquele arquivo,
   - **`/prototype`** para responder a questão com código descartável,
   - **`/handoff`** de volta o que aprendeu, e referencie do thread da ideia original.
3. **Branch — isso é um build multi-sessão?**
   - **Sim** → **`/to-spec`** (transforme o thread em uma spec), depois **`/to-tickets`** para quebrá-la em tickets tracer-bullet, cada um declarando suas **blocking edges**. Num tracker local, isso é um arquivo por ticket sob `.scratch/<feature>/issues/`, trabalhado blockers-primeiro na mão; num tracker de verdade, as edges viram links de blocking nativos, então qualquer ticket cujos blockers estejam prontos pode ser pego — dispare **`/implement`** por ticket, **dando `/clear` no contexto entre cada um**. Cada ticket é autocontido, então o contexto do último é descartável.
   - **Não** → **`/implement`** direto aqui, na mesma janela de contexto.

   De qualquer forma, **`/implement`** constrói cada ticket conduzindo **`/tdd`** internamente — uma slice red-green por vez — e fecha rodando **`/code-review`**, uma revisão em dois eixos (Standards + Spec) do diff, antes de commitar. Recorra a **`/tdd`** sozinha quando quiser só construir um comportamento concreto test-first, sem uma spec completa, e a **`/code-review`** sozinha sempre que quiser revisar um branch ou PR contra um ponto fixo.

### Hygiene de contexto

Mantenha os passos 1–3 em **uma única janela de contexto ininterrupta** — não compacte ou limpe até depois de `/to-tickets` — para que a sabatina, a spec e os tickets construam sobre o mesmo pensamento. Cada `/implement` depois inicia fresco, trabalhando a partir do ticket.

O limite disso é a **[smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone)**: a janela (~150k tokens em modelos state-of-the-art) dentro da qual o modelo ainda raciocina com nitidez. Se uma sessão se aproximar disso antes de `/to-tickets`, não force em degradado — dê `/compact` no phase boundary mais próximo e siga (veja Phase boundaries).

## On-ramps

Uma situação de partida que gera trabalho, depois se funde no main flow.

- **Bugs e requests se acumulando** → **`/triage`**. Move issues através de roles de triage e produz issues agent-ready, que **`/implement`** depois pega.

  Triage é só para issues que **você não criou** — bug reports, feature requests que chegam, qualquer coisa que chega crua. Tickets que `/to-tickets` produziu já são agent-ready, então **não os triagem**.

- **Alguma coisa quebrou** → **`/diagnosing-bugs`**. Para os difíceis: o bug que resiste à primeira olhada, o flake intermitente, a regressão que se infiltrou entre dois estados sabidamente bons. Ela se recusa a teorizar até ter um **tight feedback loop** — um comando que já fica **red** _neste_ bug — e então corrige com um teste de regressão. Seu post-mortem faz handoff para **`/improve-codebase-architecture`** quando a descoberta real é que não existe um bom seam para prender o bug.

- **Uma empreitada enorme e enevoada — um projeto greenfield ou um build de feature grande demais para uma sessão** → **`/wayfinder`**, o fluxo mais cognitivamente exigente aqui. Quando o caminho daqui até o destino ainda não é visível, ela traça um **mapa compartilhado** de **decision tickets** no issue tracker e os resolve um por vez — produzindo **decisões, não entregáveis** — até a névoa recuar e o caminho ficar claro. Onde **`/grill-with-docs`** afia uma ideia que cabe numa sessão, o wayfinder é para a ideia que não cabe — e é mais lento e mais denso, então guarde-o exatamente para isso, nunca para uma feature bem escopada.

  Quando o mapa clareia, **ela faz handoff, não constrói**: funda-se ao main flow em **`/to-spec`**, que colapsa as decisões linkadas do mapa num plano construível, depois `/to-tickets` e `/implement` como de costume. Loopar o mapa direto no `/implement` pula esse colapso e joga fora o detalhe linkado — vá direto ao `/implement` só quando a empreitada se revelou genuinamente pequena.

## Saúde da codebase

Não trabalho de feature — manutenção.

- **`/improve-codebase-architecture`** — rode sempre que tiver um momento livre para manter a codebase boa para agents operarem. Ela expõe **deepening opportunities**; escolher uma _gera uma ideia_ que você pode levar para o main flow em `/grill-with-docs`. Ela é o levantamento que acha os candidatos; **`/codebase-design`** (abaixo) é a bancada onde você projeta o escolhido.

## Vocabulário por baixo

Duas referências model-invoked que rodam *por baixo* das outras skills — cada uma a single source of truth do seu vocabulário. Recorra a elas direto quando o problema forem as **palavras**, não o processo; ou deixe que as skills acima as puxem.

- **`/domain-modeling`** — afia a linguagem de *domínio* do projeto: questiona um termo difuso, resolve uma palavra sobrecarregada ("conta" fazendo três trabalhos), registra uma decisão difícil de reverter como um ADR. É a disciplina ativa que `/grill-with-docs` conduz para manter o `CONTEXT.md` um glossário limpo.
- **`/codebase-design`** — o vocabulário de deep modules (module, interface, depth, seam, adapter, leverage, locality) para projetar o *formato* de um módulo: muito comportamento atrás de uma interface pequena, num seam limpo. `/tdd` e `/improve-codebase-architecture` falam essa língua.

## Phase boundaries

Uma **fase** é um pedaço de trabalho dentro de uma sessão — a sabatina, a implementação, o QA. No **boundary** entre duas delas você tem cinco opções, e escolher entre elas é a decisão mais nebulosa deste mapa inteiro:

- **Continue** — fique onde está. Não custa nada, não perde nada.
- **`/clear`** — esvazie a janela, quando nada aqui importa para o que vem a seguir.
- **`/handoff`** — escreva um arquivo markdown portável. Estreito: só para um **novo harness**, um **novo diretório**, um **colega**, ou bifurcar uma tarefa lateral **no meio da fase**. O que ele compra é portabilidade.
- **Subagent** — mande uma tarefa bem escopada para a própria janela e receba um relatório de volta.
- **`/compact`** — comprima este contexto e semeie uma sessão fresca com ele. O **default**, no fundo da árvore em vez de a primeira escolha.

Leia [PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md) para a árvore ordenada — as cinco perguntas, o raciocínio por trás de cada branch, e por que o custo de primary-source faz **Continue** ser a primeira a descartar. Tome a decisão **em** um boundary; no meio da fase, continue ou divida o resto em subagents.

## Standalone

Fora do main flow completamente.

- **`/grill-me`** — a mesma entrevista implacável que `/grill-with-docs`, mas **stateless**: não salva nada localmente e não constrói `CONTEXT.md`. Recorra a ela quando você **não estiver trabalhando em um working directory** — afiando um plano, um design, um texto, qualquer coisa sem um repo por baixo. Se você está em um working directory, use `/grill-with-docs`: roda a mesma entrevista e deixa rastro, então é estritamente a melhor.
- **`/grilling`** — a primitiva da entrevista em si: rodadas, a frontier, fatos são trabalho do agent e decisões são suas. `/grill-me` e `/grill-with-docs` são as duas portas de entrada nomeadas, e `/triage`, `/wayfinder` e `/improve-codebase-architecture` todas a rodam internamente. Recorra a ela direto só quando quiser a entrevista sem nenhum wrapper em volta.
- **`/resolving-merge-conflicts`** — trabalhe um conflito de merge ou rebase em andamento hunk por hunk, resolvendo por **intenção** rastreada à fonte primária de cada lado em vez de escolher linhas, depois finalize a operação. Nunca roda `--abort`. Standalone e fora de todo fluxo: recorra a ela quando você já está no meio do conflito.
- **`/prototype`** — um programa pequeno e descartável que responde a uma pergunta de design: este modelo de estado faz sentido, ou como esta UI deveria ser. Descartável é uma restrição de como o código é escrito, não uma promessa de destruí-lo: a resposta se dobra no código real, e o próprio prototype é guardado como **fonte primária** num branch `prototype/<name>` fora do main, apontado a partir da issue de implementação. É o desvio do passo 2 do main flow, mas recorra a ele sempre que uma pergunta de design for difícil de resolver no papel.
- **`/research`** — delegue o trabalho braçal de leitura a um **background agent**: ele investiga uma pergunta contra **fontes primárias** e deixa um arquivo Markdown citado no repo. Você segue trabalhando enquanto ele lê. O arquivo que ele produz é algo para levar *para dentro* do main flow em `/grill-with-docs` — pesquisa alimenta o pensamento, não o substitui.
- **`/to-questionnaire`** — quando o que te trava não está na sua cabeça nem na codebase, mas na de **outra pessoa**, isso escreve a ela um questionário para preencher. É o inverso de `/grill-me`: em vez de te entrevistar sobre o assunto, te entrevista sobre o **envio** — para quem vai, o que você precisa de volta — e mira as perguntas no gap. O que volta é material para `/grill-with-docs` ou `/to-spec`.
- **`/wizard`** — para os passos que só um **humano** pode dar: provisionar infraestrutura, configurar credenciais ou secrets de CI, clicar por um dashboard de terceiros desconhecido, rodar uma migração/cutover pontual. Ela gera um script bash interativo que abre cada URL, captura cada valor e o escreve em `.env` e secrets do GitHub — para o procedimento parar de ser algo que você reexplica a um agent toda vez. Model-invoked, então o agent recorre a ela no momento em que bate numa parede que só você pode passar. Se o agent conseguisse fazer sozinho, deveria; isto é para onde um humano está genuinamente no loop.
- **`/wait-what`** — o corretivo para uma mensagem que não pegou. Use no meio da conversa, dentro de qualquer outra skill, e o agent repropõe o que acabou de dizer com o contexto que faltava, em português simples, usando o vocabulário do `CONTEXT.md`. Funciona depois do fato; `/grill-with-docs` é a cura antecipada, porque uma linguagem compartilhada acordada cedo é o que impede o jargão de chegar.
- **`/teach`** — aprenda um conceito ao longo de múltiplas sessões, usando o diretório atual como workspace stateful.
- **`/writing-for-agents`** — referência para escrever documentos que agents consomem: skills, AGENTS.md, docs apontadas.

## Pré-condição

**`/setup-leandrocfe-skills`** — rode antes do seu primeiro fluxo de engineering para configurar o issue tracker, triage labels e layout de docs que as outras skills assumem. Issue trackers customizados também funcionam.
