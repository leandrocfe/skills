---
name: setup-leandrocfe-skills
description: Configura este repositório para usar as skills do plugin leandrocfe-skills — define qual Rastreador de Issues usar (GitHub, GitLab, markdown local), o vocabulário de labels de triagem e a localização dos docs de domínio (CONTEXT.md, ADRs). Rode antes do primeiro uso de `to-issues`, `to-prd`, `triage`, `diagnose`, `tdd`, ou se essas skills parecem confusas sobre tracker/labels/docs. Use quando usuário disser "configurar skills", "setup do plugin", "preparar repositório", "scaffolding inicial", ou invocar /setup-leandrocfe-skills. Triggers: "setup skills", "scaffold", "configure plugin".
disable-model-invocation: true
---

# setup-leandrocfe-skills

Scaffold da configuração per-repo que as skills assumem:

- **Rastreador de Issues** — onde issues vivem (GitHub default; GitLab e markdown local também suportados)
- **Labels de triagem** — strings reais usadas pros cinco papéis canônicos
- **Docs de domínio** — onde `CONTEXT.md` e ADRs ficam, e regras de consumo

Skill conduzida por prompt, **não script determinístico**. Explore, apresente o que encontrou, confirme com usuário, depois escreva.

## <o-que-fazer>

### Passo 1 — Explorar

Olhe o repo atual pra entender estado inicial. Leia o que existe; não assuma:

- `git remote -v` e `.git/config` — é repo GitHub? GitLab? Qual?
- `AGENTS.md` e `CLAUDE.md` na raiz — algum existe? Já tem seção `## Agent skills`?
- `CONTEXT.md` e `CONTEXT-MAP.md` na raiz
- `docs/adr/` e `src/*/docs/adr/`
- `docs/agents/` — saída prévia desta skill já existe?
- `.scratch/` — sinal de que convenção de issue local em markdown já está em uso

### Passo 2 — Apresentar e perguntar

Resuma o que está presente e o que falta. Caminhe pelas três decisões abaixo, **uma por vez** — apresente uma seção, espere resposta, próxima. Não despeje as três de uma vez.

Assuma que o usuário **não sabe** o que esses termos significam. Cada seção começa com explicação curta (o que é, por que as skills precisam, o que muda se escolher diferente). Mostre as opções e o default.

#### Seção A — Rastreador de Issues

> **Explicação:** "Rastreador de Issues" é onde as issues vivem para este repo. Skills como `to-issues`, `triage` e `to-prd` leem e escrevem nele — precisam saber se devem chamar `gh issue create`, escrever arquivo markdown em `.scratch/`, ou seguir outro workflow que você descreva. Escolha onde você **realmente** rastreia trabalho deste repo.

**Default:** estas skills foram desenhadas pensando em GitHub. Se `git remote` aponta pra GitHub, proponha GitHub. Se aponta pra GitLab, proponha GitLab. Caso contrário (ou se preferir), ofereça:

