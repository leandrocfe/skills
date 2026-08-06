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
- A skill `triage` está instalada? (uma pasta de skill `triage` ao lado desta, ou `triage` nas suas skills disponíveis.) Isso decide se a Seção B roda ou não.
- Sinais de monorepo — um `pnpm-workspace.yaml`, um campo `workspaces` no `package.json`, ou um `packages/*` populado com `src/` próprio. Presentes só num repo multi-package genuinamente grande; a ausência deles significa single-context, que é quase todo repo.

### 2. Apresente findings e pergunte

Resuma o que está presente e o que falta. Depois tome as seções em ordem — uma seção, uma resposta, depois a próxima.

Lidere cada seção com a resposta recomendada, para o usuário poder aceitá-la numa palavra. Dê um explainer de uma linha só quando a escolha genuinamente ramifica; pule a seção inteira quando a exploração já a resolveu (Seção B quando `triage` não está instalada, Seção C quando não há monorepo).

**Seção A — Issue tracker.**

> Explainer: O "issue tracker" é onde issues vivem para este repo. Skills como `to-tickets`, `triage` e `to-spec` leem e escrevem nele — precisam saber se chamam `gh issue create`, escrevem um markdown sob `.scratch/` ou seguem algum outro workflow que você descreve. Escolha o lugar onde você de fato rastreia trabalho deste repo.

Postura default: estas skills foram desenhadas para GitHub. Se um `git remote` aponta para GitHub, proponha. Se um `git remote` aponta para GitLab (`gitlab.com` ou host self-hosted), proponha GitLab. Senão (ou se o usuário preferir), ofereça:

- **GitHub** — issues vivem no GitHub Issues do repo (usa CLI `gh`)
- **GitLab** — issues vivem no GitLab Issues do repo (usa CLI [`glab`](https://gitlab.com/gitlab-org/cli))
- **Markdown local** — issues vivem como arquivos sob `.scratch/<feature>/` neste repo (bom para projetos solo ou repos sem remote)
- **Other** (Jira, Linear, etc.) — peça ao usuário para descrever o workflow num parágrafo; a skill registra como prosa freeform

Registre a escolha em `docs/agents/issue-tracker.md`. Os templates GitHub e GitLab carregam uma flag "PRs como superfície de request", com default **off** — deixe-a off e não a levante; um usuário que quer PRs externos na fila de triage pode virar a flag no arquivo depois.

**Seção B — Vocabulário de triage labels.** Pule esta seção inteira se a skill `triage` não estiver instalada (a exploração te disse) — uma skill não instalada não precisa de labels.

Se estiver instalada, faça exatamente uma pergunta:

> Você quer manter os triage labels default? (recomendado: **sim**)

Os defaults são as cinco roles canônicas, cada string de label igual ao seu nome: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. Em **sim**, escreva-os como estão. Só se o usuário disser não — geralmente porque o tracker dele já usa outros nomes (ex.: `bug:triage` para `needs-triage`) — colete os overrides para o `triage` aplicar labels existentes em vez de criar duplicatas.

**Seção C — Docs de domínio.** Default para **single-context** — um `CONTEXT.md` + `docs/adr/` na raiz do repo. Isso serve para quase todo repo; escreva sem perguntar.

Ofereça **multi-context** — um `CONTEXT-MAP.md` na raiz apontando para arquivos `CONTEXT.md` por contexto — só quando a exploração achou sinais de monorepo. Aí confirme qual layout ele quer.

### 3. Confirme e edite

Mostre ao usuário um rascunho de:

- O bloco `## Agent skills` para adicionar a qualquer um entre `CLAUDE.md` / `AGENTS.md` que estiver sendo editado (veja step 4 para regras de seleção)
- O conteúdo de `docs/agents/issue-tracker.md`, `docs/agents/domain.md` e `docs/agents/triage-labels.md` (o último só quando `triage` está instalada)

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

[resumo de uma linha de onde issues são rastreadas]. Veja `docs/agents/issue-tracker.md`.

### Triage labels

[resumo de uma linha do vocabulário de labels]. Veja `docs/agents/triage-labels.md`.

### Domain docs

[resumo de uma linha do layout — "single-context" ou "multi-context"]. Veja `docs/agents/domain.md`.
```

Inclua o sub-bloco `### Triage labels`, e escreva `docs/agents/triage-labels.md`, só quando `triage` está instalada e a Seção B rodou. Quando não está, ambos são omitidos.

Depois escreva os docs files usando os templates seed nesta pasta de skill como ponto de partida:

- [issue-tracker-github.md](./issue-tracker-github.md) — issue tracker GitHub
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md) — issue tracker GitLab
- [issue-tracker-local.md](./issue-tracker-local.md) — issue tracker markdown local
- [triage-labels.md](./triage-labels.md) — mapeamento de labels (só se `triage` está instalada)
- [domain.md](./domain.md) — regras de consumidor de docs de domínio + layout

Para issue trackers "other", escreva `docs/agents/issue-tracker.md` do zero usando a descrição do usuário.

### 5. Done

Diga ao usuário que o setup está completo e quais engineering skills agora vão ler desses arquivos. Mencione que ele pode editar `docs/agents/*.md` direto depois — re-rodar esta skill só é necessário se ele quiser trocar de issue tracker ou recomeçar do zero.
