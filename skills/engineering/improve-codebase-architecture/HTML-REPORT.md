# HTML Report Format

A revisão arquitetural é renderizada como um único arquivo HTML self-contained no diretório temp do OS. Tailwind e Mermaid vêm de CDNs. Mermaid lida bem com diagramas em forma de grafo; divs manuais e SVG inline lidam com os visuais mais editoriais (mass diagrams, cross-sections). Misture os dois — não apoie tudo no Mermaid, vai começar a parecer genérico.

## Scaffold

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Architecture review — {{repo name}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      /* small custom layer for things Tailwind doesn't cover cleanly:
         dashed seam lines, hand-drawn-feeling arrow heads, etc. */
      .seam { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

## Header

Nome do repo, data e uma legenda compacta: caixa sólida = module, linha tracejada = seam, seta vermelha = leakage, caixa escura espessa = deep module. Sem parágrafo de introdução — direto para os candidatos.

## Card de candidato

Os diagramas carregam o peso. A prosa é esparsa, direta e usa os termos do glossário ([LANGUAGE.md](LANGUAGE.md)) sem cerimônia.

Cada candidato é um `<article>`:

- **Title** — curto, nomeia o deepening (ex.: "Collapse the Order intake pipeline").
- **Badge row** — recommendation strength (`Strong` = emerald, `Worth exploring` = amber, `Speculative` = slate), mais uma tag para a categoria de dependência (`in-process`, `local-substitutable`, `ports & adapters`, `mock`).
- **Files** — lista em monospace, `font-mono text-sm`.
- **Before / After diagram** — o centrepiece. Duas colunas, lado a lado. Veja padrões abaixo.
- **Problem** — uma frase. O que dói.
- **Solution** — uma frase. O que muda.
- **Wins** — bullets, ≤6 palavras cada. Ex.: "Tests hit one interface", "Pricing logic stops leaking", "Delete 4 shallow wrappers".
- **ADR callout** (se aplicável) — uma linha em caixa com tinte amber.

Sem parágrafos de explicação. Se o diagrama precisa de um parágrafo para ser entendido, redesenhe o diagrama.

## Padrões de diagrama

Escolha o padrão que se encaixa no candidato. Misture-os. Não faça todo diagrama igual — variedade é parte do ponto.

### Mermaid graph (o cavalo de batalha para dependências / call flow)

Use um `flowchart` ou `graph` Mermaid quando o ponto é "X chama Y chama Z, e olha a bagunça." Envolva num card com estilo Tailwind para não parecer parachuted in. Use classDef para colorir edges de leakage em vermelho e o deep module em escuro. Sequence diagrams funcionam bem para "antes: 6 round-trips; depois: 1."

```html
<div class="rounded-lg border border-slate-200 bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      A[OrderHandler] --> B[OrderValidator]
      B --> C[OrderRepo]
      C -.leak.-> D[PricingClient]
      classDef leak stroke:#dc2626,stroke-width:2px;
      class C,D leak
  </pre>
</div>
```

### Hand-built boxes-and-arrows (quando o layout do Mermaid luta contra você)

Modules como `<div>`s com bordas e labels. Setas como elementos SVG inline `<line>` ou `<path>` posicionados absolutamente sobre um container relativo. Use quando quiser que o diagrama "depois" pareça um único module de borda espessa e escura com internos acinzentados — o Mermaid não renderiza isso com o peso certo.

### Cross-section (bom para shallowness em camadas)

Empilhe bandas horizontais (`h-12 border-l-4`) para mostrar as camadas que uma chamada atravessa. Antes: 6 camadas finas, cada uma sem fazer nada. Depois: 1 banda espessa com a responsabilidade consolidada.

### Mass diagram (bom para "interface tão larga quanto implementação")

Dois retângulos por module — um para a área de superfície da interface, outro para a implementação. Antes: retângulo da interface quase tão alto quanto o da implementação (shallow). Depois: retângulo da interface curto, retângulo da implementação alto (deep).

### Call-graph collapse

Antes: uma árvore de chamadas de função renderizada como caixas aninhadas. Depois: a mesma árvore colapsada em uma caixa, com as chamadas agora internas mostradas esmaecidas dentro dela.

## Guia de estilo

- Editorial, não corporate-dashboard. Espaço em branco generoso. Serif opcional para headings (`font-serif` funciona bem com stone/slate).
- Use cor com parcimônia: um accent (emerald ou indigo) mais vermelho para leakage e amber para avisos.
- Mantenha diagramas ~320px de altura para que before/after fique confortavelmente lado a lado sem scroll.
- Use `text-xs uppercase tracking-wider` para labels de module dentro dos diagramas — devem parecer esquemáticos, não UI.
- Os únicos scripts são o CDN do Tailwind e o import ESM do Mermaid. O relatório é estático fora isso — sem app code, sem interatividade além do próprio rendering do Mermaid.

## Seção Top recommendation

Um card maior. Nome do candidato, uma frase sobre o porquê, anchor link para o card dele. Só isso.

## Tom

Português direto e conciso — mas os substantivos e verbos arquiteturais vêm direto do [LANGUAGE.md](LANGUAGE.md). Concisão não é desculpa para derivar.

**Use exatamente:** module, interface, implementation, depth, deep, shallow, seam, adapter, leverage, locality.

**Nunca substitua:** component, service, unit (por module) · API, signature (por interface) · boundary (por seam) · layer, wrapper (por module, quando você quer dizer module).

**Frases que encaixam no estilo:**

- "Order intake module é shallow — interface quase bate com a implementação."
- "Pricing vaza pelo seam."
- "Deepen: uma interface, um lugar para testar."
- "Dois adapters justificam o seam: HTTP em prod, in-memory em testes."

**Bullets de Wins** nomeiam o ganho em termos do glossário: *"locality: bugs se concentram em um module"*, *"leverage: uma interface, N call sites"*, *"interface encolhe; implementação absorve os wrappers"*. Não escreva *"mais fácil de manter"* ou *"código mais limpo"* — esses termos não estão no glossário e não ganham seu lugar.

Sem hedging, sem throat-clearing, sem "é válido notar que…". Se uma frase poderia ser um bullet, faça-a bullet. Se um bullet poderia ser cortado, corte. Se um termo não está em [LANGUAGE.md](LANGUAGE.md), busque um que esteja antes de inventar um novo.
