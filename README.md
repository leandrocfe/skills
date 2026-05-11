# leandrocfe-skills

> Skills do Claude Code em pt-BR para desenvolvimento real, não vibe coding.

Coleção de skills que uso no dia a dia para trabalhar com método, evidência e disciplina. Inspirada no trabalho do [Matt Pocock](https://github.com/mattpocock/skills) e adaptada para o público brasileiro, com termos, exemplos e tom em pt-BR — não tradução literal.

Desenvolver software de verdade é difícil. Abordagens como GSD, BMAD e Spec-Kit tentam ajudar **dominando** o processo. Mas ao fazer isso, tiram seu controle e tornam bugs no processo difíceis de resolver.

Estas skills são pequenas, fáceis de adaptar e composáveis. Funcionam com qualquer modelo. São baseadas em décadas de experiência de desenvolvimento. Mexa nelas. Faça suas.

## Instalação rápida

```bash
npx skills@latest add leandrocfe/skills
```

Depois rode `/setup-leandrocfe-skills` no seu agente. Ele vai perguntar:

- Qual Rastreador de Issues você usa (GitHub, GitLab, Markdown local)
- Que labels você aplica em triagem
- Onde quer salvar docs de domínio

Pronto — você está configurado.

## Por que estas skills existem

Para consertar modos de falha comuns que vejo com Claude Code, Codex e outros agentes de código.

### Problema 1 — O agente não fez o que eu queria

> "Ninguém sabe exatamente o que quer."
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.com.br/Programador-Pragm%C3%A1tico-Aprendiz-Mestre/dp/8577807738)

**O problema.** O modo de falha mais comum em desenvolvimento é **desalinhamento**. Você acha que o dev sabe o que você quer. Aí vê o que ele construiu — e percebe que ele não te entendeu.

Mesma coisa na era da IA. Existe um gap de comunicação entre você e o agente. A cura é uma **sessão de grill** — fazer o agente te questionar até toda decisão estar explícita.

**A correção:**

- [`/grill-me`](./skills/grill-me/SKILL.md) — para usos não-código
- [`/grill-with-docs`](./skills/grill-with-docs/SKILL.md) — igual ao `grill-me`, mas valida contra o domínio documentado e atualiza `CONTEXT.md` / ADRs **durante** a conversa

Use sempre que for fazer uma mudança não-trivial. **Estas são as skills que mais uso.**

### Problema 2 — O agente é prolixo demais

> "Com uma linguagem ubíqua, conversas entre devs e expressões no código são derivadas do mesmo modelo de domínio."
>
> Eric Evans, [Domain-Driven Design](https://www.amazon.com.br/Domain-Driven-Design-Eric-Evans/dp/8550800651)

**O problema.** No início de um projeto, devs e o pessoal de domínio falam línguas diferentes.

Eu sentia a mesma tensão com meus agentes. Eles entram no projeto e tentam descobrir o jargão sozinhos. Então usam 20 palavras onde 1 bastaria.

**A correção** é linguagem compartilhada. Um documento que ajuda agentes a decodificar o jargão do projeto.

<details>
<summary>Exemplo</summary>

- **ANTES:** "Tem um problema quando uma lição dentro de uma seção de um curso é tornada 'real' (i.e. recebe um lugar no sistema de arquivos)"
- **DEPOIS:** "Tem um problema com a cascata de materialização"

Essa concisão paga em toda sessão.

</details>

Isso está embutido em [`/grill-with-docs`](./skills/grill-with-docs/SKILL.md). É grill que constrói linguagem compartilhada e registra decisões difíceis em ADRs.

> [!TIP]
> Linguagem compartilhada tem outros benefícios além de reduzir prolixidade:
>
> - **Variáveis, funções e arquivos são nomeados consistentemente** usando a linguagem compartilhada
> - Como resultado, o **codebase fica mais fácil de navegar** pelo agente
> - O agente também **gasta menos tokens pensando**, porque tem acesso a linguagem mais concisa

### Problema 3 — O código não funciona

> "Sempre dê passos pequenos e deliberados. Taxa de feedback é seu limite de velocidade. Nunca pegue uma tarefa grande demais."
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.com.br/Programador-Pragm%C3%A1tico-Aprendiz-Mestre/dp/8577807738)

**O problema.** Digamos que você e o agente estão alinhados. O que acontece quando ele **ainda** produz lixo?

Hora de olhar seus loops de feedback. Sem feedback de como o código que produz realmente roda, o agente está voando às cegas.

**A correção:** loops de feedback — tipos estáticos, acesso a browser, testes automatizados.

Pra testes, **red-green-refactor** é crítico. Agente escreve teste que falha primeiro, depois corrige. Isso dá ao agente nível consistente de feedback que resulta em código muito melhor.

- [`/tdd`](./skills/tdd/SKILL.md) — TDD disciplinado em fatias verticais, com arquivos de apoio sobre [testes bons vs ruins](./skills/tdd/tests.md), [mocking](./skills/tdd/mocking.md), [módulos profundos](./skills/tdd/deep-modules.md), [interface design](./skills/tdd/interface-design.md), [candidatos a refator](./skills/tdd/refactoring.md)
- [`/diagnose`](./skills/diagnose/SKILL.md) — loop de feedback é o **núcleo** da skill; bisseção, hipótese e instrumentação consomem o loop

### Problema 4 — Construímos uma bola de lama

