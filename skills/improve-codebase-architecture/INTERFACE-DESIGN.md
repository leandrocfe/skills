# Design de Interface

Quando o usuário quer explorar interfaces alternativas pra um candidato escolhido de aprofundamento, use este padrão de sub-agentes paralelos. Baseado em "Design It Twice" (Ousterhout) — sua primeira ideia provavelmente não é a melhor.

Usa o vocabulário em [LANGUAGE.md](LANGUAGE.md) — **módulo**, **interface**, **seam**, **adapter**, **alavancagem**.

## Processo

### 1. Enquadrar o espaço do problema

Antes de spawnar sub-agentes, escreva uma explicação user-facing do espaço do problema para o candidato escolhido:

- As restrições que qualquer interface nova precisaria satisfazer
- As dependências em que confiaria, e em qual categoria caem (ver [DEEPENING.md](DEEPENING.md))
- Um sketch ilustrativo de código pra ancorar as restrições — **não** uma proposta, só um jeito de tornar as restrições concretas

Mostre ao usuário, depois prossiga imediatamente pro Passo 2. Usuário lê e pensa enquanto sub-agentes trabalham em paralelo.

### 2. Spawnar sub-agentes

Spawne 3+ sub-agentes em paralelo usando a Agent tool. Cada um deve produzir interface **radicalmente diferente** para o módulo aprofundado.

Dê a cada sub-agente um brief técnico separado (paths de arquivos, detalhes de acoplamento, categoria de dependência de [DEEPENING.md](DEEPENING.md), o que fica atrás do seam). O brief é independente da explicação do espaço do problema do Passo 1. Dê a cada agente uma restrição de design diferente:

- **Agente 1:** "Minimize a interface — alvo de 1–3 entry points no máximo. Maximize alavancagem por entry point."
- **Agente 2:** "Maximize flexibilidade — suporte muitos casos de uso e extensão."
- **Agente 3:** "Otimize pro caller mais comum — torne o caso default trivial."
- **Agente 4 (se aplicável):** "Desenhe ao redor de ports & adapters pra dependências cross-seam."

Inclua tanto vocabulário de [LANGUAGE.md](LANGUAGE.md) quanto de `CONTEXT.md` no brief, pra cada sub-agente nomear consistentemente com a linguagem arquitetural e a linguagem de domínio do projeto.

Cada sub-agente entrega:

1. **Interface** (tipos, métodos, params — mais invariantes, ordem, modos de erro)
2. **Exemplo de uso** mostrando como callers usam
3. **O que a implementação esconde** atrás do seam
4. **Estratégia de dependência** e adapters (ver [DEEPENING.md](DEEPENING.md))
5. **Trade-offs** — onde alavancagem é alta, onde é fina

### 3. Apresentar e comparar

Apresente designs sequencialmente pra usuário absorver um por vez, depois compare em prosa. Contraste por **profundidade** (alavancagem na interface), **localidade** (onde mudança concentra) e **escolha de seam**.

Depois de comparar, **dê sua recomendação**: qual design você acha mais forte e por quê. Se elementos de designs diferentes combinariam bem, proponha híbrido. **Seja opinionado** — usuário quer uma leitura forte, não um menu.

## Anti-padrões

- **NÃO** spawne só 1 sub-agente. Ponto de "design it twice" é comparar múltiplas alternativas. Mínimo: 3.
- **NÃO** dê o mesmo brief a todos os sub-agentes. Eles vão convergir.
- **NÃO** apresente o "design vencedor" sem mostrar os outros. Usuário tem que ver o espaço de soluções.
- **NÃO** fique neutro. Recomendação forte ou nada.
- **NÃO** copie a interface existente. Sub-agentes desenham do zero, não refinam o que está.
