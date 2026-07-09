---
name: dev-pipeline
description: Roteador do ciclo completo de desenvolvimento — da ideia à entrega — encadeando grilling, to-prd, to-issues, triage, implement e review com regras explícitas de dimensionamento, decomposição e despacho de agentes.
argument-hint: "A feature/ideia a desenvolver, ou nada para retomar trabalho em andamento"
disable-model-invocation: true
---

# Dev Pipeline

Orquestra o ciclo de vida de uma feature reutilizando as skills existentes. Você não implementa as fases aqui — você **localiza o estado atual, aplica as regras de decisão, executa o que é seu, e diz ao usuário o comando exato da próxima fase**.

O issue tracker e vocabulário de triage labels devem ter sido fornecidos a você — rode `/setup-leandrocfe-skills` se não.

Skills user-invoked (`to-prd`, `to-issues`, `triage`, `implement`, `handoff`) só o usuário roda: seu papel é dizer *quando* e *por quê*. Skills model-invoked (`grilling`, `tdd`, `review`) você invoca diretamente na fase certa.

## 1. Localize o estado

Antes de propor qualquer coisa, descubra em que fase o trabalho está. Explore, não pergunte:

- Argumento do usuário descreve ideia nova? → fase de dimensionamento.
- Existe PRD no tracker sem issues derivadas? → fase de decomposição.
- Existem issues abertas sem brief/labels de triage? → fase de triage.
- Existem issues prontas (com brief) sem branch? → fase de despacho.
- Existe branch em andamento? → fase de implementação ou review (olhe o diff).

Anuncie a fase detectada em uma frase e siga dali. Nunca reinicie o pipeline do zero se há trabalho em voo.

## 2. Dimensione (fase 0)

Uma feature nova passa primeiro pelo dimensionamento. Três saídas possíveis:

| Tamanho | Critério | Rota |
|---|---|---|
| **Trivial** | < ~1h, 1–2 arquivos, zero ambiguidade | Sem artefato. Implemente direto nesta sessão (branch + PR se repo usa PRs). |
| **Pequeno** | Cabe em 1 sessão e 1 PR, escopo claro | Sem PRD. Escreva spec curta (uma issue única no tracker, ou `.md` se tracker é markdown local) e vá direto a implementação. |
| **Médio/Grande** | > 1 sessão, ou > 1 agente em paralelo, ou ambiguidade real de escopo | Pipeline completo (seção 3). |

Regra de ouro: **> 1 sessão de trabalho OU > 1 agente em paralelo → issues no tracker. Senão, o mínimo possível.** Na dúvida entre pequeno e médio, pergunte uma única pergunta ao usuário; não infle escopo por precaução.

## 3. Pipeline completo (médio/grande)

Cada fase termina num gate: artefato produzido, usuário revisa, você indica o próximo comando.

| Fase | Quem executa | Artefato | Gate — próximo passo |
|---|---|---|---|
| Esclarecer | Você, via skill `grilling` (invoque direto) | Entendimento compartilhado na conversa | "Rode `/to-prd` para consolidar" |
| Especificar | Usuário: `/to-prd` | PRD enxuto no tracker | "Rode `/to-issues` sobre o PRD" |
| Decompor | Usuário: `/to-issues` | Issues em vertical slices | "Rode `/triage` para classificar e escrever briefs" |
| Triar + rotear | Usuário: `/triage`; você aplica a tabela da seção 4 durante a triage | Issues com brief + label `agent:*` | "Rode `/implement` na issue #N" (indique a primeira pela ordem de dependência) |
| Implementar | Usuário: `/implement`; use `tdd` nos seams acordados | Branch + commits + PR | Invoque `review` |
| Revisar | Você, via skill `review` (invoque direto) | Achados sobre o diff | Aprovado → merge. Problemas → volta a implementar. |
| Continuar | — | — | Mais issues na mesma sessão → próxima issue. Nova sessão → "Rode `/handoff`". Fim → feche o PRD. |

## 4. Roteamento de agente e runtime

Dois eixos independentes, decididos na triage, gravados como dois labels na issue.

**Eixo 1 — role.** Três perguntas, na ordem; a primeira resposta "sim" decide:

1. **Há decisão de design ou trade-off em aberto?** → `agent:architect`
2. **Caminho conhecido, mas exige julgamento?** → `agent:builder`
3. **Mecânico, sem ambiguidade?** → `agent:runner`

Advisor atua só antes do código (grilling, escopo). Reviewer só depois (fase de review).

**Eixo 2 — runtime.** Qual ferramenta/modelo executa. Tabela default (ajuste ao seu setup; o mapeamento role→runtime default vive aqui, a exceção vive no label):

| Role | Runtime default | Racional |
|---|---|---|
| `agent:architect` | Claude Code, modelo top | Raciocínio profundo, trade-offs |
| `agent:builder` | Claude Code modelo médio, ou Codex | Implementação padrão |
| `agent:runner` | O mais rápido/barato disponível (Codex mini, Grok fast, Haiku) | Mecânico, volume |

Label `runtime:*` só quando foge do default (ex.: `runtime:codex` num architect). Regra de review: **autor e reviewer de runtimes/vendors diferentes** sempre que possível — cross-model review pega mais defeito que auto-review.

Os labels vão na issue para que o despacho nunca seja re-decidido.

### Despacho entre runtimes

O brief autocontido é a interface — qualquer CLI pega a issue sem contexto extra. Dois modos:

- **Manual**: usuário abre o runtime indicado pelo label num worktree da issue e aponta para o brief (`gh issue view N`).
- **Headless**: uma sessão orquestradora despacha via shell — ex. `codex exec --full-auto "implemente a issue #N; brief em: gh issue view N"` dentro do worktree; equivalente para outros CLIs. Orquestrador só despacha e coleta; não implementa em paralelo ao worker.

Em ambos os modos o resultado volta pelo mesmo canal: branch + PR referenciando a issue. O pipeline não sabe nem precisa saber qual runtime produziu o diff.

## 5. Contexto e paralelismo

**Agentes stateless, artefatos stateful.** Contexto nunca vive em memória de conversa:

- O **brief da issue** é autocontido — quem pega a issue não precisa de mais nada. Um agente prepara trabalho para outro escrevendo o brief.
- O **PRD** carrega o porquê; a issue linka para ele.
- A **descrição do PR** carrega o que foi feito, para o review.
- `/handoff` só para trabalho *interrompido no meio* de uma issue — nunca como substituto de brief.

Paralelismo sem conflito:

- 1 issue = 1 branch = 1 agente. Paralelo local → git worktrees.
- O brief lista os arquivos que a issue toca. Não despache em paralelo issues com interseção de arquivos.
- Dependências viram ordem explícita: `blocked-by: #N` na issue. Despache apenas issues desbloqueadas.

## 6. Git

- Branch: `feat/<n>-slug-curto` (número da issue no nome).
- Conventional commits; `Closes #N` no corpo do PR.
- PR pequeno (~alvo: revisável em uma sentada), merge incremental.

## Anti-padrões

- Não crie PRD para trabalho pequeno — dimensionamento existe para isso.
- Não escreva specs em `.md` soltos quando o tracker está configurado — artefato órfão não tem estado nem dono.
- Não pule a triage "porque a issue é óbvia" — o label `agent:*` e o brief são o que permite despacho sem re-análise.
- Não acumule fases numa resposta só — um gate por vez; o usuário revisa o artefato antes da fase seguinte.
