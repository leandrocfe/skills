---
name: setup-leandrocfe-skills
description: Configura este repo para as engineering skills — configura seu issue tracker, vocabulário de triage labels e layout de docs de domínio. Rode uma vez antes do primeiro uso das outras engineering skills.
disable-model-invocation: true
---

# Setup leandrocfe Skills

Faz o scaffold da configuração por-repo que as engineering skills assumem:

- **Issue tracker** — onde issues vivem (GitHub por default; markdown local também é suportado out of the box)
- **Triage labels** — as strings usadas para as cinco roles canônicas de triage
- **Domain docs** — onde `CONTEXT.md` e ADRs vivem, e as regras de consumo para lê-los

Esta é uma skill prompt-driven, não um script determinístico. Explore, apresente o que achou, confirme com o usuário, depois escreva.

## Processo

### 1. Explore

Olhe o repo atual para entender o estado inicial. Leia o que existe; não assuma:

- `git remote -v` e `.git/config` — é um repo GitHub? Qual?
- `AGENTS.md` e `CLAUDE.md` na raiz do repo — algum existe? Já há uma seção `## Agent skills` em algum?
- `CONTEXT.md` e `CONTEXT-MAP.md` na raiz do repo
- `docs/adr/` e quaisquer diretórios `src/*/docs/adr/`
- `docs/agents/` — output anterior desta skill já existe?
- `.scratch/` — sinal de que uma convenção de issue tracker em markdown local já está em uso

### 2. Apresente findings e pergunte

Resuma o que está presente e o que falta. Depois caminhe com o usuário pelas três decisões **uma de cada vez** — apresente uma seção, pegue a resposta do usuário, depois passe à próxima. Não jogue as três de uma vez.

Assuma que o usuário não sabe o que esses termos significam. Cada seção começa com um explainer curto (o que é, por que essas skills precisam, o que muda se ele escolher diferente). Depois mostre as escolhas e o default.

**Seção A — Issue tracker.**

> Explainer: O "issue tracker" é onde issues vivem para este repo. Skills como `to-issues`, `triage`, `to-prd` leem e escrevem nele — precisam saber se chamam `gh issue create`, escrevem um markdown sob `.scratch/` ou seguem algum outro workflow que você descreve. Escolha o lugar onde você de fato rastreia trabalho deste repo.

Postura default: estas skills foram desenhadas para GitHub. Se um `git remote` aponta para GitHub, proponha. Se um `git remote` aponta para GitLab (`gitlab.com` ou host self-hosted), proponha GitLab. Senão (ou se o usuário preferir), ofereça:

