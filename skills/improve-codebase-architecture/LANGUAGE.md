# Linguagem

Vocabulário compartilhado por toda sugestão desta skill. Use estes termos **exatamente** — não substitua por "componente", "serviço", "API", "fronteira". Linguagem consistente é o ponto todo.

## Termos

**Módulo**
Qualquer coisa com interface e implementação. Deliberadamente sem escala — aplica-se igualmente a função, classe, pacote, fatia que cruza camadas.
_Evitar_: unit, componente, serviço.

**Interface**
Tudo que um caller precisa saber pra usar o módulo corretamente. Inclui a assinatura de tipo, mas também invariantes, restrições de ordem, modos de erro, configuração obrigatória, características de performance.
_Evitar_: API, assinatura (estreito demais — referem-se só à superfície de tipos).

**Implementação**
O que está dentro de um módulo — seu corpo de código. Distinto de **Adapter**: uma coisa pode ser adapter pequeno com implementação grande (repo Postgres) ou adapter grande com implementação pequena (fake em memória). Use "adapter" quando o seam é o tópico; "implementação" caso contrário.

**Profundidade**
Alavancagem na interface — quantidade de comportamento que um caller (ou teste) pode exercitar por unidade de interface que tem que aprender. Módulo é **profundo** quando grande quantidade de comportamento fica atrás de interface pequena. Módulo é **raso** quando interface é quase tão complexa quanto implementação.

**Seam** _(de Michael Feathers)_
Lugar onde você pode alterar comportamento sem editar **naquele** lugar. A *localização* onde a interface de um módulo vive. Escolher onde pôr o seam é decisão de design própria, distinta de o que vai atrás.
_Evitar_: fronteira (sobrecarregado com bounded context de DDD).

**Adapter**
Coisa concreta que satisfaz uma interface em um seam. Descreve *papel* (que slot preenche), não substância (o que está dentro).

**Alavancagem**
O que callers ganham com profundidade. Mais capacidade por unidade de interface que têm que aprender. Uma implementação paga em N call sites e M testes.

**Localidade**
O que mantenedores ganham com profundidade. Mudança, bugs, conhecimento e verificação concentram em **um** lugar em vez de espalhar pelos callers. Consertou uma vez, consertou em todo lugar.

## Princípios

- **Profundidade é propriedade da interface, não da implementação.** Um módulo profundo pode ser internamente composto por partes pequenas, mockáveis, trocáveis — elas só **não fazem parte da interface**. Um módulo pode ter **seams internos** (privados à sua implementação, usados pelos seus próprios testes) e o **seam externo** na sua interface.
- **Teste da deleção.** Imagine deletar o módulo. Se a complexidade some, o módulo não estava escondendo nada (era pass-through). Se a complexidade reaparece em N callers, o módulo estava ganhando seu lugar.
- **Interface é a superfície de teste.** Callers e testes cruzam o mesmo seam. Se você quer testar **além** da interface, o módulo está provavelmente na forma errada.
- **Um adapter = seam hipotético. Dois adapters = seam real.** Não introduza um seam só pra ter — algo precisa **efetivamente variar** entre adapters.

## Relações

- Um **Módulo** tem exatamente uma **Interface** (superfície que apresenta a callers e testes)
- **Profundidade** é propriedade de um **Módulo**, medida contra sua **Interface**
- Um **Seam** é onde a **Interface** de um **Módulo** vive
- Um **Adapter** fica em um **Seam** e satisfaz a **Interface**
- **Profundidade** produz **Alavancagem** pra callers e **Localidade** pra mantenedores

## Enquadramentos rejeitados

- **Profundidade como razão de linhas-de-implementação por linhas-de-interface** (Ousterhout): recompensa inchar a implementação. Usamos profundidade-como-alavancagem.
- **"Interface" como o `interface` do TypeScript ou métodos públicos de classe**: estreito demais — interface aqui inclui **todo fato** que caller precisa saber.
- **"Fronteira"**: sobrecarregado com bounded context de DDD. Use **seam** ou **interface**.
