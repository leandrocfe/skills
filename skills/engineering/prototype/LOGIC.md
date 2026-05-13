# Logic Prototype

Uma terminal app interativa minúscula que deixa o usuário dirigir um state model na mão. Use isto quando a pergunta for sobre **business logic, transições de estado ou data shape** — o tipo de coisa que parece razoável no papel mas só se mostra errada quando você empurra por casos reais.

## Quando esta é a forma certa

- "Não tenho certeza se essa state machine dá conta do edge case X seguido de Y."
- "Esse data model deixa eu representar de fato o caso em que..."
- "Quero sentir como a API deveria parecer antes de escrevê-la."
- Qualquer coisa em que o usuário quer **apertar botões e ver o estado mudar**.

Se a pergunta for "como isso deveria parecer" — vertente errada. Use [UI.md](UI.md).

## Processo

### 1. Declare a pergunta

Antes de escrever código, escreva qual state model e qual pergunta você está prototipando. Um parágrafo, no README do protótipo ou comentário no topo do arquivo. Um logic prototype que responde a pergunta errada é desperdício puro — torne a pergunta explícita para que possa ser conferida depois, com o usuário olhando agora ou voltando AFK.

### 2. Escolha a linguagem

Use o que o projeto host usa. Se o projeto não tem runtime óbvio (ex.: repo de docs), pergunte.

Combine com as convenções existentes do projeto para tooling — não adicione um novo package manager ou runtime só para o protótipo.

### 3. Isole a lógica num módulo portável

Coloque a lógica de verdade — o pedaço que responde a pergunta — atrás de uma interface pequena e pura que poderia ser arrancada e dropada na codebase real depois. A TUI ao redor é descartável; o módulo de lógica não deve ser.

O shape certo depende da pergunta:

- **Um reducer puro** — `(state, action) => state`. Bom quando as actions são eventos discretos e o estado é um valor único.
- **Uma state machine** — estados e transições explícitos. Bom quando "quais actions são sequer legais agora" é parte da pergunta.
- **Um conjunto pequeno de funções puras** sobre um data type simples. Bom quando não há estado implícito atual — só transformações.
- **Uma classe ou módulo com superfície de método clara** quando a lógica de fato é dona de estado interno contínuo.

Escolha o shape que melhor encaixa na pergunta sendo feita, *não* o mais fácil de ligar numa TUI. Mantenha puro: sem I/O, sem código de terminal, sem `console.log` para fluxo de controle. A TUI importa e chama; nada flui na outra direção.

É isso que torna o protótipo útil além da sua própria vida. Quando a pergunta for respondida, o reducer / machine / set de funções validado pode ser içado para o módulo real — a casca da TUI vai ser deletada.

### 4. Construa a menor TUI que expõe o estado

Construa como uma **TUI lightweight** — em cada tick, limpe a tela (`console.clear()` / `print("\033[2J\033[H")` / equivalente) e re-renderize o frame inteiro. O usuário sempre deve ver uma view estável, não um scrollback que cresce sem parar.

Cada frame tem duas partes, nesta ordem:

1. **Estado atual**, pretty-printed e diff-friendly (um campo por linha, ou JSON formatado). Use **bold** para nomes de campos ou headers de seção e **dim** para contexto menos importante (timestamps, IDs, valores derivados). ANSI escape codes nativos servem — `\x1b[1m` bold, `\x1b[2m` dim, `\x1b[0m` reset. Sem necessidade de puxar lib de styling a menos que o projeto já tenha uma.
2. **Atalhos de teclado**, listados embaixo: `[a] add user  [d] delete user  [t] tick clock  [q] quit`. Bold na tecla, dim na descrição, ou vice-versa — o que ler limpo.

Comportamento:

1. **Inicialize o estado** — um único objeto/struct em memória. Renderize o primeiro frame no start.
2. **Leia um keystroke (ou uma linha)** por vez, despache para um handler que muta o estado.
3. **Re-renderize** o frame inteiro depois de cada ação — não anexe, substitua.
4. **Loop até quit.**

O frame inteiro deve caber numa tela.

### 5. Torne executável em um comando

Adicione um script ao task runner existente do projeto (`package.json` scripts, `Makefile`, `justfile`, `pyproject.toml`). O usuário deve rodar `pnpm run <prototype-name>` ou equivalente — sem precisar lembrar de um path.

Se o projeto host não tem task runner, ponha o comando no topo do README do protótipo.

### 6. Entregue

Dê ao usuário o run command. Ele vai dirigir; os momentos interessantes são quando ele fala "espera, isso não devia ser possível" ou "hum, achei que X seria diferente" — esses são bugs na _ideia_, que é o ponto todo. Se ele quiser actions novas, adicione. Protótipos evoluem.

### 7. Capture a resposta

Quando o protótipo cumprir sua função, a resposta da pergunta é a única coisa que vale guardar. Se o usuário estiver disponível, pergunte o que ele aprendeu. Se não, deixe um `NOTES.md` ao lado do protótipo para a resposta ser preenchida (ou ser preenchida por você, se você assistiu a sessão) antes do protótipo ser deletado.

## Anti-patterns

- **Não adicione testes.** Um protótipo que precisa de testes não é mais um protótipo.
- **Não ligue ao database real.** Use um store em memória a menos que a pergunta seja especificamente sobre persistência.
- **Não generalize.** Nada de "e se a gente quisesse suportar X depois". O protótipo responde uma pergunta.
- **Não misture a lógica e a TUI.** Se o reducer / state machine referencia `console.log`, prompts ou escape codes de terminal, não é mais portável. Mantenha a TUI como uma casca fina sobre um módulo puro.
- **Não suba a casca da TUI para produção.** A casca é otimizada para ser dirigida na mão de um terminal. O módulo de lógica atrás dela é o pedaço que vale guardar.
