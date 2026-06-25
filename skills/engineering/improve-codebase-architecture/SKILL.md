---
name: improve-codebase-architecture
description: Escaneia uma codebase em busca de oportunidades de deepening, apresenta como relatório HTML visual e depois sabatina a escolhida.
disable-model-invocation: true
---

# Improve Codebase Architecture

Traz à tona fricção arquitetural e propõe **oportunidades de deepening** — refactors que transformam módulos rasos (shallow) em profundos (deep). O objetivo é testabilidade e AI-navigability.

Esta skill é _informada_ pelo domain model do projeto e construída sobre um vocabulário de design compartilhado:

- Rode a skill `/codebase-design` para o vocabulário de arquitetura (**module**, **interface**, **depth**, **seam**, **adapter**, **leverage**, **locality**) e seus princípios (o deletion test, "a interface é a test surface", "um adapter = seam hipotético, dois = real"). Use estes termos exatamente em toda sugestão — não desvie para "component", "service", "API" ou "boundary".
- A linguagem de domínio em `CONTEXT.md` dá nomes a bons seams; ADRs em `docs/adr/` registram decisões que esta skill não deve re-litigar.

## Processo

### 1. Explore

Leia primeiro o glossário de domínio do projeto (`CONTEXT.md`) e quaisquer ADRs na área que você está tocando.

Depois use a ferramenta Agent com `subagent_type=Explore` para caminhar pela codebase. Não siga heurísticas rígidas — explore de forma orgânica e note onde você sente fricção:

- Onde entender um conceito exige pular entre muitos módulos pequenos?
- Onde módulos estão **shallow** — interface quase tão complexa quanto a implementação?
- Onde funções puras foram extraídas só para testabilidade, mas os bugs reais se escondem em como são chamadas (sem **locality**)?
- Onde módulos fortemente acoplados vazam através de seus seams?
- Quais partes da codebase estão sem testes, ou difíceis de testar pela interface atual?

Aplique o **deletion test** em qualquer coisa que você suspeita ser shallow: deletar concentraria complexidade, ou só moveria? Um "sim, concentra" é o sinal que você quer.

### 2. Apresente candidatos como relatório HTML

Escreva um arquivo HTML self-contained no diretório temp do sistema operacional para que nada caia no repo. Resolva o temp dir a partir de `$TMPDIR`, com fallback para `/tmp` (ou `%TEMP%` no Windows), e escreva em `<tmpdir>/architecture-review-<timestamp>.html` para que cada execução tenha um arquivo novo. Abra para o usuário — `xdg-open <path>` no Linux, `open <path>` no macOS, `start <path>` no Windows — e informe o caminho absoluto.

O relatório usa **Tailwind via CDN** para layout e estilização, e **Mermaid via CDN** para diagramas onde um grafo/flow/sequência comunica a estrutura de forma confiável. Misture Mermaid com visuais CSS/SVG feitos à mão — use Mermaid quando relacionamentos têm forma de grafo (call graphs, dependências, sequências), e divs/SVG construídos à mão quando quiser algo mais editorial (mass diagrams, cross-sections, animações de collapse). Cada candidato recebe uma **visualização before/after**. Seja visual.

Para cada candidato, renderize um card com:

- **Files** — quais arquivos/módulos estão envolvidos
- **Problem** — por que a arquitetura atual está causando fricção
- **Solution** — descrição em linguagem simples do que mudaria
- **Benefits** — explicados em termos de locality e leverage, e como os testes melhorariam
- **Before / After diagram** — lado a lado, desenhado customizado, ilustrando a shallow e o deepening
- **Recommendation strength** — um de `Strong`, `Worth exploring`, `Speculative`, renderizado como badge

Encerre o relatório com uma seção **Top recommendation**: qual candidato você atacaria primeiro e por quê.

**Use vocabulário de CONTEXT.md para o domínio, e o vocabulário de `/codebase-design` para a arquitetura.** Se `CONTEXT.md` define "Order", fale sobre "o módulo de intake de Order" — não "o FooBarHandler", e não "o Order service".

**Conflitos de ADR**: se um candidato contradiz um ADR existente, só exponha quando a fricção for real o suficiente para justificar reabrir o ADR. Marque claramente no card (ex.: um callout de aviso: _"contradiz ADR-0007 — mas vale reabrir porque..."_). Não liste todo refactor teórico que um ADR proíbe.

Veja [HTML-REPORT.md](HTML-REPORT.md) para o scaffold completo de HTML, padrões de diagrama e guia de estilo.

NÃO proponha interfaces ainda. Depois que o arquivo for escrito, pergunte ao usuário: "Qual destes você gostaria de explorar?"

### 3. Loop de sabatina

Uma vez que o usuário escolher um candidato, rode a skill `/grilling` para caminhar a design tree com ele — constraints, dependências, o shape do módulo aprofundado, o que fica atrás do seam, quais testes sobrevivem.

Efeitos colaterais acontecem inline conforme decisões cristalizam — rode a skill `/domain-modeling` para manter o domain model atualizado conforme avança:

- **Nomeando um módulo aprofundado com um conceito que não está em `CONTEXT.md`?** Adicione o termo ao `CONTEXT.md`. Crie o arquivo de forma lazy se não existir.
- **Afinando um termo vago durante a conversa?** Atualize `CONTEXT.md` ali mesmo.
- **Usuário rejeita o candidato com uma razão importante?** Ofereça um ADR, enquadrado como: _"Quer que eu registre isso como ADR para que futuras revisões de arquitetura não o re-sugiram?"_ Só ofereça quando a razão realmente seria necessária para um explorador futuro evitar re-sugerir a mesma coisa — pule razões efêmeras ("não vale a pena agora") e óbvias.
- **Quer explorar interfaces alternativas para o módulo aprofundado?** Rode a skill `/codebase-design` e use o padrão de sub-agents paralelos design-it-twice dela.
