# Out-of-Scope Knowledge Base

O diretório `.out-of-scope/` num repo guarda registros persistentes de feature requests rejeitadas. Serve a dois propósitos:

1. **Memória institucional** — por que uma feature foi rejeitada, para o raciocínio não se perder quando a issue é fechada
2. **Deduplicação** — quando uma issue nova chega que bate com uma rejeição anterior, a skill pode trazer a decisão prévia à tona em vez de re-litigar

## Estrutura do diretório

```
.out-of-scope/
├── dark-mode.md
├── plugin-system.md
└── graphql-api.md
```

Um arquivo por **conceito**, não por issue. Múltiplas issues pedindo a mesma coisa são agrupadas sob um arquivo.

## Formato do arquivo

O arquivo deve ser escrito num estilo relaxado e legível — mais como um short design document que uma database entry. Use parágrafos, code samples e exemplos para tornar o raciocínio claro e útil a alguém encontrando pela primeira vez.

```markdown
# Dark Mode

This project does not support dark mode or user-facing theming.

## Why this is out of scope

The rendering pipeline assumes a single color palette defined in
`ThemeConfig`. Supporting multiple themes would require:

- A theme context provider wrapping the entire component tree
- Per-component theme-aware style resolution
- A persistence layer for user theme preferences

This is a significant architectural change that doesn't align with the
project's focus on content authoring. Theming is a concern for downstream
consumers who embed or redistribute the output.

```ts
// The current ThemeConfig interface is not designed for runtime switching:
interface ThemeConfig {
  colors: ColorPalette; // single palette, resolved at build time
  fonts: FontStack;
}
```

## Prior requests

- #42 — "Add dark mode support"
- #87 — "Night theme for accessibility"
- #134 — "Dark theme option"
```

### Nomeando o arquivo

Use um nome kebab-case curto e descritivo do conceito: `dark-mode.md`, `plugin-system.md`, `graphql-api.md`. O nome deve ser reconhecível o suficiente para que alguém navegando o diretório entenda o que foi rejeitado sem abrir o arquivo.

### Escrevendo o motivo

O motivo deve ser substancial — não "a gente não quer isso" mas por quê. Bons motivos referenciam:

- Escopo ou filosofia do projeto ("Este projeto foca em X; theming é preocupação downstream")
- Constraints técnicas ("Suportar isso exigiria Y, que conflita com nossa arquitetura Z")
- Decisões estratégicas ("Escolhemos A em vez de B porque...")

O motivo deve ser durável. Evite referenciar circunstâncias temporárias ("estamos ocupados demais agora") — isso não é rejeição real, é adiamento.

## Quando checar `.out-of-scope/`

Durante triagem (Step 1: Junte contexto), leia todos os arquivos em `.out-of-scope/`. Ao avaliar uma issue nova:

- Cheque se o pedido bate com um conceito existente em out-of-scope
- Matching é por similaridade de conceito, não por keyword — "night theme" bate com `dark-mode.md`
- Se há match, traga ao mantenedor: "Isto é similar a `.out-of-scope/dark-mode.md` — rejeitamos antes porque [motivo]. Você ainda sente o mesmo?"

O mantenedor pode:

- **Confirmar** — a issue nova é adicionada à lista "Prior requests" do arquivo existente, depois fechada
- **Reconsiderar** — o arquivo out-of-scope é deletado ou atualizado, e a issue prossegue por triagem normal
- **Discordar** — as issues são relacionadas mas distintas, prossiga com triagem normal

## Quando escrever em `.out-of-scope/`

Só quando um **enhancement** (não bug) é rejeitado como `wontfix`. O fluxo:

1. Mantenedor decide que uma feature request está fora de escopo
2. Cheque se um arquivo `.out-of-scope/` correspondente já existe
3. Se sim: anexe a issue nova à lista "Prior requests"
4. Se não: crie um arquivo novo com nome do conceito, decisão, motivo e primeiro prior request
5. Poste um comment na issue explicando a decisão e mencionando o arquivo `.out-of-scope/`
6. Feche a issue com label `wontfix`

## Atualizando ou removendo arquivos out-of-scope

Se o mantenedor mudar de ideia sobre um conceito previamente rejeitado:

- Delete o arquivo `.out-of-scope/`
- A skill não precisa reabrir issues antigas — são registros históricos
- A issue nova que disparou a reconsideração prossegue por triagem normal
