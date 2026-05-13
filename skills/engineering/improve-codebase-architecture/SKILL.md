---
name: improve-codebase-architecture
description: "Encontra oportunidades de aprofundamento (deepening) numa codebase, informado pela linguagem de domínio em CONTEXT.md e pelas decisões em docs/adr/. Use quando o usuário quiser melhorar a arquitetura, achar oportunidades de refactoring, consolidar módulos fortemente acoplados, ou tornar a codebase mais testável e navegável por AI. Use when user wants to improve architecture, find refactoring opportunities, consolidate tightly-coupled modules, or make a codebase more testable and AI-navigable."
---

# Improve Codebase Architecture

Traga à tona fricção arquitetural e proponha **deepening opportunities** — refactors que transformam shallow modules em deep modules. O alvo é testability e AI-navigability.

## Glossário

Use estes termos exatamente em cada sugestão. Linguagem consistente é o ponto — não derive para "component", "service", "API" ou "boundary". Definições completas em [LANGUAGE.md](LANGUAGE.md).

- **Module** — qualquer coisa com interface e implementação (função, classe, pacote, slice).
- **Interface** — tudo que um caller precisa saber para usar o module: tipos, invariantes, error modes, ordering, config. Não só a type signature.
- **Implementation** — o código por dentro.
- **Depth** — leverage na interface: muito comportamento atrás de uma interface pequena. **Deep** = high leverage. **Shallow** = interface quase tão complexa quanto a implementação.
- **Seam** — onde uma interface vive; um lugar onde comportamento pode ser alterado sem editar inline. (Use isto, não "boundary".)
- **Adapter** — coisa concreta que satisfaz uma interface num seam.
- **Leverage** — o que callers ganham de depth.
- **Locality** — o que mantenedores ganham de depth: change, bugs, knowledge concentrados num lugar só.

Princípios-chave (veja [LANGUAGE.md](LANGUAGE.md) para a lista completa):

- **Deletion test**: imagine deletar o módulo. Se complexidade some, era pass-through. Se complexidade reaparece em N callers, estava ganhando o pão.
- **A interface é a test surface.**
- **One adapter = seam hipotético. Two adapters = seam real.**

Esta skill é _informada_ pelo domain model do projeto. A linguagem de domínio dá nomes a bons seams; ADRs registram decisões que a skill não deve re-litigar.

## Processo

### 1. Explorar

Leia o glossário de domínio do projeto e quaisquer ADRs na área que está tocando primeiro.

Depois use a ferramenta Agent com `subagent_type=Explore` para caminhar pela codebase. Não siga heurísticas rígidas — explore organicamente e anote onde você experimenta fricção:

- Onde entender um conceito exige saltar entre muitos módulos pequenos?
- Onde módulos estão **shallow** — interface quase tão complexa quanto a implementação?
- Onde funções puras foram extraídas só para testability, mas os bugs reais se escondem em como são chamadas (sem **locality**)?
- Onde módulos fortemente acoplados vazam por seus seams?
- Que partes da codebase estão sem testes, ou difíceis de testar pela interface atual?

Aplique o **deletion test** a qualquer coisa que você suspeita ser shallow: deletar concentraria complexidade ou só moveria? Um "sim, concentra" é o sinal que você quer.

### 2. Apresentar candidatos

Apresente uma lista numerada de deepening opportunities. Para cada candidato:

- **Files** — quais arquivos/módulos estão envolvidos
- **Problem** — por que a arquitetura atual está causando fricção
- **Solution** — descrição em português simples do que mudaria
- **Benefits** — explicado em termos de locality e leverage, e também em como os testes melhorariam

**Use vocabulário do CONTEXT.md para o domínio, e vocabulário do [LANGUAGE.md](LANGUAGE.md) para arquitetura.** Se `CONTEXT.md` define "Order", fale sobre "o módulo de Order intake" — não sobre "o FooBarHandler", e não "o Order service".

**Conflitos com ADR**: se um candidato contradiz um ADR existente, só traga à tona quando a fricção for real o suficiente para justificar revisitar o ADR. Marque claramente (ex.: _"contradiz ADR-0007 — mas vale reabrir porque…"_). Não liste todo refactor teórico que um ADR proíbe.

NÃO proponha interfaces ainda. Pergunte ao usuário: "Qual destes você quer explorar?"

### 3. Loop de sabatina

Quando o usuário escolher um candidato, entre numa conversa de sabatina. Caminhe pela design tree com ele — constraints, dependências, o shape do módulo aprofundado, o que fica atrás do seam, que testes sobrevivem.

Efeitos colaterais acontecem inline conforme as decisões cristalizam:

- **Nomeando um módulo aprofundado com um conceito que não está em `CONTEXT.md`?** Adicione o termo ao `CONTEXT.md` — mesma disciplina do `/grill-with-docs` (veja [CONTEXT-FORMAT.md](../grill-with-docs/CONTEXT-FORMAT.md)). Crie o arquivo com preguiça se não existir.
- **Refinando um termo fuzzy durante a conversa?** Atualize `CONTEXT.md` ali mesmo.
- **Usuário rejeita o candidato com uma razão load-bearing?** Ofereça um ADR, enquadrado como: _"Quer que eu registre isso como ADR para futuras revisões de arquitetura não re-sugerirem?"_ Só ofereça quando a razão de fato seria necessária a um futuro explorador para evitar re-sugerir a mesma coisa — pule razões efêmeras ("não vale a pena agora") e auto-evidentes. Veja [ADR-FORMAT.md](../grill-with-docs/ADR-FORMAT.md).
- **Quer explorar interfaces alternativas para o módulo aprofundado?** Veja [INTERFACE-DESIGN.md](INTERFACE-DESIGN.md).
