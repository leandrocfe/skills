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

1. **`/grill-with-docs`** — afie a ideia com uma entrevista. Comece aqui quando você **tem uma codebase**: é stateful, retém o que aprende em `CONTEXT.md` e ADRs. (Sem codebase? Use `/grill-me` — veja Standalone. Os dois rodam a mesma primitiva `/grilling`; `grill-with-docs` é o que deixa rastro em disco.)
2. **Branch — você consegue resolver toda questão na conversa?** Se uma questão precisa de uma resposta executável (estado, business logic, uma UI que você precisa ver), desvie por um prototype, conectado por **`/handoff`** em ambas direções (veja Crossing sessions):
   - **`/handoff`** para fora, depois abra uma sessão nova contra aquele arquivo,
   - **`/prototype`** para responder a questão com código descartável,
   - **`/handoff`** de volta o que aprendeu, e referencie do thread da ideia original.
3. **Branch — isso é um build multi-sessão?**
   - **Sim** → **`/to-spec`** (transforme o thread em uma spec), depois **`/to-tickets`** para quebrá-la em tickets tracer-bullet, cada um declarando suas **blocking edges**. Num tracker local, isso é um `tickets.md` ordenado que você trabalha na mão; num tracker de verdade, as edges viram links de blocking nativos, então qualquer ticket cujos blockers estejam prontos pode ser pego — dispare **`/implement`** por ticket, **limpando o contexto entre cada um**.
   - **Não** → **`/implement`** direto aqui, na mesma janela de contexto.

   De qualquer forma, **`/implement`** constrói cada ticket conduzindo **`/tdd`** internamente — uma slice red-green por vez — e fecha rodando **`/code-review`**, uma revisão em dois eixos (Standards + Spec) do diff, antes de commitar. Recorra a **`/tdd`** sozinha quando quiser só construir um comportamento concreto test-first, sem uma spec completa, e a **`/code-review`** sozinha sempre que quiser revisar um branch ou PR contra um ponto fixo.

### Hygiene de contexto

Mantenha os passos 1–3 em **uma única janela de contexto ininterrupta** — não compacte ou limpe até depois de `/to-tickets` — para que a sabatina, a spec e os tickets construam sobre o mesmo pensamento. Cada `/implement` depois inicia fresco, trabalhando a partir do ticket.

O limite disso é a **[smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone)**: a janela (~120k tokens em modelos state-of-the-art) dentro da qual o modelo ainda raciocina com nitidez. Se uma sessão se aproximar disso antes de `/to-tickets`, não force em degradado — use `/handoff` e continue em um thread novo.

## On-ramps

Uma situação de partida que gera trabalho, depois se funde no main flow.

- **Bugs e requests se acumulando** → **`/triage`**. Move issues através de roles de triage e produz issues agent-ready, que **`/implement`** depois pega.

  Triage é só para issues que **você não criou** — bug reports, feature requests que chegam, qualquer coisa que chega crua. Tickets que `/to-tickets` produziu já são agent-ready, então **não os triagem**.

- **Alguma coisa quebrou** → **`/diagnosing-bugs`**. Para os difíceis: o bug que resiste à primeira olhada, o flake intermitente, a regressão que se infiltrou entre dois estados sabidamente bons. Ela se recusa a teorizar até ter um **tight feedback loop** — um comando que já fica **red** _neste_ bug — e então corrige com um teste de regressão. Seu post-mortem faz handoff para **`/improve-codebase-architecture`** quando a descoberta real é que não existe um bom seam para prender o bug.

- **Uma empreitada enorme e enevoada — um projeto greenfield ou um build de feature grande demais para uma sessão** → **`/wayfinder`**. Quando o caminho daqui até o destino ainda não é visível, ela traça um **mapa compartilhado** de tickets de investigação no issue tracker e os resolve um por vez — produzindo **decisões, não entregáveis** — até a névoa recuar e o caminho ficar claro. Depois ela se funde ao main flow em **`/to-spec`** (ou, se a empreitada se revelou pequena o bastante, direto em **`/implement`**). Onde **`/grill-with-docs`** afia uma ideia que cabe numa sessão, o wayfinder é para a ideia que não cabe.

## Saúde da codebase

Não trabalho de feature — manutenção.

- **`/improve-codebase-architecture`** — rode sempre que tiver um momento livre para manter a codebase boa para agents operarem. Ela expõe **deepening opportunities**; escolher uma _gera uma ideia_ que você pode levar para o main flow em `/grill-with-docs`. Ela é o levantamento que acha os candidatos; **`/codebase-design`** (abaixo) é a bancada onde você projeta o escolhido.

## Vocabulário por baixo

Duas referências model-invoked que rodam *por baixo* das outras skills — cada uma a single source of truth do seu vocabulário. Recorra a elas direto quando o problema forem as **palavras**, não o processo; ou deixe que as skills acima as puxem.

- **`/domain-modeling`** — afia a linguagem de *domínio* do projeto: questiona um termo difuso, resolve uma palavra sobrecarregada ("conta" fazendo três trabalhos), registra uma decisão difícil de reverter como um ADR. É a disciplina ativa que `/grill-with-docs` conduz para manter o `CONTEXT.md` um glossário limpo.
- **`/codebase-design`** — o vocabulário de deep modules (module, interface, depth, seam, adapter, leverage, locality) para projetar o *formato* de um módulo: muito comportamento atrás de uma interface pequena, num seam limpo. `/tdd` e `/improve-codebase-architecture` falam essa língua.

## Crossing sessions

- **`/handoff`** — quando um thread está cheio ou você precisa ramificar (ex: para uma sessão de `/prototype`), isso compacta a conversa em um arquivo markdown. Você não continua no lugar — você **abre uma nova sessão e referencia aquele arquivo** para carregar o contexto através. É a ponte entre janelas de contexto, em qualquer direção. Use quando quiser uma **sessão fresca** mas precisar da **conversa atual preservada**.
- **`/compact`** (built-in) — fique na **mesma conversa**, permitindo que as voltas anteriores sejam sumarizadas. Use em **quebras intencionais entre fases**, quando não se importa em perder o histórico verbatim. Não compacte no meio da fase — o agent pode perder o caminho. `/handoff` bifurca; `/compact` continua.

## Standalone

Fora do main flow completamente.

- **`/grill-me`** — a mesma entrevista implacável que `/grill-with-docs`, mas para quando você **não tem codebase**. Stateless: não salva nada localmente, não constrói `CONTEXT.md`. Recorra a ela para afiar qualquer plano ou design que não viva em um repo.
- **`/prototype`** — um programa pequeno e descartável que responde a uma pergunta de design: este modelo de estado faz sentido, ou como esta UI deveria ser. Descartável desde o dia um — guarde a resposta, apague o código. É o desvio do passo 2 do main flow, mas recorra a ele sempre que uma pergunta de design for difícil de resolver no papel.
- **`/research`** — delegue o trabalho braçal de leitura a um **background agent**: ele investiga uma pergunta contra **fontes primárias** e deixa um arquivo Markdown citado no repo. Você segue trabalhando enquanto ele lê. O arquivo que ele produz é algo para levar *para dentro* do main flow em `/grill-with-docs` — pesquisa alimenta o pensamento, não o substitui.
- **`/teach`** — aprenda um conceito ao longo de múltiplas sessões, usando o diretório atual como workspace stateful.
- **`/writing-great-skills`** — referência para escrever e editar skills bem.

## Pré-condição

**`/setup-leandrocfe-skills`** — rode antes do seu primeiro fluxo de engineering para configurar o issue tracker, triage labels e layout de docs que as outras skills assumem. Issue trackers customizados também funcionam.
