# Domain Docs

Como as engineering skills devem consumir a documentação de domínio deste repo ao explorar a codebase.

## Antes de explorar, leia estes

- **`CONTEXT.md`** na raiz do repo, ou
- **`CONTEXT-MAP.md`** na raiz do repo se existir — aponta para um `CONTEXT.md` por contexto. Leia cada um relevante para o tópico.
- **`docs/adr/`** — leia ADRs que tocam na área em que você vai trabalhar. Em repos multi-context, verifique também `src/<context>/docs/adr/` para decisões scoped ao contexto.

Se qualquer um destes arquivos não existir, **prossiga silenciosamente**. Não flag a ausência; não sugira criar upfront. A skill `/domain-modeling` (alcançada via `/grill-with-docs` e `/improve-codebase-architecture`) cria eles de forma lazy quando termos ou decisões realmente se resolvem.

## Estrutura de arquivos

Repo single-context (maioria dos repos):

```
/
├── CONTEXT.md
├── docs/adr/
│   ├── 0001-event-sourced-orders.md
│   └── 0002-postgres-for-write-model.md
└── src/
```

Repo multi-context (presença de `CONTEXT-MAP.md` na raiz):

```
/
├── CONTEXT-MAP.md
├── docs/adr/                          ← decisões de sistema
└── src/
    ├── ordering/
    │   ├── CONTEXT.md
    │   └── docs/adr/                  ← decisões específicas do contexto
    └── billing/
        ├── CONTEXT.md
        └── docs/adr/
```

## Use o vocabulário do glossário

Quando seu output nomear um conceito de domínio (em título de issue, proposta de refactor, hipótese, nome de teste), use o termo como definido em `CONTEXT.md`. Não desvie para sinônimos que o glossário explicitamente evita.

Se o conceito que você precisa não estiver no glossário ainda, isso é um sinal — ou você está inventando linguagem que o projeto não usa (reconsidere) ou há uma lacuna real (note para `/domain-modeling`).

## Flag conflitos de ADR

Se seu output contradizer um ADR existente, exponha explicitamente em vez de sobrescrever silenciosamente:

> _Contradiz ADR-0007 (event-sourced orders) — mas vale reabrir porque…_
