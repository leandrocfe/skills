# Skills Para Engenheiros De Verdade

Skills de agente que o [Matt Pocock](https://github.com/mattpocock/skills/) usa todo dia para fazer engenharia de verdade — não vibe coding.

Desenvolver aplicações reais é difícil. Abordagens como GSD, BMAD e Spec-Kit tentam ajudar tomando conta do processo. Mas ao fazer isso, tiram seu controle e dificultam resolver bugs no próprio processo.

Estas skills são pequenas, fáceis de adaptar e componíveis. Funcionam com qualquer modelo. São baseadas em décadas de experiência de engenharia. Hackeie. Torne suas. Aproveite.

Se quiser acompanhar as mudanças destas skills e qualquer uma nova que ele criar, pode se juntar a ~60.000 outros devs na newsletter dele:

[Inscreva-se na Newsletter](https://www.aihero.dev/s/skills-newsletter)

## Quickstart (setup de 30 segundos)

1. Rode o installer do skills.sh:

```bash
npx skills@latest add leandrocfe/skills
```

2. Escolha as skills que quer, e em quais coding agents instalar. **Garanta que selecionou `/setup-leandrocfe-skills`**.

3. Rode `/setup-leandrocfe-skills` no seu agente. Ele vai:
   - Perguntar qual issue tracker você quer usar (GitHub, GitLab, Linear ou arquivos locais)
   - Perguntar quais labels você aplica em tickets quando faz triage (`/triage` usa labels)
   - Perguntar se PRs externos devem ser uma superfície de request para `/triage`
   - Perguntar onde você quer salvar os docs que criamos

4. Pronto — você está apto.

## Por Que Estas Skills Existem

O [Matt Pocock](https://github.com/mattpocock/skills/) construiu estas skills como forma de corrigir failure modes comuns que ele vê com Claude Code, Codex e outros coding agents.

### #1: O Agente Não Fez O Que Eu Quero

> "Ninguém sabe exatamente o que quer"
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**O Problema**. O failure mode mais comum no desenvolvimento de software é desalinhamento. Você acha que o dev sabe o que você quer. Aí você vê o que ele construiu — e percebe que ele não te entendeu nada.

É o mesmo na era da IA. Existe um gap de comunicação entre você e o agente. A correção para isso é uma **sessão de sabatina** — fazer o agente te perguntar coisas detalhadas sobre o que você está construindo.

**A Correção** é usar:

- [`/grill-me`](./skills/productivity/grill-me/SKILL.md) — para usos não-código
- [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) — igual ao [`/grill-me`](./skills/productivity/grill-me/SKILL.md), mas constrói o domain model, atualiza `CONTEXT.md` e ADRs

São algumas das skills mais populares. Te ajudam a alinhar com o agente antes de começar, e a pensar fundo sobre a mudança que você está fazendo. Use-as _toda_ vez que quiser fazer uma mudança.

### #2: O Agente É Verboso Demais

> Com uma ubiquitous language, as conversas entre devs e as expressões no código derivam do mesmo domain model.
>
> Eric Evans, [Domain-Driven-Design](https://www.amazon.co.uk/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)

**O Problema**: No começo de um projeto, devs e as pessoas para quem estão construindo o software (os domain experts) geralmente falam línguas diferentes.

Matt sentiu a mesma tensão com seus agents. Agentes geralmente são jogados num projeto e devem se virar com o jargão. Aí usam 20 palavras quando 1 bastava.

**A Correção** é uma linguagem compartilhada. É um documento que ajuda agentes a decodificar o jargão usado no projeto.

<details>
<summary>
Exemplo
</summary>

Aqui um exemplo de [`CONTEXT.md`](https://github.com/mattpocock/course-video-manager/blob/076a5a7a182db0fe1e62971dd7a68bcadf010f1c/CONTEXT.md), do repo `course-video-manager` do Matt. Qual é mais fácil de ler?

- **ANTES**: "Tem um problema quando uma lesson dentro de uma section de um course é tornada 'real' (i.e. ganha um lugar no file system)"
- **DEPOIS**: "Tem um problema com o materialization cascade"

Essa concisão paga dividendo sessão após sessão.

</details>

Isso está embutido em [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) + [`/domain-modeling`](./skills/engineering/domain-modeling/SKILL.md). É uma sessão de sabatina que te ajuda a construir uma linguagem compartilhada com a IA e documentar decisões difíceis de explicar em ADRs.

É difícil explicar o quanto isso é poderoso. Pode ser uma das técnicas mais legais deste repo. Experimente e veja.

> [!TIP]
> Uma linguagem compartilhada tem muitos outros benefícios além de reduzir verbosidade:
>
> - **Variáveis, funções e arquivos são nomeados de forma consistente**, usando a linguagem compartilhada
> - Como consequência, a **codebase fica mais fácil de navegar** pelo agente
> - O agente também **gasta menos tokens pensando**, porque tem acesso a uma linguagem mais concisa

### #3: O Código Não Funciona

> "Sempre dê passos pequenos e deliberados. A taxa de feedback é o seu speed limit. Nunca pegue uma task grande demais."
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**O Problema**: Digamos que você e o agente estão alinhados sobre o que construir. O que acontece quando o agente _ainda assim_ produz porcaria?

É hora de olhar seus feedback loops. Sem feedback de como o código que ele produz roda de verdade, o agente vai voar cego.

**A Correção**: Você precisa do trio usual de feedback loops: tipos estáticos, acesso ao browser e testes automatizados.

Para testes automatizados, um loop red-green-refactor é crítico. Aí o agente escreve um teste que falha primeiro, depois conserta o teste. Isso dá ao agente um nível consistente de feedback que resulta em código bem melhor.

O Matt criou uma **skill [`/tdd`](./skills/engineering/tdd/SKILL.md)** que você pluga em qualquer projeto. Ela incentiva red-green-refactor e dá ao agente bastante orientação sobre o que é teste bom e ruim.

Para debug, Matt também criou uma skill **[`/diagnosing-bugs`](./skills/engineering/diagnosing-bugs/SKILL.md)** que embrulha as melhores práticas de debugging num loop simples e disciplinado.

### #4: Construímos Uma Ball Of Mud

> "Invista no design do sistema _todo dia_."
>
> Kent Beck, [Extreme Programming Explained](https://www.amazon.co.uk/Extreme-Programming-Explained-Embrace-Change/dp/0321278658)

> "Os melhores módulos são deep. Permitem que muita funcionalidade seja acessada através de uma interface simples."
>
> John Ousterhout, [A Philosophy Of Software Design](https://www.amazon.co.uk/Philosophy-Software-Design-2nd/dp/173210221X)

**O Problema**: A maioria dos apps construídos com agentes é complexa e difícil de mudar. Como agentes podem acelerar radicalmente coding, eles também aceleram entropia de software. Codebases ficam mais complexas a uma taxa sem precedentes.

**A Correção** é uma abordagem radicalmente nova ao desenvolvimento powered-by-AI: importar com o design do código.

Isso está embutido em cada camada destas skills:

- [`/to-spec`](./skills/engineering/to-spec/SKILL.md) te sabatina sobre quais módulos você está tocando antes de criar uma spec
- [`/improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) te ajuda a resgatar uma codebase que virou ball of mud. Recomendo rodar na sua codebase a cada poucos dias.

## Resumo

Fundamentos de engenharia de software importam mais que nunca. Estas skills são o melhor esforço do Matt para condensar esses fundamentos em práticas repetíveis, para te ajudar a entregar os melhores apps da sua carreira. Aproveite.

## Referência

Estas se dividem em um eixo — quem pode invocá-las. **User-invoked** skills são alcançáveis apenas quando você as digita (ex: `/grill-me`); o trabalho delas é orquestrar. **Model-invoked** skills podem ser invocadas por você _ou_ alcançadas automaticamente pelo agent quando a task encaixa; elas contêm a disciplina reutilizável. Uma user-invoked skill pode invocar model-invoked skills, mas nunca outra user-invoked.

### Engineering

Skills que uso todo dia para trabalho com código.

**User-invoked**

- **[ask-matt](./skills/engineering/ask-matt/SKILL.md)** — Pergunte qual skill ou fluxo encaixa na sua situação. Um router sobre as skills deste repo.
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)** — Sessão de sabatina que também constrói o domain model do projeto, afiando terminologia e atualizando `CONTEXT.md` e ADRs inline.
- **[triage](./skills/engineering/triage/SKILL.md)** — Move issues e PRs externos através de uma máquina de estados de triage roles.
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)** — Escaneia uma codebase em busca de oportunidades de deepening, apresenta como relatório HTML visual e depois sabatina a escolhida.
- **[setup-leandrocfe-skills](./skills/engineering/setup-leandrocfe-skills/SKILL.md)** — Configura este repo para as engineering skills (issue tracker, triage labels, domain doc layout). Rode uma vez por repo antes de usar as outras engineering skills.
- **[to-spec](./skills/engineering/to-spec/SKILL.md)** — Transforma a conversa atual em uma spec e publica no issue tracker. Sem entrevista — só sintetiza o que você já discutiu.
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)** — Quebra qualquer plano, spec ou conversa em tickets tracer-bullet, cada um declarando suas blocking edges — texto num arquivo local, ou links de blocking nativos num tracker de verdade.
- **[wayfinder](./skills/engineering/wayfinder/SKILL.md)** — Planeja um pedaço enorme de trabalho — maior do que uma sessão de agent segura — como um mapa compartilhado de tickets de investigação no issue tracker, resolvidos um por vez até o caminho até o destino ficar claro.
- **[implement](./skills/engineering/implement/SKILL.md)** — Implementa um pedaço de trabalho a partir de uma spec ou conjunto de tickets, conduzindo `/tdd` e fechando com `/code-review`.

**Model-invoked**

- **[prototype](./skills/engineering/prototype/SKILL.md)** — Constrói um protótipo descartável para responder a uma pergunta de design: um app terminal executável para perguntas de estado/business logic, ou várias variações radicalmente diferentes de UI alternáveis numa rota só.
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)** — Loop disciplinado de diagnóstico para bugs difíceis e regressões de performance: reproduzir → minimizar → hipotetizar → instrumentar → corrigir → testar regressão.
- **[research](./skills/engineering/research/SKILL.md)** — Investiga uma pergunta contra fontes primárias de alta confiança e registra os achados como um Markdown citado no repo, rodando como background agent.
- **[tdd](./skills/engineering/tdd/SKILL.md)** — Test-driven development com o loop red → green. Constrói features ou corrige bugs uma vertical slice por vez, em seams pré-acordados.
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)** — Constrói e afia ativamente o modelo de domínio de um projeto — desafia termos contra o glossário, stress-testa com cenários de edge-case e atualiza `CONTEXT.md` e ADRs inline.
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)** — Disciplina e vocabulário compartilhados para projetar deep modules: muito comportamento atrás de uma interface pequena, colocado em um seam limpo, testável através da interface.
- **[code-review](./skills/engineering/code-review/SKILL.md)** — Revisão em dois eixos do diff desde um ponto fixo: **Standards** (segue os padrões do repo, mais uma baseline de code smells do Fowler?) e **Spec** (implementa fielmente a issue/spec de origem?), rodando como sub-agents paralelos.
- **[resolving-merge-conflicts](./skills/engineering/resolving-merge-conflicts/SKILL.md)** — Loop para resolver um merge ou rebase em andamento com conflitos.

### Productivity

Ferramentas gerais de workflow, não específicas de código.

**User-invoked**

- **[grill-me](./skills/productivity/grill-me/SKILL.md)** — Seja sabatinado sem dó sobre um plano ou design até cada ramo da árvore de decisão estar resolvido.
- **[handoff](./skills/productivity/handoff/SKILL.md)** — Compacta a conversa atual em documento de handoff para outro agent continuar o trabalho.
- **[teach](./skills/productivity/teach/SKILL.md)** — Ensine um novo skill ou conceito ao usuário em múltiplas sessões, usando o diretório atual como workspace de ensino stateful.
- **[writing-great-skills](./skills/productivity/writing-great-skills/SKILL.md)** — Referência para escrever e editar skills bem: o vocabulário e princípios que tornam uma skill previsível.

**Model-invoked**

- **[grilling](./skills/productivity/grilling/SKILL.md)** — Entrevista o usuário sem dó sobre um plano ou design até cada ramo da árvore de decisão estar resolvido. O loop reutilizável por trás de `grill-me` e `grill-with-docs`.

### Misc

Ferramentas que mantenho por perto mas raramente uso.

- **[git-guardrails-claude-code](./skills/misc/git-guardrails-claude-code/SKILL.md)** — Configura hooks do Claude Code para bloquear comandos git perigosos (push, reset --hard, clean, etc.) antes que executem.
- **[migrate-to-shoehorn](./skills/misc/migrate-to-shoehorn/SKILL.md)** — Migra arquivos de teste de type assertions `as` para @total-typescript/shoehorn.
- **[scaffold-exercises](./skills/misc/scaffold-exercises/SKILL.md)** — Cria estruturas de diretório de exercícios com seções, problems, solutions e explainers.
- **[setup-pre-commit](./skills/misc/setup-pre-commit/SKILL.md)** — Configura hooks pre-commit com Husky, lint-staged, Prettier, type checking e testes.

## Créditos

Este projeto é uma adaptação não-oficial em português do Brasil das skills criadas por **[Matt Pocock](https://github.com/mattpocock/skills/)**. Estrutura, fluxo, filosofia e comportamento das skills foram preservados — linguagem e exemplos foram adaptados ao contexto brasileiro.

Repositório original: https://github.com/mattpocock/skills

Newsletter do Matt: https://www.aihero.dev/s/skills-newsletter

Todo o crédito de design, intenção e conteúdo original vai para o [Matt Pocock](https://github.com/mattpocock/skills/).
