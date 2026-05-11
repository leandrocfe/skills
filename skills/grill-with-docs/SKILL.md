---
name: grill-with-docs
description: Sessão de grill que confronta o plano contra o domínio documentado (CONTEXT.md, ADRs) e atualiza a documentação inline conforme decisões cristalizam. Use quando usuário disser "questione com docs", "validar contra domínio", "estressar plano com ADRs", "atualizar CONTEXT.md", ou invocar /grill-with-docs. Triggers: "grill with docs", "validate against docs", "domain model".
---

# grill-with-docs

Variante de [grill-me](../grill-me/SKILL.md) que **lê o domínio antes de perguntar** e **atualiza a documentação durante** a entrevista. Combate dois anti-padrões em paralelo:

1. Plano que ignora termos e decisões já tomadas no projeto
2. CONTEXT.md / ADRs que viram letra morta porque ninguém atualiza

## <o-que-fazer>

### Passo 1 — Ler o domínio antes

Antes da primeira pergunta, leia:

1. `CONTEXT.md` na raiz do projeto (vocabulário canônico)
2. `docs/adr/` se existir (decisões arquiteturais registradas)
3. README de nível alto se houver glossário/visão geral

Faça um **inventário mental** de:

- Termos definidos (palavras que têm significado preciso no projeto)
- Decisões tomadas (ex: "usamos Postgres, não MySQL — ADR-003")
- Restrições (ex: "todo endpoint REST tem que ter teste de integração — ADR-007")

### Passo 2 — Pedir o plano

Como em `grill-me`, peça o plano em forma curta.

### Passo 3 — Detectar atritos com o domínio

Para cada decisão do plano, cheque:

- **Termo:** o plano usa palavra que tem significado canônico no CONTEXT.md? Está consistente?
- **Termo novo:** plano introduz conceito que vai virar termo canônico? Precisa entrar no CONTEXT.md.
- **Decisão já registrada:** algum ADR já cobre essa decisão? O plano respeita?
- **Decisão nova relevante:** plano toma decisão que merece virar ADR?
- **Restrição:** plano viola alguma restrição registrada?

### Passo 4 — Grelhar nos pontos de atrito

Como `grill-me`, **uma pergunta por vez**, focando primeiro nos atritos:

- "Você usou X, mas no CONTEXT.md X significa Y. É isso mesmo ou está usando em outro sentido?"
- "ADR-005 decidiu usar fila para esse tipo de evento. O plano evita fila. Por quê?"
- "Isso é uma nova decisão arquitetural? Faz sentido virar ADR agora?"

Para decisões nada-registradas mas estruturais: "Vale registrar como ADR antes de implementar?"

### Passo 5 — Atualizar docs **durante** a conversa

Conforme decisões cristalizam, atualize **inline**:

#### Atualizar `CONTEXT.md`

Quando um termo novo é nomeado canonicamente:

```markdown
## Notificação

Mensagem assíncrona enviada ao usuário por canal (email, push, in-app).

- Aceito como sinônimo: "alerta" em contexto explícito de monitoramento
- Rejeitar: "aviso" (vocabulário de UI, ambíguo)
```

Quando um termo existente ganha nova nuance:

- Adiciona nota sob o termo existente
- Não cria entrada duplicada

#### Criar ADR novo

Se a decisão é relevante (afeta arquitetura, é difícil de reverter, ou orienta decisões futuras), crie:

```
docs/adr/NNNN-<titulo-kebab>.md
```

Use o template abaixo. Numere sequencial. Commit junto com o código.

### Passo 6 — Resumo final

Como em `grill-me`, produza resumo do plano refinado. Adicione bloco extra:

```
## Mudanças no domínio
- CONTEXT.md: adicionado termo "Notificação"
- ADR-008: criado (Fila para notificações assíncronas)
```

## <info-de-apoio>

### Template de ADR

```markdown
# ADR-NNNN — <título-curto>

**Data:** YYYY-MM-DD
**Status:** Aceito  | Substituído por ADR-XX | Descontinuado

## Contexto

<O que está acontecendo. Por que essa decisão precisa ser tomada agora. Que restrições existem.>

## Alternativas consideradas

### Opção A — <nome>
- Prós:
- Contras:

### Opção B — <nome>
- Prós:
- Contras:

### Opção C — <nome>
- Prós:
- Contras:

## Decisão

<Opção escolhida e por quê — com referência aos critérios de decisão.>

## Consequências

- **Positivas:** ...
- **Negativas:** ...
- **A vigiar:** ...

## Referências

- Issue/PR: ...
- ADRs relacionados: ...
```

### Anti-padrões

- **NÃO escreva ADR depois.** ADR escrito após implementação é racionalização — vale pouco. Escreva durante a decisão.
- **NÃO crie ADR para coisa pequena.** "Usar `const` em vez de `let`" não é ADR. ADR é decisão arquitetural com consequências.
- **NÃO atualize CONTEXT.md unilateralmente.** Termos canônicos afetam todo o projeto. Pergunte ao usuário antes de adicionar/mudar termo principal.
- **NÃO ignore atrito.** Se o plano usa palavra com sentido diferente do CONTEXT.md, **isso é o atrito mais importante**, não um detalhe.
- **NÃO transforme grill em validação cega da doc.** Doc também pode estar errada/desatualizada. Se o plano expõe que a doc está errada, **a doc é que muda**, não o plano.

### Quando a doc está errada

Acontece. Sinais:

- Termo no CONTEXT.md não corresponde mais ao código
- ADR antigo cita ferramenta que foi trocada
- Restrição registrada não é mais respeitada e ninguém percebe

Quando você detecta:

1. **Confirme com o usuário** que a doc está obsoleta
2. **Atualize ou marque** com nota (`> Atualização YYYY-MM-DD: este termo evoluiu — veja ADR-NN`)
3. Se ADR foi substituído, marque status como `Substituído por ADR-XX`

### Exemplo de fluxo

**Usuário:** "Vou adicionar webhooks de saída quando issue muda de status."

**Você lê:** CONTEXT.md → "issue tem ciclo aberta → em triagem → priorizada → em progresso → em revisão → fechada". ADR-004 → "todo evento de domínio passa pela fila de eventos".

**Atritos detectados:**
1. "Mudança de status" no plano vs "ciclo definido" no CONTEXT.md — está usando o mesmo conjunto?
2. Webhook é saída externa — ADR-004 fala de fila interna, não cobre webhook. Decisão nova.

**Pergunta 1:** "Os status que disparam webhook são todos os do ciclo (CONTEXT.md), ou só alguns? Quais?"

**Resposta:** "Só 'fechada'. Pode incluir 'em progresso' no futuro."

**Você atualiza CONTEXT.md? Não — não inventou termo novo.**

**Pergunta 2:** "Webhook é síncrono (POST direto no momento do evento) ou async (passa pela fila de eventos do ADR-004)?"

**Resposta:** "Tem que ser async pra não bloquear. Vou enfileirar."

**Você cria ADR-008:** "Webhooks de saída usam a fila de eventos existente (ADR-004), com novo worker dedicado". Documenta consequências.

E o grill continua.

## Cross-references

- [grill-me](../grill-me/SKILL.md) — versão sem doc; use quando projeto ainda não tem CONTEXT.md/ADRs
- [`CONTEXT.md`](../../CONTEXT.md) — vocabulário canônico do seu plugin (este aqui)
- [to-prd](../to-prd/SKILL.md) — destino comum após o grill
