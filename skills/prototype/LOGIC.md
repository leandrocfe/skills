# Protótipo de Lógica

App pequeno e interativo de terminal que deixa o usuário dirigir um state model **na mão**. Use quando a pergunta é sobre **lógica de negócio, transições de estado, ou shape de dado** — o tipo de coisa que parece razoável no papel mas só sente errado quando você empurra por casos reais.

## Quando esse é o formato certo

- "Não tenho certeza se essa state machine lida com o caso onde X depois Y"
- "Esse data model **deixa** eu representar o caso onde..."
- "Quero sentir como a API deveria ser antes de escrever"
- Qualquer coisa onde o usuário quer **apertar botões e ver estado mudar**

Se a pergunta é "como isso deveria parecer" — ramo errado. Use [UI.md](UI.md).

## Processo

### 1. Declare a pergunta

Antes de escrever código, escreva qual state model e qual pergunta você está prototipando. Um parágrafo, no README do protótipo ou comentário no topo do arquivo. Protótipo que responde a pergunta errada é puro desperdício — torne a pergunta explícita pra ser checada depois.

### 2. Escolha a linguagem

Use a que o projeto host usa. Se o projeto não tem runtime óbvio (ex: repo de docs), pergunte.

Case com convenções de ferramenta existentes — não adicione package manager ou runtime novo só pro protótipo.

### 3. Isole a lógica em módulo portável

Coloque a lógica real — a parte que está respondendo à pergunta — atrás de interface pequena e pura que poderia ser **levantada e dropada** no codebase real depois. A TUI ao redor é descartável; o módulo de lógica **não deveria ser**.

A forma certa depende da pergunta:

- **Reducer puro** — `(state, action) => state`. Bom quando ações são eventos discretos e estado é um único valor.
- **State machine** — estados explícitos e transições. Bom quando "quais ações são legais agora" faz parte da pergunta.
- **Conjunto pequeno de funções puras** sobre um tipo de dado simples. Bom quando não há estado atual implícito — só transformações.
- **Classe ou módulo com superfície de método clara** quando a lógica genuinamente possui estado interno contínuo.

Escolha a forma que melhor casa com a **pergunta**, *não* a mais fácil de conectar a uma TUI. Mantenha puro: sem I/O, sem código de terminal, sem `console.log` pra controle de fluxo. A TUI importa e chama; nada flui no sentido inverso.

Isso é o que faz o protótipo útil além da própria vida. Quando a pergunta foi respondida, o reducer / machine / conjunto de funções validado pode ser levantado pro módulo real — a casca TUI é deletada.

### 4. Construa a TUI mínima que expõe o estado

Construa como **TUI leve** — a cada tick, limpe a tela (`console.clear()` / `print("\033[2J\033[H")` / equivalente) e re-renderize o frame inteiro. Usuário deve sempre ver **uma view estável**, não scrollback crescente.

Cada frame tem duas partes, nessa ordem:

1. **Estado atual**, pretty-printed e diff-friendly (um campo por linha, ou JSON formatado). Use **bold** pra nomes de campo ou cabeçalhos, **dim** pra contexto menos importante (timestamps, IDs, valores derivados). Códigos ANSI nativos servem — `\x1b[1m` bold, `\x1b[2m` dim, `\x1b[0m` reset. Sem necessidade de lib de styling a menos que já esteja no projeto.
2. **Atalhos de teclado**, no fim: `[a] adiciona user  [d] deleta user  [t] tick clock  [q] sair`. Bold a tecla, dim a descrição, ou vice-versa — o que ficar legível.

Comportamento:

1. **Inicializa estado** — um único objeto/struct em memória. Renderiza primeiro frame ao iniciar.
2. **Lê um keystroke (ou uma linha)** por vez, dispatcha pra handler que muta estado.
3. **Re-renderiza** o frame completo após cada ação — não anexar, substituir.
4. **Loop até sair.**

O frame inteiro deve caber em uma tela.

### 5. Faça rodar em um comando

Adicione script no task runner existente do projeto (scripts de `package.json`, `Makefile`, `justfile`, `pyproject.toml`). Usuário deve rodar `pnpm run <nome-do-prototipo>` ou equivalente — nunca precisar lembrar de path.

Se o projeto host não tem task runner, ponha o comando no topo do README do protótipo.

### 6. Entrega

Dê o comando de rodar. Usuário dirige — os momentos interessantes são quando ele diz "espera, isso não deveria ser possível" ou "huh, eu assumi que X seria diferente" — esses são os bugs **na ideia**, que é o ponto inteiro. Se ele quer ações novas, adicione. Protótipos evoluem.

### 7. Capture a resposta

Quando o protótipo fez o trabalho, a resposta à pergunta é a única coisa que vale guardar. Se usuário está disponível, pergunte o que ensinou. Se não, deixe `NOTES.md` ao lado pra resposta ser preenchida (ou você preenche, se assistiu a sessão) antes do protótipo ser deletado.

## Anti-padrões

- **Não adicione testes.** Protótipo que precisa de testes deixou de ser protótipo.
- **Não conecte ao banco real.** Use store em memória a menos que a pergunta seja **especificamente** sobre persistência.
- **Não generalize.** Sem "e se a gente quisesse suportar X depois". Protótipo responde uma pergunta.
- **Não borre lógica e TUI.** Se o reducer / state machine referencia `console.log`, prompts, ou escape codes de terminal, deixou de ser portável. Mantenha TUI como shell fina sobre módulo puro.
- **Não envie o shell TUI pra produção.** O shell foi otimizado pra ser dirigido na mão pelo terminal. Módulo de lógica atrás é a parte que vale.
