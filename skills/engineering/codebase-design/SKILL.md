---
name: codebase-design
description: Vocabulário compartilhado para projetar módulos profundos (deep modules). Use quando o usuário quiser projetar ou melhorar a interface de um módulo, encontrar oportunidades de deepening, decidir onde colocar um seam, tornar o código mais testável ou navegável por IA, ou quando outra skill precisar do vocabulário de deep-module.
---

# Codebase Design

Projete **módulos profundos (deep modules)**: muito comportamento atrás de uma interface pequena, posicionado em um seam limpo, testável através dessa interface. Use esta linguagem e estes princípios sempre que código estiver sendo projetado ou reestruturado. O objetivo é *leverage* para quem chama, *locality* para mantenedores e testabilidade para todos.

## Glossário

Use estes termos exatamente — não substitua por "component", "service", "API" ou "boundary". Linguagem consistente é o objetivo principal.

**Module** — qualquer coisa que tenha uma interface e uma implementação. Deliberadamente agnóstico em escala: uma função, classe, pacote ou um slice que atravessa camadas. _Evite_: unit, component, service.

**Interface** — tudo que um caller precisa saber para usar o módulo corretamente: a assinatura de tipo, mas também invariantes, restrições de ordenação, modos de erro, configuração necessária e características de performance. _Evite_: API, signature (muito estreito — referem-se apenas à superfície de tipo).

**Implementation** — o que está dentro do módulo, seu corpo de código. Diferente de **Adapter**: uma coisa pode ser um adapter pequeno com uma implementation grande (um repositório Postgres) ou um adapter grande com uma implementation pequena (um fake em memória). Use "adapter" quando o seam for o tema; "implementation" caso contrário.

**Depth** — leverage na interface: a quantidade de comportamento que um caller (ou teste) consegue exercer por unidade de interface que precisa aprender. Um módulo é **deep** quando uma grande quantidade de comportamento fica atrás de uma interface pequena, **shallow** quando a interface é quase tão complexa quanto a implementação.

**Seam** _(Michael Feathers)_ — um lugar onde você pode alterar comportamento sem editar naquele lugar; a *localização* onde a interface do módulo vive. Onde colocar o seam é uma decisão de design própria, distinta do que fica atrás dele. _Evite_: boundary (sobrecarregado com bounded context do DDD).

**Adapter** — uma coisa concreta que satisfaz uma interface em um seam. Descreve *papel* (qual slot ele preenche), não substância (o que tem dentro).

**Leverage** — o que os callers ganham com depth: mais capacidade por unidade de interface que aprendem. Uma implementação traz retorno em N pontos de chamada e M testes.

**Locality** — o que os mantenedores ganham com depth: mudança, bugs, conhecimento e verificação se concentram em um lugar só em vez de se espalharem pelos callers. Conserta uma vez, consertado em todo lugar.

## Deep vs shallow

**Deep module** = interface pequena + muita implementação:

```
┌─────────────────────┐
│   Small Interface   │  ← Poucos métodos, parâmetros simples
├─────────────────────┤
│                     │
│  Deep Implementation│  ← Lógica complexa escondida
│                     │
└─────────────────────┘
```

**Shallow module** = interface grande + pouca implementação (evite):

```
┌─────────────────────────────────┐
│       Large Interface           │  ← Muitos métodos, parâmetros complexos
├─────────────────────────────────┤
│  Thin Implementation            │  ← Apenas repassa
└─────────────────────────────────┘
```

Ao projetar uma interface, pergunte:

- Posso reduzir o número de métodos?
- Posso simplificar os parâmetros?
- Posso esconder mais complexidade por dentro?

## Princípios

- **Depth é propriedade da interface, não da implementação.** Um módulo profundo pode ser composto internamente de partes pequenas, mockáveis e trocáveis — elas simplesmente não fazem parte da interface. Um módulo pode ter **internal seams** (privados à sua implementação, usados por seus próprios testes) assim como o **external seam** na sua interface.
- **O deletion test.** Imagine deletar o módulo. Se a complexidade some, era um pass-through. Se a complexidade reaparece em N callers, ele estava cumprindo seu papel.
- **A interface é a test surface.** Callers e testes cruzam o mesmo seam. Se você quer testar *além* da interface, o módulo provavelmente tem o formato errado.
- **Um adapter significa um seam hipotético. Dois adapters significam um seam real.** Não introduza um seam a menos que algo realmente varie através dele.

## Projetando para testabilidade

Boas interfaces tornam o teste natural:

1. **Aceite dependências, não as crie.**

   ```typescript
   // Testável
   function processOrder(order, paymentGateway) {}

   // Difícil de testar
   function processOrder(order) {
     const gateway = new StripeGateway();
   }
   ```

2. **Retorne resultados, não produza side effects.**

   ```typescript
   // Testável
   function calculateDiscount(cart): Discount {}

   // Difícil de testar
   function applyDiscount(cart): void {
     cart.total -= discount;
   }
   ```

3. **Superfície pequena.** Menos métodos = menos testes necessários. Menos parâmetros = setup de teste mais simples.

## Relacionamentos

- Um **Module** tem exatamente uma **Interface** (a superfície que ele apresenta para callers e testes).
- **Depth** é propriedade de um **Module**, medida contra sua **Interface**.
- Um **Seam** é onde a **Interface** de um **Module** vive.
- Um **Adapter** senta em um **Seam** e satisfaz a **Interface**.
- **Depth** produz **Leverage** para callers e **Locality** para mantenedores.

## Enquadramentos rejeitados

- **Depth como razão entre linhas de implementação e linhas de interface** (Ousterhout): premia inflar a implementação. Usamos depth como leverage em vez disso.
- **"Interface" como a keyword `interface` do TypeScript ou métodos públicos de uma classe**: muito estreito — interface aqui inclui todo fato que um caller precisa saber.
- **"Boundary"**: sobrecarregado com bounded context do DDD. Diga **seam** ou **interface**.

## Indo mais fundo

- **Fazer deepening de um cluster considerando suas dependências** — veja [DEEPENING.md](DEEPENING.md): categorias de dependência, disciplina de seam e estratégia replace-don't-layer para testes.
- **Explorar interfaces alternativas** — veja [DESIGN-IT-TWICE.md](DESIGN-IT-TWICE.md): dispare sub-agents em paralelo para projetar a interface de várias formas radicalmente diferentes, depois compare em termos de depth, locality e posicionamento do seam.
