---
name: to-prd
description: Compacta a conversa atual em PRD bem-formado (problema, requisitos, critérios de aceitação, fora de escopo) e submete ao Rastreador de Issues. Use quando usuário pedir "gerar PRD", "criar documento de produto", "transformar isso em PRD", "documentar essa feature", ou invocar /to-prd. Triggers: "to PRD", "product requirements", "spec".
---

# to-prd

Transforma uma conversa exploratória em um PRD (Product Requirements Document) curto e acionável, e submete ao Rastreador de Issues. Combate o anti-padrão de feature começar a ser implementada sem nada escrito além de "vamos fazer um sistema de X".

## <o-que-fazer>

### Passo 1 — Confirmar entrada

Verifique:

- Existe contexto suficiente na conversa? (Algum grill aconteceu? Tem decisões claras?)
- Se não, **pare e proponha** rodar [grill-me](../grill-me/SKILL.md) ou [grill-with-docs](../grill-with-docs/SKILL.md) primeiro.
- Pergunte ao usuário **qual feature/iniciativa** este PRD descreve (se a conversa cobriu várias coisas).

### Passo 2 — Coletar decisões

Extraia da conversa:

- **Problema** que motivou (não a solução)
- **Quem é afetado** (usuário, persona, sistema)
- **O que precisa ser verdadeiro** ao fim (critérios de aceitação concretos)
- **O que está deliberadamente fora** desta entrega
- **Decisões em aberto** (registradas como tal, não escondidas)
- **Restrições conhecidas** (prazo, integração, compliance, tech existente)

### Passo 3 — Escrever PRD usando o template

Use o template abaixo. Mantenha curto: PRD bom cabe em ~1 página A4.

```markdown
# PRD — <título da feature>

**Data:** YYYY-MM-DD
**Autor:** <quem>
**Status:** Rascunho | Em revisão | Aprovado

## Problema

<1 parágrafo. O que dói hoje. Para quem. Por quê isso importa agora.>

## Quem é afetado

<Persona ou perfil. Pode ter mais de um — listar prioridade.>

## Critérios de aceitação

Esta entrega é considerada **completa** quando:

- [ ] <Critério 1 — observável, testável>
- [ ] <Critério 2>
- [ ] <Critério 3>

## Fora de escopo

Esta entrega **não** inclui:

- <Item explícito 1>
- <Item explícito 2>

## Decisões em aberto

- [ ] <Decisão 1 — quem decide e quando>
- [ ] <Decisão 2>

## Restrições

- <Restrição técnica/prazo/compliance>

## Notas

<Qualquer contexto que ajude quem vai implementar mas não cabe nas seções acima.>
```

### Passo 4 — Validar com o usuário

Apresente o PRD para o usuário **antes** de submeter. Pergunte:

- Algum critério de aceitação faltando?
- Algo que deveria estar em "fora de escopo" que não está?
- Algum aspecto do problema que mudou de prioridade depois desta conversa?

Iterar até o usuário aprovar **explicitamente**.

### Passo 5 — Submeter ao Rastreador de Issues

Pergunte qual é o Rastreador (GitHub Issues default — ver `CONTEXT.md`). Crie issue tipo "PRD" ou "Epic" com:

- **Título:** `[PRD] <título da feature>`
- **Corpo:** conteúdo completo do PRD em markdown
- **Labels:** `prd`, `epic`, e domínio relevante se houver
- **Assignee:** geralmente o usuário, ou em aberto

Para GitHub via `gh`:

```bash
gh issue create \
  --title "[PRD] <título>" \
  --body-file /tmp/prd.md \
  --label prd,epic
```

Retorne a URL do issue criado para o usuário.

### Passo 6 — Próximo passo

Sugira (não execute sem permissão):

- Rodar [to-issues](../to-issues/SKILL.md) para quebrar o PRD em tickets de implementação
- Rodar [tdd](../tdd/SKILL.md) se já tem fatia vertical clara para começar

## <info-de-apoio>

### Anti-padrões

- **NÃO descreva a solução no campo Problema.** "Precisamos de um botão de cancelar" é solução. "Usuários não conseguem desfazer compra acidental" é problema. Solução vai em outro lugar (spec técnica, plano de implementação).
- **NÃO escreva critério de aceitação subjetivo.** "Interface ficar boa" não é critério. "Usuário consegue cancelar compra em ≤ 2 cliques após confirmação" é.
- **NÃO esconda decisões em aberto.** Liste-as. PRD honesto > PRD que finge estar completo.
- **NÃO inflar.** 5 páginas de PRD = ninguém lê. Comprima.
- **NÃO confunda PRD com spec técnica.** PRD = problema + critério. Spec = como resolver. Separar ajuda revisões em momentos certos.
- **NÃO submeta sem confirmação.** Sempre revisar com o usuário antes de criar issue.

### Quando NÃO criar PRD

- Bug fix isolado → vira issue direto, sem PRD
- Refatoração interna sem impacto observável → ADR é o lugar
- Spike / prototype descartável → comentário em conversa basta

### Diferença: PRD vs spec técnica

| | PRD | Spec técnica |
|---|---|---|
| Pergunta central | "O que precisa estar verdadeiro?" | "Como vamos fazer?" |
| Audiência | Stakeholders, time | Implementador, revisor |
| Detalhe | Critério observável | Estrutura de dado, endpoint, sequência |
| Localização | Issue tipo PRD/Epic | Comentário no PRD ou ADR vinculado |

Não misturar.

### Exemplo: PRD compacto

```markdown
# PRD — Cancelamento de pedido em até 1h

**Data:** 2026-05-11
**Autor:** @leandrocfe
**Status:** Rascunho

## Problema

Suporte recebe 30+ tickets/semana de usuários querendo cancelar pedido feito por acidente.
Hoje só admin consegue cancelar, com SLA de 2 dias. Usuários migram para concorrentes.

## Quem é afetado

- Usuário comprador (principal)
- Time de suporte (alívio operacional)

## Critérios de aceitação

- [ ] Usuário pode cancelar pedido próprio se status = "aguardando pagamento" ou "pagamento confirmado" e < 1h desde criação
- [ ] Após 1h ou status "em separação", botão de cancelar não aparece
- [ ] Cancelamento estorna pagamento via gateway em até 5 dias úteis
- [ ] Suporte vê motivo do cancelamento no painel
- [ ] Email de confirmação enviado ao usuário

## Fora de escopo

- Cancelamento parcial (cancelar 1 item de pedido com 3)
- Cancelamento após "em separação"
- Política de devolução de produto físico

## Decisões em aberto

- [ ] Motivo do cancelamento — lista fechada ou campo livre? (Decidir com produto até 2026-05-15)

## Restrições

- Gateway de pagamento atual não suporta estorno parcial — confirmar antes
- Janela de 1h decidida em discussão com produto; pode evoluir

## Notas

Concorrente X oferece 30min, concorrente Y oferece 24h. Escolha de 1h é equilíbrio entre
flexibilidade ao usuário e overhead operacional do estorno.
```

## Cross-references

- [grill-me](../grill-me/SKILL.md) / [grill-with-docs](../grill-with-docs/SKILL.md) — entrada típica antes do `to-prd`
- [to-issues](../to-issues/SKILL.md) — destino comum: quebrar o PRD em tickets
- [`CONTEXT.md`](../../CONTEXT.md) — definição de PRD e Rastreador de Issues
