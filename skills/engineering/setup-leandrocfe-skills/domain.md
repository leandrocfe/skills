# Domain Docs

Como as engineering skills devem consumir a documentação de domínio deste repo ao explorar a codebase.

## Antes de explorar, leia estes

- **`CONTEXT.md`** na raiz do repo, ou
- **`CONTEXT-MAP.md`** na raiz do repo se existir — aponta para um `CONTEXT.md` por contexto. Leia cada um relevante ao tópico.
- **`docs/adr/`** — leia ADRs que tocam a área que você vai trabalhar. Em repos multi-context, cheque também `src/<context>/docs/adr/` para decisões com escopo de contexto.

Se qualquer um destes arquivos não existir, **prossiga em silêncio**. Não sinalize a ausência; não sugira criar antecipadamente. A skill produtora (`/grill-with-docs`) cria com preguiça quando termos ou decisões de fato são resolvidos.

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
├── docs/adr/                          ← decisões de sistema todo
└── src/
    ├── ordering/
    │   ├── CONTEXT.md
    │   └── docs/adr/                  ← decisões específicas do contexto
    └── billing/
        ├── CONTEXT.md
        └── docs/adr/
```

## Use o vocabulário do glossário

Quando seu output nomeia um conceito de domínio (em título de issue, proposta de refactor, hipótese, nome de teste), use o termo como definido em `CONTEXT.md`. Não derive para sinônimos que o glossário explicitamente evita.

Se o conceito que você precisa não está no glossário ainda, é um sinal — ou você está inventando linguagem que o projeto não usa (reconsidere) ou há um gap real (anote para `/grill-with-docs`).

## Sinalize conflitos de ADR

Se seu output contradiz um ADR existente, traga à tona explicitamente em vez de silenciosamente sobrepor:

> _Contradiz ADR-0007 (event-sourced orders) — mas vale reabrir porque…_
