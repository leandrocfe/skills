---
name: write-a-skill
description: "Cria uma nova skill seguindo o formato canônico deste plugin (frontmatter, estrutura de corpo, gatilhos bilíngues, anti-padrões). Use quando usuário pedir \"criar skill\", \"escrever skill\", \"nova skill\", \"adicionar skill ao plugin\", ou invocar /write-a-skill. Triggers: \"write a skill\", \"new skill\", \"create skill\"."
---

# write-a-skill

Skill meta. Cria novas skills com formato consistente, bem disparáveis e que efetivamente disciplinam o agente.

## <o-que-fazer>

### Passo 1 — Entrevistar até entender

Antes de escrever **uma linha** de SKILL.md, faça as perguntas abaixo, **uma por vez**. Não pule.

1. **Qual problema essa skill resolve?** (Não "o que ela faz" — qual problema do usuário ou anti-padrão do agente ela mata.)
2. **Quando o usuário invoca?** (Frases naturais em pt-BR e EN, comando slash, contexto de tarefa.)
3. **Qual é o resultado bom?** (Arquivo gerado, comportamento mudado, decisão registrada — concreto.)
4. **Qual é a falha clássica que essa skill previne?** (Sem isso, agente faria o quê de errado?)
5. **Quais skills do plugin ela referencia ou depende?** (Cross-refs por path relativo.)
6. **Quais termos do `CONTEXT.md` ela usa?** Se introduzir termo novo, atualizar `CONTEXT.md` antes.

Se a skill tem menos que 3 respostas concretas para 1–4, **ela não está pronta para ser escrita**. Volte e refine o conceito.

### Passo 2 — Escolher slug

Slug = nome do diretório = valor de `name` no frontmatter.

- Kebab-case (`minha-skill`, não `minhaSkill` nem `minha_skill`)
- Em **inglês**, alinhado com o restante do plugin
- Verbo + objeto quando possível (`to-prd`, `write-a-skill`, `grill-with-docs`)
- Único — não colidir com slug existente em `.claude-plugin/plugin.json`

### Passo 3 — Criar estrutura

```bash
mkdir -p skills/<slug>
touch skills/<slug>/SKILL.md
```

Se a skill precisa de arquivos de apoio (templates, formatos, scripts), criar ao lado:

```
skills/<slug>/
├── SKILL.md
├── TEMPLATE.md      # se relevante
└── scripts/         # se relevante
```

### Passo 4 — Escrever frontmatter

Frontmatter obrigatório:

```yaml
---
name: <slug>
description: <O que faz em pt-BR, 1 frase>. Use quando <gatilho 1>, <gatilho 2>, <gatilho 3>, ou usuário invocar /<slug>. Triggers: "<termo EN 1>", "<termo EN 2>".
---
```

Regras para `description`:

- **Começa com a função em pt-BR.** 1 frase, sem hedging.
- **Depois "Use quando..."** com 2–4 gatilhos em pt-BR usando aspas ou frases naturais.
- **Termina com "Triggers:"** listando termos consagrados em EN entre aspas.
- **Inclua o comando slash** (`/<slug>`).
- **Não inventar gatilhos artificiais.** Frases que o usuário diria de verdade.

Bom:
```
description: Cria PRD bem-formado a partir da conversa atual e submete ao Rastreador de Issues. Use quando usuário pedir "gerar PRD", "criar documento de produto", "transformar isso em PRD", ou invocar /to-prd. Triggers: "to PRD", "product requirements".
```

Ruim:
```
description: Esta é uma skill que ajuda com PRDs.
```
(Genérico, sem gatilho, sem comando.)

### Passo 5 — Escrever corpo

Estrutura:

