---
name: grill-with-docs
description: "Sessão de sabatina que confronta seu plano contra o domain model existente, refina terminologia e atualiza documentação (CONTEXT.md, ADRs) inline conforme as decisões cristalizam. Use quando o usuário quiser stress-test de plano contra a linguagem e decisões documentadas do projeto. Use when user wants to stress-test a plan against their project's language and documented decisions."
---

<what-to-do>

Me sabatine sem dó sobre cada aspecto deste plano até chegarmos a um entendimento compartilhado. Caminhe por cada ramo da design tree, resolvendo dependências entre decisões uma-a-uma. Para cada pergunta, forneça sua resposta recomendada.

Faça as perguntas uma de cada vez, esperando feedback de cada uma antes de continuar.

Se uma pergunta pode ser respondida explorando a codebase, explore a codebase em vez.

</what-to-do>

<supporting-info>

## Consciência de domínio

Durante a exploração da codebase, procure também por documentação existente:

### Estrutura de arquivos

A maioria dos repos tem um único contexto:

```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

Se um `CONTEXT-MAP.md` existir na raiz, o repo tem múltiplos contextos. O mapa aponta onde cada um vive:

```
/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/                          ← decisões de sistema todo
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/                 ← decisões específicas do contexto
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/
```

Crie arquivos com preguiça — só quando tiver algo para escrever. Se nenhum `CONTEXT.md` existir, crie um quando o primeiro termo for resolvido. Se nenhum `docs/adr/` existir, crie quando o primeiro ADR for necessário.

## Durante a sessão

### Confronte contra o glossário

Quando o usuário usar um termo que conflita com a linguagem existente em `CONTEXT.md`, aponte imediatamente. "Seu glossário define 'cancellation' como X, mas você parece querer dizer Y — qual é?"

### Refine linguagem fuzzy

Quando o usuário usar termos vagos ou sobrecarregados, proponha um termo canônico preciso. "Você está dizendo 'account' — quer dizer Customer ou User? São coisas diferentes."

### Discuta cenários concretos

Quando relações de domínio estiverem sendo discutidas, faça stress-test com cenários específicos. Invente cenários que sondam edge cases e forçam o usuário a ser preciso sobre as fronteiras entre conceitos.

### Cross-referencie com o código

Quando o usuário disser como algo funciona, cheque se o código concorda. Se achar uma contradição, traga à tona: "Seu código cancela Orders inteiras, mas você acabou de dizer que cancelamento parcial é possível — qual é o certo?"

### Atualize CONTEXT.md inline

Quando um termo for resolvido, atualize o `CONTEXT.md` ali mesmo. Não faça batch — capture conforme acontecem. Use o formato em [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

Não acople `CONTEXT.md` a detalhes de implementação. Inclua só termos que são significativos para domain experts.

### Ofereça ADRs com parcimônia

Só ofereça criar um ADR quando os três forem verdade:

1. **Difícil de reverter** — o custo de mudar de ideia depois é significativo
2. **Surpreendente sem contexto** — um leitor futuro vai se perguntar "por que fizeram desse jeito?"
3. **Resultado de um trade-off real** — havia alternativas genuínas e você escolheu uma por razões específicas

Se qualquer um dos três faltar, pule o ADR. Use o formato em [ADR-FORMAT.md](./ADR-FORMAT.md).

</supporting-info>