> "Invista no design do sistema _todo dia_."
>
> Kent Beck, [Extreme Programming Explained](https://www.amazon.com.br/Extreme-Programming-Explained-Embrace-Change/dp/0201616416)

> "Os melhores módulos são profundos. Permitem muita funcionalidade através de interface simples."
>
> John Ousterhout, [A Philosophy of Software Design](https://www.amazon.com.br/Philosophy-Software-Design-2nd/dp/173210221X)

**O problema.** A maioria dos apps construídos com agentes é complexa e difícil de mudar. Como agentes aceleram codificação, eles aceleram **entropia de software**. Codebases ficam complexos numa velocidade nova.

**A correção** é uma abordagem radicalmente nova ao desenvolvimento com IA: **se importar com design de código**.

Isso está embutido em toda camada destas skills:

- [`/to-prd`](./skills/to-prd/SKILL.md) te questiona sobre quais módulos você está tocando antes de criar um PRD
- [`/zoom-out`](./skills/zoom-out/SKILL.md) instrui o agente a explicar código no contexto do sistema inteiro
- [`/prototype`](./skills/prototype/SKILL.md) constrói protótipo descartável pra forçar decisões antes de comprometer

E crucialmente:

- [`/improve-codebase-architecture`](./skills/improve-codebase-architecture/SKILL.md) resgata codebase que virou bola de lama. Recomendação: rodar a cada poucos dias.

### Resumo

Fundamentos de desenvolvimento de software importam mais do que nunca. Estas skills são minha melhor tentativa de condensar esses fundamentos em práticas repetíveis, pra te ajudar a entregar os melhores apps da sua carreira.

## Skills

### Setup (rodar 1× por repo)

| Skill | O que faz |
|-------|-----------|
| [setup-leandrocfe-skills](./skills/setup-leandrocfe-skills/SKILL.md) | Scaffolding inicial — define tracker, labels de triagem, docs de domínio |

| Skill | O que faz |
|-------|-----------|
| [grill-me](./skills/grill-me/SKILL.md) | Entrevista relentless sobre seu plano até cada decisão estar clara |
| [grill-with-docs](./skills/grill-with-docs/SKILL.md) | Confronta seu plano contra o domínio documentado, atualiza CONTEXT.md/ADRs inline |
| [to-prd](./skills/to-prd/SKILL.md) | Compacta conversa em PRD bem-formado e submete ao tracker |
| [to-issues](./skills/to-issues/SKILL.md) | Quebra plano/PRD em issues independentes e acionáveis |
| [triage](./skills/triage/SKILL.md) | Triagem por máquina de estados (categoria + estado, AFK-ready) |
| [tdd](./skills/tdd/SKILL.md) | Red-green-refactor disciplinado, fatias verticais, sem mock-everything |
| [diagnose](./skills/diagnose/SKILL.md) | Loop de feedback determinístico no centro; bisseção/hipótese/instrumentação consomem |
| [zoom-out](./skills/zoom-out/SKILL.md) | Mapa do sistema acima do detalhe atual |
| [improve-codebase-architecture](./skills/improve-codebase-architecture/SKILL.md) | Resgata bola de lama — encontra oportunidades de aprofundamento |
| [prototype](./skills/prototype/SKILL.md) | Protótipo descartável (terminal pra lógica, UI variants em rota) |

### Produtividade

| Skill | O que faz |
|-------|-----------|
| [caveman](./skills/caveman/SKILL.md) | Modo compressão: ~75% menos tokens, sem perder precisão técnica |
| [handoff](./skills/handoff/SKILL.md) | Comprime conversa atual em documento de handoff acionável |
| [write-a-skill](./skills/write-a-skill/SKILL.md) | Meta-skill: cria nova skill seguindo o formato deste plugin |

## Filosofia

- **Fatias verticais > horizontais** — caminhos funcionais ponta-a-ponta antes de inchar camadas
- **Disciplina > velocidade aparente** — TDD, diagnóstico estruturado, decisões registradas
- **Linguagem ubíqua** — termos canônicos em [CONTEXT.md](./CONTEXT.md) usados por todas as skills
- **Anti-vibe-coding** — toda skill aqui existe pra forçar entendimento antes de código
- **Cético com mocks** — testes de integração quando dá, mocks só onde realmente isola
- **Design diário** — `/improve-codebase-architecture` recorrente combate entropia

## Como contribuir

Skills são opinionadas e refletem como **eu** trabalho. Forks são bem-vindos pra adaptar ao seu fluxo. PRs corrigindo bugs/typos: bem-vindos. PRs adicionando skills novas: abra uma issue primeiro pra discussão.

## Créditos

Conceitos, estrutura de pasta e padrão de SKILL.md inspirados no trabalho do [Matt Pocock](https://github.com/mattpocock/skills) sob licença MIT. Cada skill aqui foi **reescrita em pt-BR**, com adaptações próprias pra o público brasileiro (não é tradução literal).

Livros que moldaram este plugin:

- David Thomas & Andrew Hunt — [The Pragmatic Programmer](https://www.amazon.com.br/Programador-Pragm%C3%A1tico-Aprendiz-Mestre/dp/8577807738)
- Eric Evans — [Domain-Driven Design](https://www.amazon.com.br/Domain-Driven-Design-Eric-Evans/dp/8550800651)
- Kent Beck — [Extreme Programming Explained](https://www.amazon.com.br/Extreme-Programming-Explained-Embrace-Change/dp/0201616416)
- John Ousterhout — [A Philosophy of Software Design](https://www.amazon.com.br/Philosophy-Software-Design-2nd/dp/173210221X)
- Michael Feathers — Working Effectively with Legacy Code (conceito de **seam**)

## Licença

[MIT](./LICENSE) © 2026 Leandro Ferreira
