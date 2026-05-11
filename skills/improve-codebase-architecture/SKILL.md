---
name: improve-codebase-architecture
description: "Encontra oportunidades de aprofundamento de módulos no codebase informadas pelo `CONTEXT.md` e ADRs — expõe atrito arquitetural (módulos rasos, acoplamento que vaza, código difícil de testar) e propõe refators que aumentam alavancagem e localidade. Use quando usuário disser \"melhorar arquitetura\", \"refatorar\", \"aprofundar módulos\", ou invocar /improve-codebase-architecture. Triggers: \"improve architecture\", \"refactor candidates\", \"ball of mud\", \"deep modules\", \"deepen\"."
---

# improve-codebase-architecture

Expõe atrito arquitetural e propõe **oportunidades de aprofundamento** — refators que transformam módulos rasos em profundos. Alvo: testabilidade e navegabilidade por agente AI.

Combate o anti-padrão central de "agente AI acelerou desenvolvimento, mas codebase virou bola de lama em 3 meses". Skills aceleram entropia se não houver disciplina arquitetural. Esta skill é a contramedida.

## Glossário

Use estes termos **exatamente** em toda sugestão. Linguagem consistente é o ponto — não escorregue pra "componente", "serviço", "API", "fronteira". Definições completas em [LANGUAGE.md](LANGUAGE.md).

- **Módulo** — qualquer coisa com interface e implementação (função, classe, pacote, fatia)
- **Interface** — tudo que um caller precisa saber para usar o módulo: tipos, invariantes, modos de erro, ordem, config. **Não só** assinatura.
- **Implementação** — o código por dentro
- **Profundidade** — alavancagem na interface: muito comportamento atrás de interface pequena. **Profundo** = alta alavancagem. **Raso** = interface quase tão complexa quanto a implementação.
- **Seam** _(de Michael Feathers)_ — lugar onde a interface vive; ponto onde comportamento pode ser alterado sem editar in-place. (Use "seam", **não** "fronteira" — está sobrecarregado com bounded context de DDD.)
- **Adapter** — coisa concreta que satisfaz uma interface em um seam
- **Alavancagem** — o que callers ganham com profundidade
- **Localidade** — o que mantenedores ganham com profundidade: mudança, bugs, conhecimento concentrados em **um lugar**

Princípios-chave (ver [LANGUAGE.md](LANGUAGE.md) pra lista completa):

- **Teste da deleção:** imagine deletar o módulo. Se a complexidade some, era pass-through. Se reaparece em N callers, era ganhando seu lugar.
- **Interface é a superfície de teste.**
- **Um adapter = seam hipotético. Dois adapters = seam real.**

Esta skill é **informada** pelo modelo de domínio do projeto. A linguagem do domínio dá nomes aos seams bons; ADRs registram decisões que a skill **não deve re-litigar**.

## <o-que-fazer>

### Passo 1 — Explorar

Leia o glossário de domínio (`CONTEXT.md`) e ADRs na área que vai tocar **antes** de qualquer coisa.

Depois explore o codebase organicamente — não siga heurísticas rígidas. Anote onde você sente **atrito**:

- Onde entender um conceito exige saltar entre muitos módulos pequenos?
- Onde módulos são **rasos** — interface quase tão complexa quanto implementação?
- Onde funções puras foram extraídas só pra testabilidade, mas os bugs reais escondem em **como** são chamadas (sem **localidade**)?
- Onde módulos fortemente acoplados vazam pelos seams?
- Que partes são não-testadas, ou difíceis de testar através da interface atual?

Aplique o **teste da deleção** em tudo que suspeitar ser raso: deletar concentraria a complexidade, ou só moveria? "Sim, concentra" é o sinal que você quer.

### Passo 2 — Apresentar candidatos

Apresente lista numerada de oportunidades de aprofundamento. Para cada candidato:

- **Arquivos** — quais arquivos/módulos envolvidos
- **Problema** — por que a arquitetura atual está causando atrito
- **Solução** — descrição em português direto do que mudaria
- **Benefícios** — explicado em termos de **localidade** e **alavancagem**, e como os testes melhorariam

**Use vocabulário do `CONTEXT.md` para o domínio, e vocabulário de [LANGUAGE.md](LANGUAGE.md) para a arquitetura.** Se `CONTEXT.md` define "Pedido", fale sobre "o módulo de entrada de Pedido" — não "o FooBarHandler", e não "o serviço de Pedido".

**Conflitos com ADR:** se um candidato contradiz um ADR existente, só sinalize quando o atrito for real o suficiente pra justificar reabrir o ADR. Marque claramente (ex: _"contradiz ADR-0007 — mas vale reabrir porque..."_). Não liste todo refator teórico que algum ADR proibiria.

**NÃO** proponha interfaces ainda. Pergunte: "Qual destes você quer explorar?"

### Passo 3 — Loop de grill

Quando o usuário escolhe um candidato, entre em conversa de grill. Caminhe a árvore de design com ele — restrições, dependências, formato do módulo aprofundado, o que fica atrás do seam, quais testes sobrevivem.

