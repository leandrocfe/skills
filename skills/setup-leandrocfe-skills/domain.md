# Docs de Domínio

Como as skills de engenharia devem consumir a documentação de domínio deste repo ao explorar o codebase.

## Antes de explorar, ler

- **`CONTEXT.md`** na raiz do repo, ou
- **`CONTEXT-MAP.md`** na raiz se existir — ele aponta um `CONTEXT.md` por contexto. Leia cada um relevante ao tópico.
- **`docs/adr/`** — leia ADRs que tocam a área que você vai trabalhar. Em repos multi-contexto, também cheque `src/<context>/docs/adr/` pra decisões por contexto.

Se algum desses arquivos não existir, **prossiga em silêncio**. Não sinalize ausência; não sugira criar de cara. A skill produtora (`/grill-with-docs`) cria preguiçosamente quando termos ou decisões efetivamente são resolvidos.

## Estrutura

Repo contexto único (maioria):

```
/
├── CONTEXT.md
├── docs/adr/
│   ├── 0001-pedidos-event-sourced.md
│   └── 0002-postgres-pro-modelo-de-leitura.md
└── src/
```

Repo multi-contexto (presença de `CONTEXT-MAP.md` na raiz):

```
/
├── CONTEXT-MAP.md
├── docs/adr/                          ← decisões de sistema inteiro
└── src/
    ├── pedidos/
    │   ├── CONTEXT.md
    │   └── docs/adr/                  ← decisões do contexto pedidos
    └── faturamento/
        ├── CONTEXT.md
        └── docs/adr/
```

## Use o vocabulário do glossário

Quando sua saída nomear um conceito de domínio (título de issue, proposta de refator, hipótese, nome de teste), use o termo como definido em `CONTEXT.md`. **Não** desvie pra sinônimos que o glossário explicitamente evita.

Se o conceito que você precisa **ainda não está** no glossário, isso é sinal — ou você está inventando linguagem que o projeto não usa (reconsidere) ou existe um gap real (anote pra rodar `/grill-with-docs`).

## Sinalize conflitos com ADR

Se sua saída contradiz um ADR existente, **expor explicitamente** em vez de sobrescrever silenciosamente:

> _Contradiz ADR-0007 (pedidos event-sourced) — mas vale reabrir porque..._
