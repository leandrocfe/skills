# Knowledge Base de Fora-de-Escopo

O diretório `.out-of-scope/` no repo guarda registros persistentes de feature requests rejeitadas. Serve a dois propósitos:

1. **Memória institucional** — por que uma feature foi rejeitada, pra raciocínio não se perder quando a issue fecha
2. **Deduplicação** — quando issue nova chega que bate com rejeição prévia, a skill mostra a decisão anterior em vez de re-litigar

## Estrutura

```
.out-of-scope/
├── modo-escuro.md
├── sistema-de-plugins.md
└── api-graphql.md
```

**Um arquivo por conceito**, não por issue. Múltiplas issues pedindo a mesma coisa ficam agrupadas em um único arquivo.

## Formato do arquivo

Estilo relaxado e legível — mais um documento curto de design do que entrada de banco de dados. Use parágrafos, exemplos de código e cenários pra deixar o raciocínio claro pra alguém encontrando o arquivo pela primeira vez.

```markdown
# Modo Escuro

Este projeto não suporta modo escuro nem theming customizado para usuários.

## Por que está fora de escopo

O pipeline de renderização assume uma única paleta definida em
`ThemeConfig`. Suportar múltiplos temas exigiria:

- Um provider de tema envolvendo a árvore inteira de componentes
- Resolução de estilo theme-aware por componente
- Camada de persistência para preferência do usuário

Mudança arquitetural grande que não alinha com o foco do projeto em
geração de conteúdo. Theming é preocupação de quem consome ou redistribui
o output.

```ts
// Interface ThemeConfig atual não foi desenhada para troca em runtime:
interface ThemeConfig {
  colors: ColorPalette; // paleta única, resolvida em build time
  fonts: FontStack;
}
```

## Pedidos prévios

- #42 — "Adicionar suporte a modo escuro"
- #87 — "Tema noturno por acessibilidade"
- #134 — "Opção de tema escuro"
```

### Nomeando o arquivo

Use kebab-case curto e descritivo: `modo-escuro.md`, `sistema-de-plugins.md`, `api-graphql.md`. Nome deve ser reconhecível o suficiente para alguém navegando o diretório entender o que foi rejeitado sem abrir o arquivo.

### Escrevendo o motivo

Motivo deve ser **substantivo** — não "a gente não quer isso" mas **por quê**. Bons motivos referenciam:

- **Escopo ou filosofia do projeto** ("Este projeto foca em X; theming é preocupação downstream")
- **Restrições técnicas** ("Suportar isso exigiria Y, que conflita com nossa arquitetura Z")
- **Decisões estratégicas** ("Escolhemos A em vez de B porque...")

Motivo deve ser **durável**. Evite referenciar circunstância temporária ("a gente tá ocupado agora") — isso não é rejeição real, é adiamento.

## Quando checar `.out-of-scope/`

Durante triagem (Passo 1: Coletar contexto), leia todos os arquivos em `.out-of-scope/`. Ao avaliar issue nova:

- Cheque se o pedido bate com conceito out-of-scope existente
- Matching é **por similaridade de conceito**, não por palavra-chave — "tema noturno" bate com `modo-escuro.md`
- Se bate, sinalize ao mantenedor: "Isso é parecido com `.out-of-scope/modo-escuro.md` — rejeitamos antes porque [motivo]. Ainda sente o mesmo?"

Mantenedor pode:

- **Confirmar** — issue nova entra na lista "Pedidos prévios" do arquivo, depois fecha
- **Reconsiderar** — arquivo out-of-scope é deletado ou atualizado, e issue prossegue pela triagem normal
- **Discordar** — issues são relacionadas mas distintas, prossegue pela triagem normal

## Quando escrever em `.out-of-scope/`

Apenas quando um **enhancement** (não bug) é rejeitado como `wontfix`. Fluxo:

1. Mantenedor decide que uma feature está fora de escopo
2. Cheque se já existe arquivo `.out-of-scope/` correspondente
3. Se sim: anexe a issue nova na lista "Pedidos prévios"
4. Se não: crie arquivo novo com nome do conceito, decisão, motivo e primeiro pedido prévio
5. Poste comentário na issue explicando a decisão e mencionando o arquivo `.out-of-scope/`
6. Feche a issue com label `wontfix`

## Atualizando ou removendo arquivos out-of-scope

Se mantenedor muda de ideia sobre conceito previamente rejeitado:

- Deletar o arquivo `.out-of-scope/`
- A skill não precisa reabrir issues antigas — elas são registros históricos
- A issue nova que motivou a reconsideração segue triagem normal