Efeitos colaterais acontecem inline conforme decisões cristalizam:

- **Nomeando módulo aprofundado por conceito não-presente em `CONTEXT.md`?** Adicione o termo ao `CONTEXT.md` — mesma disciplina de [grill-with-docs](../grill-with-docs/SKILL.md). Crie o arquivo preguiçosamente se não existir.
- **Afiando termo vago durante a conversa?** Atualize `CONTEXT.md` ali.
- **Usuário rejeita candidato com razão load-bearing?** Ofereça ADR, enquadrando como: _"Quer que eu registre como ADR pra revisões arquiteturais futuras não re-sugerirem?"_ Só ofereça quando a razão **realmente** seria útil pra um futuro explorador. Pule razões efêmeras ("não vale a pena agora") e auto-evidentes.
- **Quer explorar interfaces alternativas para o módulo aprofundado?** Ver [INTERFACE-DESIGN.md](INTERFACE-DESIGN.md).
- **Como aprofundar dado o tipo de dependência?** Ver [DEEPENING.md](DEEPENING.md).

## <info-de-apoio>

### Anti-padrões

- **NÃO** proponha aprofundamento sem teste da deleção. Você pode estar movendo complexidade, não escondendo.
- **NÃO** misture refator com mudança de comportamento. Aprofundar é **conservativo** — testes existentes devem continuar passando.
- **NÃO** invente seam onde só existe um adapter. "Um adapter = seam hipotético."
- **NÃO** re-litigue ADR existente sem motivo forte. ADR é decisão arquitetural — respeite até prova de erro.
- **NÃO** force vocabulário de "boundary" / "service" / "API". Use **módulo**, **interface**, **seam**, **adapter**.
- **NÃO** rode esta skill em codebase que **acabou de nascer**. Aprofundamento prematuro = abstração prematura.

### Quando rodar

- Codebase tem 6+ meses e velocidade caiu
- Bugs frequentemente "se mudou em A, quebra em B" (acoplamento escondido)
- Testes existem mas pegam pouco bug (testes acoplados à implementação)
- Onboarding novo é doloroso — devs perdem dia inteiro só entendendo o que onde fica
- Você sente "isso aqui é bola de lama" mas não consegue articular onde

### Recomendação de cadência

Original do Matt Pocock sugere: **rodar a cada poucos dias**. Não esperar codebase apodrecer.

Esta skill é **investimento em design diário**. Cada sessão paga em velocidade futura.

### Diferença vs `zoom-out` e `grill-with-docs`

| | improve-codebase-architecture | zoom-out | grill-with-docs |
|---|---|---|---|
| Direção | Propõe mudanças arquiteturais | Descreve mapa | Refina plano |
| Saída | Lista de candidatos de aprofundamento | Mapa de módulos/callers | Plano + docs atualizadas |
| Quando | Manutenção saudável periódica | Pré-mudança em área desconhecida | Antes de codar feature nova |

### Exemplo de output de candidato

```markdown
## Candidato 3 — Aprofundar módulo de validação de Pedido

**Arquivos envolvidos:**
- `src/orders/validators/items.ts`
- `src/orders/validators/customer.ts`
- `src/orders/validators/payment.ts`
- `src/orders/api/create.ts` (orquestra os 3)

**Problema:**
Três validadores rasos. Cada um exporta `validate*(input): ValidationResult`. 
Cada caller (API + worker + import CSV) chama os três em sequência. Mudança 
recente na validação de pagamento exigiu atualizar 3 callers — sintoma 
clássico de baixa localidade.

**Solução:**
Aprofundar em módulo `OrderValidator` com interface única:
`validate(order: Order): ValidatedOrder | ValidationError`. Internamente, 
mantém os 3 validadores como helpers privados (com seams internos pra 
seus próprios testes). Externamente: 1 método.

**Benefícios:**
- **Alavancagem:** 3 callers viram 1 chamada cada
- **Localidade:** mudança em regra de validação fica em 1 módulo
- **Testes:** novos testes na interface (`validate`) sobrevivem a refators 
  internos. Testes antigos (em cada validador raso) viram tech debt — 
  deletar quando interface estiver coberta.

**Dependências:**
Categoria 1 (in-process) — todos os validadores são pura computação. 
Aprofundamento sem adapter. Ver [DEEPENING.md](DEEPENING.md).
```

## Cross-references

- [LANGUAGE.md](LANGUAGE.md) — vocabulário arquitetural canônico
- [DEEPENING.md](DEEPENING.md) — como aprofundar dado tipo de dependência
- [INTERFACE-DESIGN.md](INTERFACE-DESIGN.md) — design paralelo de interfaces alternativas (sub-agentes)
- [grill-with-docs](../grill-with-docs/SKILL.md) — usado no passo 3 quando termo novo entra em CONTEXT.md
- [zoom-out](../zoom-out/SKILL.md) — entender área antes de propor melhoria
- [tdd](../tdd/SKILL.md) — testes do módulo aprofundado seguem disciplina TDD
- [`CONTEXT.md`](../../CONTEXT.md) — vocabulário canônico de domínio
