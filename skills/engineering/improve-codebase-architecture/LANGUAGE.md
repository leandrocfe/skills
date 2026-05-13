# Language

Vocabulário compartilhado para cada sugestão que esta skill faz. Use estes termos exatamente — não substitua por "component", "service", "API" ou "boundary". Linguagem consistente é o ponto inteiro.

## Termos

**Module**
Qualquer coisa com interface e implementação. Deliberadamente scale-agnostic — vale igualmente para uma função, classe, pacote ou slice cruzando tiers.
_Avoid_: unit, component, service.

**Interface**
Tudo que um caller precisa saber para usar o módulo corretamente. Inclui a type signature, mas também invariantes, ordering constraints, error modes, configuração obrigatória e características de performance.
_Avoid_: API, signature (estreito demais — referem só à superfície type-level).

**Implementation**
O que está dentro de um módulo — seu corpo de código. Distinto de **Adapter**: uma coisa pode ser um adapter pequeno com implementação grande (um Postgres repo) ou um adapter grande com implementação pequena (um in-memory fake). Use "adapter" quando o seam é o tópico; "implementation" caso contrário.

**Depth**
Leverage na interface — a quantidade de comportamento que um caller (ou teste) consegue exercitar por unidade de interface que precisa aprender. Um módulo é **deep** quando muito comportamento sentar atrás de uma interface pequena. Um módulo é **shallow** quando a interface é quase tão complexa quanto a implementação.

**Seam** _(do Michael Feathers)_
Um lugar onde você pode alterar comportamento sem editar naquele lugar. A *localização* em que a interface de um módulo vive. Escolher onde pôr o seam é decisão de design própria, distinta do que vai atrás dele.
_Avoid_: boundary (sobrecarregado com bounded context do DDD).

**Adapter**
Coisa concreta que satisfaz uma interface num seam. Descreve *role* (que slot preenche), não substância (o que tem dentro).

**Leverage**
O que callers ganham de depth. Mais capacidade por unidade de interface que precisam aprender. Uma implementação retorna investimento por N call sites e M testes.

**Locality**
O que mantenedores ganham de depth. Change, bugs, knowledge e verificação se concentram num lugar em vez de espalhar entre callers. Conserte uma vez, consertado em todo lugar.

## Princípios

- **Depth é propriedade da interface, não da implementação.** Um deep module pode ser internamente composto de partes pequenas, mockáveis, intercambiáveis — só que não fazem parte da interface. Um módulo pode ter **internal seams** (privados à sua implementação, usados pelos próprios testes) tanto quanto o **external seam** na sua interface.
- **O deletion test.** Imagine deletar o módulo. Se complexidade some, o módulo não estava escondendo nada (era pass-through). Se complexidade reaparece em N callers, o módulo estava ganhando o pão.
- **A interface é a test surface.** Callers e testes cruzam o mesmo seam. Se você quer testar *além* da interface, o módulo provavelmente tem shape errado.
- **One adapter é seam hipotético. Two adapters é real.** Não introduza um seam a menos que algo de fato varie por ele.

## Relações

- Um **Module** tem exatamente uma **Interface** (a superfície que apresenta a callers e testes).
- **Depth** é propriedade de um **Module**, medida contra sua **Interface**.
- Um **Seam** é onde a **Interface** de um **Module** vive.
- Um **Adapter** senta num **Seam** e satisfaz a **Interface**.
- **Depth** produz **Leverage** para callers e **Locality** para mantenedores.

## Framings rejeitados

- **Depth como razão de linhas-de-implementação para linhas-de-interface** (Ousterhout): premia inflar a implementação. Usamos depth-as-leverage em vez.
- **"Interface" como a keyword TypeScript `interface` ou os métodos públicos de uma classe**: estreito demais — interface aqui inclui todo fato que um caller precisa saber.
- **"Boundary"**: sobrecarregado com bounded context do DDD. Diga **seam** ou **interface**.