- **GitHub** — issues no GitHub Issues do repo (usa CLI `gh`)
- **GitLab** — issues no GitLab Issues do repo (usa CLI [`glab`](https://gitlab.com/gitlab-org/cli))
- **Markdown local** — issues como arquivos em `.scratch/<feature>/` neste repo (bom pra projetos solo ou repos sem remote)
- **Outro** (Jira, Linear, Azure DevOps) — peça ao usuário pra descrever o workflow em 1 parágrafo; a skill registra como prosa livre

#### Seção B — Vocabulário de labels de triagem

> **Explicação:** Quando a skill `triage` processa uma issue entrante, ela move por uma máquina de estados — precisa avaliar, esperando reporter, pronta pra agente AFK pegar, pronta pra humano, ou wontfix. Pra isso, precisa aplicar labels (ou equivalente no Rastreador) que casam com strings **que você efetivamente configurou**. Se seu repo já usa labels com outros nomes (ex: `bug:triage` em vez de `precisa-de-triagem`), mapeie aqui pra skill aplicar o nome certo em vez de criar duplicata.

Os cinco papéis canônicos:

- `precisa-de-triagem` — mantenedor precisa avaliar
- `precisa-de-info` — esperando reporter
- `pronta-pra-agente` — totalmente especificada, AFK-ready (agente pega sem contexto humano)
- `pronta-pra-humano` — precisa de humano (decisão arquitetural, acesso externo, julgamento)
- `wontfix` — não vai ser feita

**Default:** cada papel = string com o próprio nome. Pergunte se quer sobrescrever. Se o Rastreador não tem labels existentes, defaults estão bem.

#### Seção C — Docs de domínio

> **Explicação:** Algumas skills (`diagnose`, `tdd`, `grill-with-docs`) leem um arquivo `CONTEXT.md` pra aprender a linguagem do domínio do projeto, e `docs/adr/` pra decisões arquiteturais passadas. Elas precisam saber se o repo tem **um contexto global** ou **vários** (ex: monorepo com contextos separados pra frontend/backend) pra olharem no lugar certo.

Confirme o layout:

- **Contexto único** — um `CONTEXT.md` + `docs/adr/` na raiz. Maioria dos repos é assim.
- **Multi-contexto** — `CONTEXT-MAP.md` na raiz apontando pra `CONTEXT.md` por contexto (típico de monorepo).

### Passo 3 — Confirmar e editar

Mostre rascunho de:

- Bloco `## Agent skills` que será adicionado em `CLAUDE.md` / `AGENTS.md` (regras de seleção no Passo 4)
- Conteúdo de `docs/agents/issue-tracker.md`, `docs/agents/triage-labels.md`, `docs/agents/domain.md`

Deixe usuário editar antes de escrever.

### Passo 4 — Escrever

**Escolher o arquivo a editar:**

- Se `CLAUDE.md` existe, editar ele.
- Se não, mas `AGENTS.md` existe, editar ele.
- Se nenhum existe, **perguntar** ao usuário qual criar — não decidir por ele.

Nunca crie `AGENTS.md` se `CLAUDE.md` já existe (e vice-versa) — sempre editar o que já está lá.

Se já existe bloco `## Agent skills` no arquivo escolhido, atualize o conteúdo no lugar em vez de duplicar. Não sobrescreva edições do usuário em seções vizinhas.

O bloco:

```markdown
## Agent skills

### Rastreador de Issues

[resumo de 1 linha de onde issues são rastreadas]. Ver `docs/agents/issue-tracker.md`.

### Labels de triagem

[resumo de 1 linha do vocabulário de labels]. Ver `docs/agents/triage-labels.md`.

### Docs de domínio

[resumo de 1 linha do layout — "contexto único" ou "multi-contexto"]. Ver `docs/agents/domain.md`.
```

Depois escreva os três arquivos de docs usando os templates desta pasta como semente:

- [issue-tracker-github.md](./issue-tracker-github.md) — Rastreador GitHub
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md) — Rastreador GitLab
- [issue-tracker-local.md](./issue-tracker-local.md) — Markdown local
- [triage-labels.md](./triage-labels.md) — mapeamento de labels
- [domain.md](./domain.md) — regras de consumo de docs de domínio + layout

Pra Rastreadores "outro", escreva `docs/agents/issue-tracker.md` do zero usando a descrição do usuário.

### Passo 5 — Pronto

Diga ao usuário que o setup terminou e quais skills agora vão ler desses arquivos. Mencione que pode editar `docs/agents/*.md` direto depois — rodar a skill de novo só se quiser trocar de Rastreador ou recomeçar do zero.

## <info-de-apoio>

### Anti-padrões

- **NÃO** assuma sem ler. Sempre `git remote -v` antes de propor tracker.
- **NÃO** crie ambos `AGENTS.md` e `CLAUDE.md`. Edite o que existe; se nenhum existe, pergunte.
- **NÃO** dispare as três seções de uma vez. Uma por vez, com explicação.
- **NÃO** force defaults se usuário tem labels existentes — mapeie.
- **NÃO** rode setup duplicado sem checar. Se `docs/agents/` já existe, leia primeiro e proponha update, não overwrite.

### Quando re-rodar

- Trocou de Rastreador (ex: migrou GitHub → Linear)
- Vocabulário de labels mudou
- Repo virou monorepo (contexto único → multi)
- Mantenedor mudou e quer ver o setup do zero

### Por que `disable-model-invocation`

Esta skill **não** é disparada automaticamente — é setup manual. Frontmatter `disable-model-invocation: true` impede que o agente rode por engano achando que está sendo útil.

## Cross-references

- [triage](../triage/SKILL.md) — consome `triage-labels.md`
- [to-issues](../to-issues/SKILL.md) — consome `issue-tracker.md`
- [to-prd](../to-prd/SKILL.md) — consome `issue-tracker.md`
- [diagnose](../diagnose/SKILL.md) — consome `domain.md`
- [tdd](../tdd/SKILL.md) — consome `domain.md`
- [`CONTEXT.md`](../../CONTEXT.md) — vocabulário canônico
