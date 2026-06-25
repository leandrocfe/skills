---
name: domain-modeling
description: Constrói e afia o modelo de domínio de um projeto. Use quando o usuário quiser fixar terminologia de domínio ou uma ubiquitous language, registrar uma decisão arquitetural, ou quando outra skill precisar manter o modelo de domínio.
---

# Domain Modeling

Constrói ativamente e afia o modelo de domínio do projeto conforme você projeta. Esta é a disciplina *ativa* — desafiando termos, inventando cenários de edge-case e escrevendo o glossário e decisões no momento em que cristalizam. (Apenas *ler* `CONTEXT.md` para vocabulário não é esta skill — isso é um hábito de uma linha que qualquer skill pode fazer. Esta skill é para quando você está mudando o modelo, não apenas consumindo.)

## Estrutura de arquivos

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

Se um `CONTEXT-MAP.md` existir na raiz, o repo tem múltiplos contextos. O map aponta para onde cada um vive:

```
/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/                          ← decisões de sistema
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/                 ← decisões específicas do contexto
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/
```

Crie arquivos de forma lazy — só quando tiver algo para escrever. Se não existir `CONTEXT.md`, crie um quando o primeiro termo for resolvido. Se não existir `docs/adr/`, crie quando o primeiro ADR for necessário.

## Durante a sessão

### Desafie contra o glossário

Quando o usuário usar um termo que conflita com a linguagem existente em `CONTEXT.md`, chame atenção imediatamente. "Seu glossário define 'cancellation' como X, mas você parece estar querendo dizer Y — qual é?"

### Afie linguagem vaga

Quando o usuário usar termos vagos ou sobrecarregados, proponha um termo canônico preciso. "Você está dizendo 'account' — quer dizer o Customer ou o User? São coisas diferentes."

### Discuta cenários concretos

Quando relacionamentos de domínio estiverem sendo discutidos, stress-teste com cenários específicos. Invente cenários que sondem edge cases e forcem o usuário a ser preciso sobre os limites entre conceitos.

### Cruze com o código

Quando o usuário afirmar como algo funciona, verifique se o código concorda. Se encontrar contradição, exponha: "Seu código cancela Orders inteiras, mas você acabou de dizer que cancelamento parcial é possível — qual está certo?"

### Atualize CONTEXT.md inline

Quando um termo for resolvido, atualize `CONTEXT.md` ali mesmo. Não acumule — capture no momento. Use o formato em [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

`CONTEXT.md` deve ser totalmente desprovido de detalhes de implementação. Não trate `CONTEXT.md` como uma spec, um rascunho ou repositório de decisões de implementação. É um glossário e nada mais.

### Ofereça ADRs com parcimônia

Só ofereça criar um ADR quando todas as três condições forem verdadeiras:

1. **Difícil de reverter** — o custo de mudar de ideia depois é significativo
2. **Surpreendente sem contexto** — um leitor futuro vai se perguntar "por que eles fizeram assim?"
3. **Resultado de um trade-off real** — havia alternativas genuínas e você escolheu uma por razões específicas

Se qualquer uma das três faltar, pule o ADR. Use o formato em [ADR-FORMAT.md](./ADR-FORMAT.md).
