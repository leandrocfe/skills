# Interface Design

Quando o usuário quiser explorar interfaces alternativas para um candidato de deepening escolhido, use este padrão de sub-agentes paralelos. Baseado em "Design It Twice" (Ousterhout) — sua primeira ideia provavelmente não é a melhor.

Usa o vocabulário em [LANGUAGE.md](LANGUAGE.md) — **module**, **interface**, **seam**, **adapter**, **leverage**.

## Processo

### 1. Enquadrar o problem space

Antes de spawnar sub-agentes, escreva uma explicação user-facing do problem space para o candidato escolhido:

- As constraints que qualquer nova interface precisaria satisfazer
- As dependências em que ela se apoiaria, e em qual categoria caem (veja [DEEPENING.md](DEEPENING.md))
- Um rough sketch de código ilustrativo para aterrar as constraints — não uma proposta, só um jeito de tornar as constraints concretas

Mostre ao usuário, depois prossiga imediatamente para o Step 2. O usuário lê e pensa enquanto os sub-agentes trabalham em paralelo.

### 2. Spawnar sub-agentes

Spawne 3+ sub-agentes em paralelo usando a ferramenta Agent. Cada um precisa produzir uma interface **radicalmente diferente** para o módulo aprofundado.

Prompte cada sub-agente com um brief técnico separado (paths de arquivo, detalhes de coupling, categoria de dependência de [DEEPENING.md](DEEPENING.md), o que fica atrás do seam). O brief é independente da explicação user-facing do problem space do Step 1. Dê a cada agente uma constraint de design diferente:

- Agent 1: "Minimize a interface — mire em 1-3 entry points máximo. Maximize leverage por entry point."
- Agent 2: "Maximize flexibilidade — suporte muitos casos de uso e extensão."
- Agent 3: "Otimize para o caller mais comum — torne o caso default trivial."
- Agent 4 (se aplicável): "Desenhe ao redor de ports & adapters para dependências cross-seam."

Inclua tanto vocabulário de [LANGUAGE.md](LANGUAGE.md) quanto vocabulário de CONTEXT.md no brief para cada sub-agente nomear coisas consistentemente com a linguagem arquitetural e a linguagem de domínio do projeto.

Cada sub-agente entrega:

1. Interface (tipos, métodos, params — mais invariantes, ordering, error modes)
2. Exemplo de uso mostrando como callers usam
3. O que a implementação esconde atrás do seam
4. Estratégia de dependência e adapters (veja [DEEPENING.md](DEEPENING.md))
5. Trade-offs — onde leverage é alto, onde é magro

### 3. Apresentar e comparar

Apresente os designs sequencialmente para o usuário absorver cada um, depois compare em prosa. Contraste por **depth** (leverage na interface), **locality** (onde mudança se concentra) e **posicionamento de seam**.

Depois de comparar, dê sua própria recomendação: qual design você acha mais forte e por quê. Se elementos de designs diferentes combinariam bem, proponha um híbrido. Seja opinativo — o usuário quer uma leitura forte, não um menu.
