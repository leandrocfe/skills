# Skills Para Engenheiros De Verdade

Skills de agente que o Matt Pocock usa todo dia para fazer engenharia de verdade — não vibe coding.

Desenvolver aplicações reais é difícil. Abordagens como GSD, BMAD e Spec-Kit tentam ajudar tomando conta do processo. Mas ao fazer isso, tiram seu controle e dificultam resolver bugs no próprio processo.

Estas skills são pequenas, fáceis de adaptar e componíveis. Funcionam com qualquer modelo. São baseadas em décadas de experiência de engenharia. Hackeie. Torne suas. Aproveite.

## Quickstart (setup de 30 segundos)

1. Rode o installer do skills.sh:

```bash
npx skills@latest add leandrocfe/skills
```

2. Escolha as skills que quer, e em quais coding agents instalar. **Garanta que selecionou `/setup-leandrocfe-skills`**.

3. Rode `/setup-leandrocfe-skills` no seu agente. Ele vai:
   - Perguntar qual issue tracker você quer usar (GitHub, Linear ou arquivos locais)
   - Perguntar quais labels você aplica em tickets quando triagem (`/triage` usa labels)
   - Perguntar onde você quer salvar os docs que criamos

4. Pronto — você está apto.

## Por Que Estas Skills Existem

O Matt Pocock construiu estas skills como forma de corrigir failure modes comuns que ele vê com Claude Code, Codex e outros coding agents.

### #1: O Agente Não Fez O Que Eu Quero

> "Ninguém sabe exatamente o que quer"
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**O Problema**. O failure mode mais comum no desenvolvimento de software é desalinhamento. Você acha que o dev sabe o que você quer. Aí você vê o que ele construiu — e percebe que ele não te entendeu nada.

É o mesmo na era da IA. Existe um gap de comunicação entre você e o agente. A correção para isso é uma **sessão de sabatina** — fazer o agente te perguntar coisas detalhadas sobre o que você está construindo.

**A Correção** é usar:

- [`/grill-me`](./skills/productivity/grill-me/SKILL.md) — para usos não-código
- [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) — igual ao [`/grill-me`](./skills/productivity/grill-me/SKILL.md), mas com extras (veja abaixo)

São algumas das skills mais populares do Matt Pocock. Te ajudam a alinhar com o agente antes de começar, e a pensar fundo sobre a mudança que você está fazendo. Use-as _toda_ vez que quiser fazer uma mudança.

### #2: O Agente É Verboso Demais

