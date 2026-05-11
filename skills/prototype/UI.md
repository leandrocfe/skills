# Protótipo de UI

Gere **várias variações radicalmente diferentes de UI** em uma única rota, alternáveis por barra flutuante no fim da tela. Usuário alterna no browser, escolhe uma (ou rouba pedaços de cada), descarta o resto.

Se a pergunta é sobre lógica/estado em vez do que aparece — ramo errado. Use [LOGIC.md](LOGIC.md).

## Quando esse é o formato certo

- "Como essa página deveria parecer?"
- "Quero ver algumas opções pro dashboard antes de comprometer"
- "Testa um layout diferente pra tela de configurações"
- Toda vez que o usuário gastaria um dia escolhendo entre três mockups vagos na cabeça

## Dois sub-formatos — fortemente prefira o A

Protótipo de UI é muito mais fácil de julgar quando **bate contra o resto do app** — header real, sidebar real, dado real, densidade real. Rota descartável sozinha é vácuo: cada variante parece ok isolada. Default pro sub-formato A sempre que houver página existente plausível pra hospedar as variantes. Só vá pra B se o protótipo genuinamente não tem casa próxima.

### Sub-formato A — ajuste a página existente (preferido)

A rota já existe. Variantes são renderizadas **na mesma rota**, gated por search param de URL `?variant=`. Data fetching, params e auth existentes ficam — só o rendering troca. Esse é o default; escolha a menos que tenha motivo específico pra não.

Se o protótipo é pra algo que ainda não tem página mas **naturalmente moraria dentro de uma** (nova seção do dashboard, novo card na tela de settings, novo passo num fluxo existente) — ainda é sub-formato A. Monte as variantes dentro da página host.

### Sub-formato B — página nova (último recurso)

Só use quando o que está sendo prototipado genuinamente não tem página existente pra morar dentro — ex: superfície top-level inteiramente nova, ou fluxo que não pode ser embedded em lugar sensato.

Crie **rota descartável** seguindo qualquer convenção de roteamento que o projeto já use — não invente estrutura top-level nova. Nomeie de forma que seja **obviamente** protótipo (ex: inclua "prototype" no path ou nome do arquivo). Mesmo padrão `?variant=`.

Antes de cair pra sub-formato B, sanidade: realmente não há página existente onde isso poderia ser embedded? Rota vazia esconde problemas de design que uma página populada exporia.

Em ambos os sub-formatos a barra flutuante é idêntica.

## Processo

### 1. Declare a pergunta e escolha N

Default: **3 variantes**. Mais de 5 deixa de ser radicalmente diferente e vira ruído — limite ali.

Escreva o plano em uma linha, no local do protótipo ou comentário no topo do arquivo:

> "Três variantes da página de configurações, alternáveis via `?variant=`, na rota existente `/settings`."

### 2. Gere variantes radicalmente diferentes

Rascunhe cada variante. Cada uma submetida a:

- Propósito da página e dado disponível
- Biblioteca de componentes / sistema de estilo do projeto (TailwindCSS, shadcn, MUI, CSS puro, qualquer)
- Nome de componente exportado claro, ex: `VariantA`, `VariantB`, `VariantC`

Variantes têm que ser **estruturalmente diferentes** — layout diferente, hierarquia de informação diferente, affordance primária diferente, **não** só cores diferentes. Três grids de cards levemente tweakados não é protótipo de UI, é wallpaper. Se duas saírem parecidas demais, refaça uma com instrução explícita "não use grid de cards".

### 3. Conecte tudo

Crie um único componente switcher na rota:

```tsx
// pseudo-código — adapte ao framework do projeto
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

Sub-formato A (página existente): mantenha todo o data fetching acima do switcher; só a sub-árvore renderizada muda por variante.

Sub-formato B (página nova): rota descartável em `/prototype/<nome>` monta o mesmo switcher.

### 4. Construa a barra flutuante

Pequena barra fixed-position no centro inferior da tela com três peças:

- **Seta esquerda** — cicla pra variante anterior (wrap)
- **Label da variante** — mostra chave atual e, se a variante exporta nome, esse nome também. Ex: `B — Layout com sidebar`
- **Seta direita** — cicla pra frente (wrap)

Comportamento:

- Clicar atualiza o search param da URL (use o router do framework — `router.replace` no Next, `navigate` no React Router) pra variante ser compartilhável e estável em reload
- Teclado: setas `←` e `→` também ciclam. **Não** intercepte quando `<input>`, `<textarea>` ou `[contenteditable]` está focado.
- Visualmente distinto da página (ex: pílula de alto contraste, shadow sutil) pra ficar óbvio que **não** faz parte do design sendo avaliado
- **Escondido em builds de produção** — gate em `process.env.NODE_ENV !== 'production'` ou check equivalente, pra um merge errado de protótipo não enviar a barra pra usuários

Ponha o switcher em um único componente compartilhado pra ambos os sub-formatos reusarem. Localize onde UI compartilhada vive no projeto.

### 5. Entrega

Compartilhe a URL (e as chaves `?variant=`). Usuário vai alternar quando puder. O feedback interessante geralmente é **"quero o header do B com a sidebar do C"** — esse é o design real que ele quer.

### 6. Capture a resposta e limpe

Quando uma variante vencer, escreva qual e por quê (commit, ADR, issue, ou `NOTES.md`). Depois:

- **Sub-formato A** — delete as variantes perdedoras e o switcher; dobre a vencedora na página existente
- **Sub-formato B** — promova a variante vencedora a rota real, delete a rota descartável e o switcher

Não deixe componentes de variante ou o switcher por aí. Apodrecem rápido e confundem o próximo leitor.

## Anti-padrões

- **Variantes que diferem só em cor ou cópia.** É tweak, não protótipo. Variantes reais discordam sobre estrutura.
- **Compartilhar código demais entre variantes.** `<Header>` compartilhado tudo bem; `<Layout>` compartilhado derrota o ponto. Cada variante deve ser livre pra jogar o layout fora.
- **Conectar variantes a mutations reais.** Protótipos read-only servem. Se variante precisa mutar, aponte pra stub — a pergunta é "como deveria parecer", não "o backend funciona".
- **Promover o protótipo direto pra produção.** Código de variante foi escrito sob restrições de protótipo (sem testes, error handling mínimo). Reescreva direito quando dobrar.