```markdown
# <nome-da-skill>

<1 parágrafo curto explicando a função e o anti-padrão que ela combate.>

## <o-que-fazer>

<Instruções imperativas pro agente. Numeradas. Sem hedging.>

### Passo 1 — <ação>
...

### Passo 2 — <ação>
...

## <info-de-apoio>

<Referência, filosofia, anti-padrões, exemplos.>

### Anti-padrões

- **NÃO** faça X porque Y
- **NÃO** faça Z porque W

### Exemplos

<Exemplos concretos com código/output literal quando possível.>

## Cross-references

- [outra-skill](../outra-skill/SKILL.md) — quando usar junto
- [`CONTEXT.md`](../../CONTEXT.md) — termos canônicos
```

### Passo 6 — Registrar em `plugin.json`

Adicionar caminho da skill em `.claude-plugin/plugin.json`:

```json
{
  "skills": [
    "./skills/tdd",
    "./skills/<sua-nova-skill>"
  ]
}
```

Manter ordem aproximadamente consistente (mas não é mecanicamente importante).

### Passo 7 — Atualizar `README.md`

Adicionar linha na tabela da categoria apropriada com:

- Nome da skill linkado ao `SKILL.md`
- Descrição de 1 linha (curta, ativa)

### Passo 8 — Validar

```bash
# JSON válido
jq . .claude-plugin/plugin.json

# Path existe
test -f skills/<slug>/SKILL.md && echo OK

# Frontmatter parseável (head + python yaml ou awk)
head -10 skills/<slug>/SKILL.md
```

## <info-de-apoio>

### Anti-padrões

- **NÃO escreva description vago.** "Helper para X" não dispara skill. Use gatilhos concretos que usuário diria.
- **NÃO inche.** Skill de 1500 linhas é skill mal-pensada. Se passar de ~500, decompor.
- **NÃO traduza tudo.** TDD, PRD, ADR, handoff, refactor — termos consagrados ficam em inglês.
- **NÃO redefine termo do `CONTEXT.md`.** Referencie. Se termo não existir lá, adicione antes.
- **NÃO escreva em "voz didática".** Imperativo direto. "Faça X. Não faça Y." Não "você pode considerar fazer X".
- **NÃO crie cross-ref pra skill que não existe ainda.** Quebra navegação.
- **NÃO escreva exemplos genéricos.** "function foo() {}" é inútil. Exemplo real do problema que a skill resolve.

### Padrões de gatilhos que funcionam

- **Frase natural pt-BR:** "diagnosticar bug", "modo caverna", "passar bastão"
- **Comando slash explícito:** "/tdd", "/diagnose"
- **Termo EN consagrado:** "TDD", "red-green-refactor", "handoff"
- **Imperativo curto:** "me grelha", "estresse esse plano"

### Quanto detalhe colocar?

A skill precisa ser **executável** pelo agente sem precisar perguntar. Se você tem dúvida sobre algum passo, o agente também terá. Resolva no SKILL.md.

Mas: não duplique conhecimento que o agente já tem. Não explique "o que é TDD" — explique **como esta skill aplica TDD neste plugin**.

### Tamanho típico

- **Mínimo viável:** ~80 linhas (skills simples como `caveman`)
- **Típico:** ~200-400 linhas
- **Máximo razoável:** ~500 linhas. Acima disso, decompor em arquivos de apoio.

### Quando criar arquivo de apoio vs inline

Crie arquivo separado (`TEMPLATE.md`, `FORMAT.md`, etc.) quando:

- Conteúdo é referenciado por outra skill também
- Template grande que o agente vai copiar/preencher (mais de ~30 linhas)
- Lista de verificação extensa que merece existência própria

Caso contrário, inline em `SKILL.md`.

## Cross-references

- [`CONTEXT.md`](../../CONTEXT.md) — vocabulário canônico que sua skill deve usar
- [grill-me](../grill-me/SKILL.md) — use **antes** de escrever a skill se o conceito ainda está turvo
- [`.claude-plugin/plugin.json`](../../.claude-plugin/plugin.json) — onde registrar a skill nova
