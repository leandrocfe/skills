# HTML Report Format

A revisão arquitetural é renderizada como um único arquivo HTML self-contained no diretório temp do SO. Tailwind e Mermaid vêm de CDNs. Mermaid lida bem com diagramas em forma de grafo; divs e SVG inline construídos à mão lidam com visuais mais editoriais (mass diagrams, cross-sections). Misture os dois — não dependa só de Mermaid para tudo, senão começa a parecer genérico.

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
      /* pequena camada custom para coisas que Tailwind não cobre limpo:
         linhas de seam tracejadas, setas com feeling hand-drawn, etc. */
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

Nome do repo, data e uma legenda compacta: caixa sólida = module, linha tracejada = seam, seta vermelha = leakage, caixa escura grossa = deep module. Sem parágrafo de introdução — direto para os candidatos.

## Candidate card

Os diagramas carregam o peso. A prosa é esparsa, simples e usa os termos do glossário (da skill `/codebase-design`) sem cerimônia.

Cada candidato é um `<article>`:

- **Title** — curto, nomeia o deepening (ex: "Collapse the Order intake pipeline").
- **Badge row** — recommendation strength (`Strong` = emerald, `Worth exploring` = amber, `Speculative` = slate), mais uma tag para a categoria de dependência (`in-process`, `local-substitutable`, `ports & adapters`, `mock`).
- **Files** — lista em monoespaçado, `font-mono text-sm`.
- **Before / After diagram** — a peça central. Duas colunas, lado a lado. Veja padrões abaixo.
- **Problem** — uma frase. O que dói.
- **Solution** — uma frase. O que muda.
- **Wins** — bullets, ≤6 palavras cada. ex: "Tests hit one interface", "Pricing logic stops leaking", "Delete 4 shallow wrappers".
- **ADR callout** (se aplicável) — uma linha em uma caixa âmbar.

Sem parágrafos de explicação. Se o diagrama precisar de um parágrafo para ser entendido, redesenhe o diagrama.

## Padrões de diagrama

Escolha o padrão que encaixa no candidato. Misture. Não faça todo diagrama parecer igual — variedade faz parte do ponto.

### Mermaid graph (o cavalo de batalha para dependências / call flow)

Use um Mermaid `flowchart` ou `graph` quando o ponto for "X chama Y chama Z, e olha a bagunça". Envolva em um card estilizado com Tailwind para não parecer que caiu do céu. Estilize com classDef para colorir arestas de leakage em vermelho e o módulo deep escuro. Sequence diagrams funcionam bem para "before: 6 round-trips; after: 1."

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

### Caixas-e-setas construídas à mão (quando o layout do Mermaid briga com você)

Módulos como `<div>`s com bordas e labels. Setas como elementos SVG inline `<line>` ou `<path>` posicionados absolutamente sobre um container relativo. Recorra a isso quando quiser que o diagrama "after" sinta como um módulo profundo com borda grossa e internos acinzentados — Mermaid não vai renderizar com o peso certo.

### Cross-section (bom para layered shallowness)

Empilhe bandas horizontais (`h-12 border-l-4`) para mostrar camadas que uma chamada atravessa. Before: 6 camadas finas cada uma fazendo nada. After: 1 banda grossa rotulada com a responsabilidade consolidada.

### Mass diagram (bom para "interface tão larga quanto a implementação")

Dois retângulos por módulo — um para superfície de interface, um para implementação. Before: retângulo de interface quase tão alto quanto o de implementação (shallow). After: retângulo de interface curto, retângulo de implementação alto (deep).

### Call-graph collapse

Before: uma árvore de chamadas de função renderizada como caixas aninhadas. After: a mesma árvore colapsada em uma caixa, com as chamadas agora internas mostradas esmaecidas dentro dela.

## Guia de estilo

- Prefira editorial, não dashboard corporativo. Espaçamento generoso. Serif opcional para headings (`font-serif` funciona bem com stone/slate).
- Cor com parcimônia: um accent (emerald ou indigo) + vermelho para leakage e âmbar para avisos.
- Mantenha diagramas ~320px de altura para before/after ficar confortável lado a lado sem scroll.
- Use `text-xs uppercase tracking-wider` para labels de módulo dentro dos diagramas — devem ler como esquemático, não como UI.
- Os únicos scripts são o Tailwind CDN e o import ESM do Mermaid. O relatório é caso contrário estático — sem código de app, sem interatividade além da renderização do próprio Mermaid.