- **GitHub** — issues vivem no GitHub Issues do repo (usa CLI `gh`)
- **GitLab** — issues vivem no GitLab Issues do repo (usa CLI [`glab`](https://gitlab.com/gitlab-org/cli))
- **Markdown local** — issues vivem como arquivos sob `.scratch/<feature>/` neste repo (bom para projetos solo ou repos sem remote)
- **Other** (Jira, Linear, etc.) — peça ao usuário para descrever o workflow num parágrafo; a skill registra como prosa freeform

Se — e somente se — o usuário escolheu **GitHub** ou **GitLab**, faça uma pergunta de follow-up:

> Explainer: Repos open-source frequentemente recebem feature requests como pull requests, não só issues — um PR é um issue com código anexado. Se você ligar isso, `/triage` puxa PRs *externos* para a mesma fila e roda pelos mesmos labels e estados que issues (PRs em voo de colaboradores são deixados em paz). Deixe desligado se PRs não forem uma superfície de request para você.

- **PRs como superfície de request** — sim / não (default: não). Registre a resposta em `docs/agents/issue-tracker.md`. Para local-markdown e outros trackers, pule esta pergunta — não há PRs.

**Seção B — Vocabulário de triage labels.**

> Explainer: Quando a skill `triage` processa uma issue recebida, ela a move por uma máquina-de-estado — precisa de avaliação, esperando reporter, pronta para AFK agent pegar, pronta para humano, ou wontfix. Para isso, precisa aplicar labels (ou equivalente no seu issue tracker) que batam com strings *que você de fato configurou*. Se seu repo já usa nomes diferentes de label (ex.: `bug:triage` em vez de `needs-triage`), mapeie aqui para a skill aplicar as certas em vez de criar duplicatas.

As cinco roles canônicas:

- `needs-triage` — mantenedor precisa avaliar
- `needs-info` — esperando reporter
- `ready-for-agent` — totalmente especificada, AFK-ready (um agent pode pegar sem contexto humano)
- `ready-for-human` — precisa de implementação humana
- `wontfix` — não vai ser feita

Default: a string de cada role é igual ao nome. Pergunte ao usuário se quer sobrepor alguma. Se o issue tracker dele não tem labels existentes, os defaults servem.

**Seção C — Docs de domínio.**

> Explainer: Algumas skills (`improve-codebase-architecture`, `diagnosing-bugs`, `tdd`) leem um arquivo `CONTEXT.md` para aprender a linguagem de domínio do projeto, e `docs/adr/` para decisões arquiteturais passadas. Precisam saber se o repo tem um contexto global único ou múltiplos (ex.: um monorepo com contextos separados frontend/backend) para procurar no lugar certo.

Confirme o layout:

- **Single-context** — um `CONTEXT.md` + `docs/adr/` na raiz do repo. Maioria dos repos é assim.
- **Multi-context** — `CONTEXT-MAP.md` na raiz apontando para arquivos `CONTEXT.md` por contexto (tipicamente um monorepo).

### 3. Confirme e edite

Mostre ao usuário um rascunho de:

- O bloco `## Agent skills` para adicionar a qualquer um entre `CLAUDE.md` / `AGENTS.md` que estiver sendo editado (veja step 4 para regras de seleção)
- O conteúdo de `docs/agents/issue-tracker.md`, `docs/agents/triage-labels.md`, `docs/agents/domain.md`

Deixe ele editar antes de escrever.

### 4. Escreva

**Escolha o arquivo a editar:**

- Se `CLAUDE.md` existir, edite.
- Senão se `AGENTS.md` existir, edite.
- Se nenhum existir, pergunte ao usuário qual criar — não escolha por ele.

Nunca crie `AGENTS.md` quando `CLAUDE.md` já existe (ou vice-versa) — sempre edite o que já está lá.

Se um bloco `## Agent skills` já existe no arquivo escolhido, atualize seu conteúdo in-place em vez de anexar duplicata. Não sobrescreva edits do usuário nas seções ao redor.

O bloco:

```markdown
## Agent skills

### Issue tracker

[resumo de uma linha de onde issues são rastreadas, mais se PRs externos são uma superfície de triage]. Veja `docs/agents/issue-tracker.md`.

### Triage labels

[resumo de uma linha do vocabulário de labels]. Veja `docs/agents/triage-labels.md`.

### Domain docs

[resumo de uma linha do layout — "single-context" ou "multi-context"]. Veja `docs/agents/domain.md`.
```

Depois escreva os três docs files usando os templates seed nesta pasta de skill como ponto de partida:

- [issue-tracker-github.md](./issue-tracker-github.md) — issue tracker GitHub
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md) — issue tracker GitLab
- [issue-tracker-local.md](./issue-tracker-local.md) — issue tracker markdown local
- [triage-labels.md](./triage-labels.md) — mapeamento de labels
- [domain.md](./domain.md) — regras de consumidor de docs de domínio + layout

Para issue trackers "other", escreva `docs/agents/issue-tracker.md` do zero usando a descrição do usuário.

### 5. Done

Diga ao usuário que o setup está completo e quais engineering skills agora vão ler desses arquivos. Mencione que ele pode editar `docs/agents/*.md` direto depois — re-rodar esta skill só é necessário se ele quiser trocar de issue tracker ou recomeçar do zero.
