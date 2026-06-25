# Design It Twice

Quando o usuário quiser explorar interfaces alternativas para um candidato de deepening escolhido, use este padrão de sub-agents em paralelo. Baseado em "Design It Twice" (Ousterhout) — sua primeira ideia raramente é a melhor.

Usa o vocabulário de [SKILL.md](SKILL.md) — **module**, **interface**, **seam**, **adapter**, **leverage**.

## Processo

### 1. Enquadre o espaço do problema

Antes de disparar os sub-agents, escreva uma explicação voltada para o usuário do espaço de problema para o candidato escolhido:

- As constraints que qualquer nova interface precisaria satisfazer
- As dependências das quais ela dependeria, e em qual categoria elas se encaixam (veja [DEEPENING.md](DEEPENING.md))
- Um sketch grosseiro de código ilustrativo para fundamentar as constraints — não uma proposta, apenas uma forma de tornar as constraints concretas

Mostre isso ao usuário, depois prossiga imediatamente para o passo 2. O usuário lê e pensa enquanto os sub-agents trabalham em paralelo.

### 2. Dispare sub-agents

Dispare 3+ sub-agents em paralelo usando a ferramenta Agent. Cada um deve produzir uma **interface radicalmente diferente** para o módulo aprofundado.

Forneça a cada sub-agent um brief técnico separado (caminhos de arquivos, detalhes de acoplamento, categoria de dependência de [DEEPENING.md](DEEPENING.md), o que fica atrás do seam). O brief é independente da explicação do espaço do problema voltada para o usuário no passo 1. Dê a cada agente uma constraint de design diferente:

- Agente 1: "Minimize a interface — mire em no máximo 1–3 pontos de entrada. Maximize leverage por ponto de entrada."
- Agente 2: "Maximize flexibilidade — suporte muitos casos de uso e extensão."
- Agente 3: "Otimize para o caller mais comum — torne o caso default trivial."
- Agente 4 (se aplicável): "Projete em torno de ports & adapters para dependências cross-seam."

Inclua tanto o vocabulário de [SKILL.md](SKILL.md) quanto o de CONTEXT.md no brief para que cada sub-agent nomeie as coisas consistentemente com a linguagem de arquitetura e a linguagem de domínio do projeto.

Cada sub-agent produz:

1. Interface (tipos, métodos, parâmetros — mais invariantes, ordenação, modos de erro)
2. Exemplo de uso mostrando como callers a usam
3. O que a implementação esconde atrás do seam
4. Estratégia de dependência e adapters (veja [DEEPENING.md](DEEPENING.md))
5. Trade-offs — onde o leverage é alto, onde é baixo

### 3. Apresente e compare

Apresente os designs sequencialmente para que o usuário possa absorver cada um, depois compare-os em prosa. Contraste por **depth** (leverage na interface), **locality** (onde a mudança se concentra) e **seam placement**.

Depois de comparar, dê sua própria recomendação: qual design você acha mais forte e por quê. Se elementos de designs diferentes combinassem bem, proponha um híbrido. Seja opinativo — o usuário quer uma leitura forte, não um cardápio.
