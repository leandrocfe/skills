# UI Prototype

Gere **várias variações radicalmente diferentes de UI** numa rota só, alternáveis a partir de uma floating bottom bar. O usuário troca entre variantes no browser, escolhe uma (ou rouba pedaços de cada), depois joga o resto fora.

Se a pergunta é sobre lógica/estado em vez de aparência — vertente errada. Use [LOGIC.md](LOGIC.md).

## Quando esta é a forma certa

- "Como esta page deveria parecer?"
- "Quero ver umas opções para este dashboard antes de me comprometer."
- "Tenta um layout diferente pra tela de settings."
- Toda vez que o usuário gastaria um dia escolhendo entre três mockups vagos na cabeça.

## Duas sub-formas — prefira fortemente a sub-forma A

Um UI prototype é muito mais fácil de julgar quando está **encostando no resto do app** — header real, sidebar real, dados reais, densidade real. Uma rota descartável sozinha é um vácuo: toda variante parece OK em isolamento. Default para sub-forma A sempre que houver uma page existente plausível para hospedar as variantes. Só recorra à sub-forma B se o protótipo genuinamente não tem casa por perto.

### Sub-forma A — ajuste numa page existente (preferido)

A rota já existe. Variantes são renderizadas **na mesma rota**, gatadas por um URL search param `?variant=`. Data fetching, params e auth existentes ficam — só a renderização troca. Este é o default; escolha esta a menos que tenha razão específica para não.

Se o protótipo é para algo que ainda não tem page mas *naturalmente viveria dentro de uma* (uma seção nova do dashboard, um card novo na tela de settings, um step novo num flow existente) — ainda é sub-forma A. Monte as variantes dentro da page host.

### Sub-forma B — uma page nova (último recurso)

Use só quando a coisa sendo prototipada genuinamente não tem page existente para morar dentro — ex.: uma superfície top-level inteiramente nova, ou um flow que não pode ser embedado em nenhum lugar sensato.

Crie uma **rota descartável** seguindo qualquer convenção de routing que o projeto já usa — não invente uma nova estrutura top-level. Nomeie de forma que seja óbvio que é protótipo (ex.: inclua a palavra `prototype` no path ou nome do arquivo). Mesmo padrão `?variant=`.

Antes de se comprometer com sub-forma B, sanity-check: realmente não tem page existente em que isso poderia ser embedado? Uma rota vazia esconde problemas de design que uma populada exporia.

Nas duas sub-formas a floating bottom bar é idêntica.

## Processo

### 1. Declare a pergunta e escolha N

Default para **3 variantes**. Mais que 5 deixa de ser radicalmente diferente e vira ruído — cap aí.

Escreva o plano numa linha, no local do protótipo ou num comentário no topo do arquivo:

> "Três variantes da settings page, alternáveis via `?variant=`, na rota `/settings` existente."

Isso funciona com o usuário aqui para empurrar de volta ou não.

### 2. Gere variantes radicalmente diferentes

Rascunhe cada variante. Cobre cada uma:

- O propósito da page e os dados a que tem acesso.
- A component library / styling system do projeto (TailwindCSS, shadcn, MUI, plain CSS, o que for).
- Um nome de componente exportado claro, ex.: `VariantA`, `VariantB`, `VariantC`.

Variantes precisam ser **estruturalmente diferentes** — layout diferente, hierarquia de informação diferente, primary affordance diferente, não só cores diferentes. Três card grids levemente ajustadas não é UI prototype, é papel de parede. Se dois rascunhos saírem parecidos demais, refaça um com orientação explícita "não usar card grid".

### 3. Ligue tudo junto

Crie um único componente switcher na rota:

```tsx
// pseudo-code — adapte ao framework do projeto
const variant = searchParams.get('variant') ?? 'A';
return (
  <>
    {variant === 'A' && <VariantA {...data} />}
    {variant === 'B' && <VariantB {...data} />}
    {variant === 'C' && <VariantC {...data} />}
    <PrototypeSwitcher variants={['A','B','C']} current={variant} />
  </>
);
```

Para sub-forma A (page existente): mantenha todo o data fetching existente acima do switcher; só a subárvore renderizada muda por variante.

Para sub-forma B (page nova): a rota descartável sob `/prototype/<nome>` monta o mesmo switcher.

### 4. Construa o floating switcher

Uma barra pequena em fixed-position no bottom-center da tela com três pedaços:

- **Seta esquerda** — cicla para a variante anterior (faz wrap-around).
- **Label da variante** — mostra a chave atual e, se a variante exportou um nome, esse nome também. Ex.: `B — Sidebar layout`.
- **Seta direita** — cicla pra frente (faz wrap-around).

Comportamento:

- Clicar numa seta atualiza o URL search param (use o router do framework — `router.replace` no Next, `navigate` no React Router, etc) para a variante ser compartilhável e estável a reload.
- Teclado: setas `←` e `→` também ciclam. Não intercepte as setas quando um `<input>`, `<textarea>` ou `[contenteditable]` estiver focado.
- Visualmente distinta da page (ex.: pill de alto contraste, sombra sutil) para ser óbvio que não faz parte do design sendo avaliado.
- Escondida em production builds — gate em `process.env.NODE_ENV !== 'production'` ou check equivalente, para um merge de protótipo perdido não conseguir mandar a barra para usuários.

Ponha o switcher num componente compartilhado para as duas sub-formas reusarem. Localize onde UI compartilhada mora no projeto.

### 5. Entregue

Apresente a URL (e as chaves `?variant=`). O usuário vai folhear quando der. O feedback interessante normalmente é **"quero o header do B com a sidebar do C"** — esse é o design que ele quer de fato.

### 6. Capture a resposta e faça cleanup

Quando uma variante ganhar, escreva qual e por quê (commit message, ADR, issue, ou um `NOTES.md` ao lado do protótipo se rodando AFK e o usuário ainda não respondeu). Depois:

- **Sub-forma A** — delete as variantes perdedoras e o switcher; absorva a vencedora na page existente.
- **Sub-forma B** — promova a variante vencedora para uma rota real, delete a rota descartável e o switcher.

Não deixe componentes de variante ou o switcher largados. Apodrecem rápido e confundem o próximo leitor.

## Anti-patterns

- **Variantes que diferem só em cor ou copy.** Isso é tweak, não protótipo. Variantes reais discordam sobre estrutura.
- **Compartilhar muito código entre variantes.** Um `<Header>` compartilhado é OK; um `<Layout>` compartilhado mata o ponto. Cada variante deve ser livre para jogar o layout fora.
- **Ligar variantes a mutations reais.** Protótipos read-only servem. Se uma variante precisa mutar, aponte para um stub — a pergunta é "como isso deveria parecer", não "o backend funciona".
- **Promover o protótipo direto para produção.** O código da variante foi escrito sob constraints de protótipo (sem testes, error handling mínimo). Reescreva direito quando absorver.