> Com uma ubiquitous language, as conversas entre devs e as expressões no código derivam do mesmo domain model.
>
> Eric Evans, [Domain-Driven-Design](https://www.amazon.co.uk/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)

**O Problema**: No começo de um projeto, devs e as pessoas para quem estão construindo o software (os domain experts) geralmente falam línguas diferentes.

Matt Pocock sentiu a mesma tensão com seus agentes. Agentes geralmente são jogados num projeto e devem se virar com o jargão. Aí usam 20 palavras quando 1 bastava.

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

Isso está embutido em [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md). É uma sessão de sabatina, mas que te ajuda a construir uma linguagem compartilhada com a IA e a documentar decisões difíceis de explicar em ADRs.

É difícil explicar o quanto isso é poderoso. Pode ser a única técnica mais legal deste repo. Experimente e veja.

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

O Matt Pocock criou uma **skill [`/tdd`](./skills/engineering/tdd/SKILL.md)** que você pluga em qualquer projeto. Ela incentiva red-green-refactor e dá ao agente bastante orientação sobre o que é teste bom e ruim.

Para debug, Matt Pocock também criou uma skill **[`/diagnose`](./skills/engineering/diagnose/SKILL.md)** que embrulha as melhores práticas de debugging num loop simples.

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

- [`/to-prd`](./skills/engineering/to-prd/SKILL.md) te sabatina sobre quais módulos você está tocando antes de criar um PRD
- [`/zoom-out`](./skills/engineering/zoom-out/SKILL.md) diz ao agente para explicar código no contexto do sistema inteiro

E crucial, [`/improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) te ajuda a resgatar uma codebase que virou ball of mud. Recomendo rodar na sua codebase a cada poucos dias.

### Resumo

Fundamentos de engenharia de software importam mais que nunca. Estas skills são o melhor esforço do Matt Pocock para condensar esses fundamentos em práticas repetíveis, para te ajudar a entregar os melhores apps da sua carreira. Aproveite.

## Referência

### Engineering

Skills que o Matt Pocock usa todo dia para trabalho com código.

- **[diagnose](./skills/engineering/diagnose/SKILL.md)** — Loop disciplinado de diagnóstico para bugs difíceis e regressões de performance: reproduzir → minimizar → hipotetizar → instrumentar → corrigir → testar regressão.
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)** — Sessão de sabatina que confronta seu plano contra o domain model existente, refina terminologia e atualiza `CONTEXT.md` e ADRs inline.
- **[triage](./skills/engineering/triage/SKILL.md)** — Triagem de issues através de uma máquina-de-estado de triage roles.
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)** — Encontra oportunidades de aprofundamento na codebase, informado pela linguagem de domínio em `CONTEXT.md` e pelas decisões em `docs/adr/`.
- **[setup-leandrocfe-skills](./skills/engineering/setup-leandrocfe-skills/SKILL.md)** — Faz o scaffold da config por-repo (issue tracker, vocabulário de triage labels, layout de docs de domínio) que as outras engineering skills consomem. Rode uma vez por repo antes de usar `to-issues`, `to-prd`, `triage`, `diagnose`, `tdd`, `improve-codebase-architecture` ou `zoom-out`.
- **[tdd](./skills/engineering/tdd/SKILL.md)** — Test-driven development com loop red-green-refactor. Constrói features ou corrige bugs uma vertical slice por vez.
- **[to-issues](./skills/engineering/to-issues/SKILL.md)** — Quebra qualquer plano, spec ou PRD em GitHub issues independentes via vertical slices.
- **[to-prd](./skills/engineering/to-prd/SKILL.md)** — Transforma o contexto da conversa atual em PRD e submete como GitHub issue. Sem entrevista — só sintetiza o que você já discutiu.
- **[zoom-out](./skills/engineering/zoom-out/SKILL.md)** — Pede ao agente para dar zoom out e oferecer contexto mais amplo ou perspectiva de mais alto nível sobre uma seção de código desconhecida.
- **[prototype](./skills/engineering/prototype/SKILL.md)** — Constrói um protótipo descartável para flush out de design — seja uma terminal app executável para perguntas de estado/business logic, seja várias variações radicalmente diferentes de UI alternáveis numa rota só.

### Productivity

Ferramentas gerais de workflow, não específicas de código.

- **[caveman](./skills/productivity/caveman/SKILL.md)** — Modo de comunicação ultra-comprimido. Corta ~75% do uso de tokens dropando filler enquanto mantém precisão técnica completa.
- **[grill-me](./skills/productivity/grill-me/SKILL.md)** — Seja sabatinado sem dó sobre um plano ou design até cada ramo da árvore de decisão estar resolvido.
- **[handoff](./skills/productivity/handoff/SKILL.md)** — Compacta a conversa atual em documento de handoff para outro agente continuar o trabalho.
- **[write-a-skill](./skills/productivity/write-a-skill/SKILL.md)** — Cria novas skills com estrutura correta, progressive disclosure e recursos empacotados.

## Créditos

Este projeto é uma localização não-oficial em português do Brasil das skills criadas por **Matt Pocock**. Estrutura, fluxo, filosofia e comportamento das skills foram preservados — só linguagem e exemplos foram adaptados ao contexto brasileiro.

Repositório original: https://github.com/mattpocock/skills

Newsletter do Matt: https://www.aihero.dev/s/skills-newsletter

Todo o crédito de design, intenção e conteúdo original vai para o Matt Pocock.
