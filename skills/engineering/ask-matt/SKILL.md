---
name: ask-matt
description: Pergunte qual skill ou fluxo encaixa na sua situação. Um router sobre as user-invoked skills deste repo.
disable-model-invocation: true
---

# Ask Matt

Você não lembra de todas as skills, então pergunte.

Um **flow** é um caminho através das skills. A maioria dos caminhos segue um **main flow**, e dois **on-ramps** se fundem nele. Todo o resto é standalone.

## O main flow: ideia → ship

O caminho que a maioria do trabalho percorre. Você tem uma ideia e quer que seja construída.

1. **`/grill-with-docs`** — afie a ideia com uma entrevista. Comece aqui quando você **tem uma codebase**: é stateful, retém o que aprende em `CONTEXT.md` e ADRs. (Sem codebase? Use `/grill-me` — veja Standalone.)
2. **Branch — você consegue resolver toda questão na conversa?** Se uma questão precisa de uma resposta executável (estado, business logic, uma UI que você precisa ver), desvie por um prototype, conectado por **`/handoff`** em ambas direções (veja Crossing sessions):
   - **`/handoff`** para fora, depois abra uma sessão nova contra aquele arquivo,
   - **`/prototype`** para responder a questão com código descartável,
   - **`/handoff`** de volta o que aprendeu, e referencie do thread da ideia original.
3. **Branch — isso é um build multi-sessão?**
   - **Sim** → **`/to-prd`** (transforme o thread em um PRD) → **`/to-issues`** (quebre o PRD em issues independentemente pegáveis). Como as issues são independentes, **limpe o contexto entre cada uma**: inicie uma sessão fresca por issue e dispare **`/implement`** passando o PRD e a issue única para trabalhar.
   - **Não** → **`/implement`** direto aqui, na mesma janela de contexto.

### Hygiene de contexto

Mantenha os passos 1–3 em **uma única janela de contexto ininterrupta** — não compacte ou limpe até depois de `/to-issues` — para que a sabatina, PRD e issues construam sobre o mesmo pensamento. Cada `/implement` depois inicia fresco, trabalhando a partir da issue.

O limite disso é a **[smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone)**: a janela (~120k tokens em modelos state-of-the-art) dentro da qual o modelo ainda raciocina com nitidez. Se uma sessão se aproximar disso antes de `/to-issues`, não force em degradado — use `/handoff` e continue em um thread novo.

## On-ramps

Uma situação de partida que gera trabalho, depois se funde no main flow.

- **Bugs e requests se acumulando** → **`/triage`**. Move issues através de roles de triage e produz issues agent-ready, que **`/implement`** depois pega.

  Triage é só para issues que **você não criou** — bug reports, feature requests que chegam, qualquer coisa que chega crua. Issues que `/to-issues` produziu já são agent-ready, então **não as triagem**.

## Saúde da codebase

Não trabalho de feature — manutenção.

- **`/improve-codebase-architecture`** — rode sempre que tiver um momento livre para manter a codebase boa para agents operarem. Ela expõe oportunidades de deepening; escolher uma _gera uma ideia_ que você pode levar para o main flow em `/grill-with-docs`.

## Crossing sessions

- **`/handoff`** — quando um thread está cheio ou você precisa ramificar (ex: para uma sessão de `/prototype`), isso compacta a conversa em um arquivo markdown. Você não continua no lugar — você **abre uma nova sessão e referencia aquele arquivo** para carregar o contexto através. É a ponte entre janelas de contexto, em qualquer direção. Use quando quiser uma **sessão fresca** mas precisar da **conversa atual preservada**.
- **`/compact`** (built-in) — fique na **mesma conversa**, permitindo que as voltas anteriores sejam sumarizadas. Use em **quebras intencionais entre fases**, quando não se importa em perder o histórico verbatim. Não compacte no meio da fase — o agent pode perder o caminho. `/handoff` bifurca; `/compact` continua.

## Standalone

Fora do main flow completamente.

- **`/grill-me`** — a mesma entrevista implacável que `/grill-with-docs`, mas para quando você **não tem codebase**. Stateless: não salva nada localmente, não constrói `CONTEXT.md`. Recorra a ela para afiar qualquer plano ou design que não viva em um repo.
- **`/teach`** — ensine um conceito ao usuário em múltiplas sessões, usando o diretório atual como workspace de ensino stateful.
- **`/writing-great-skills`** — referência para escrever e editar skills bem.

## Pré-condição

**`/setup-leandrocfe-skills`** — rode antes do seu primeiro fluxo de engineering para configurar o issue tracker, triage labels e layout de docs que as outras skills assumem. Issue trackers customizados também funcionam.
