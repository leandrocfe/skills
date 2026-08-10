# Estado de sincronização com o upstream

upstream-version: v1.2.3

> A linha `upstream-version:` acima é lida por automação (GitHub Action).
> Atualize-a **somente** ao concluir um sync completo, e mantenha o formato exato.

- **Upstream**: https://github.com/mattpocock/skills (remote `upstream`)
- **Baseline atual**: `v1.2.3` — último sync completo em 2026-08-10
- **Como sincronizar**: skill de projeto `/sync-upstream` (`.claude/skills/sync-upstream/`), processo tag-a-tag

## Mapeamento de nomes (upstream → este repo)

Skills renomeadas de propósito para preservar a identidade do projeto:

| Upstream | Este repo | Motivo |
|---|---|---|
| `engineering/setup-matt-pocock-skills` | `engineering/setup-leandrocfe-skills` | Identidade do plugin |
| `engineering/ask-matt` | `engineering/ask-matt` | Mantido (nome é a marca do fluxo) |

Todos os demais diretórios usam o **mesmo nome do upstream**. Renames feitos pelo
Matt devem ser espelhados aqui a cada sync, exceto se listados acima.

Renames já espelhados: `to-prd`→`to-spec`, `to-issues`→`to-tickets` (v1.1.0),
`in-progress/review`→`engineering/code-review` (v1.1.0),
`in-progress/decision-mapping`→`engineering/wayfinder` (v1.1.0).

## Skills exclusivas deste repo (não existem no upstream)

Nunca remover em sync — não têm correspondente para comparar:

- `personal/dev-pipeline`
- `personal/bro` — adaptação pt-BR de [dmmulroy/skills](https://github.com/dmmulroy/skills/blob/main/bro/SKILL.md), não do upstream do Matt

> Nota (v1.2.0): `personal/edit-article` e `personal/obsidian-vault` **foram
> removidas do upstream** na v1.2.0 (o Matt deletou o bucket `personal/` dele) e
> foram espelhadas aqui — nunca foram exclusivas. Antes de marcar algo como
> exclusivo, confirme com `git ls-tree <tag> skills/`.

## Divergências deliberadas do upstream

Decisões permanentes deste projeto — não reabrir a cada sync:

- **Sem `docs/`.** O upstream mantém ~20 páginas em `docs/engineering/` e
  `docs/productivity/`. Aqui, a superfície de documentação é o `README.md`
  top-level mais os READMEs de bucket. Mudanças em `docs/` no upstream são
  ignoradas; o conteúdo relevante é absorvido nos READMEs.
- **`implement` listada nos READMEs.** O upstream a omitia dos READMEs até a
  v1.2.0 (quando passou a listá-la); aqui já era listada, porque o `CLAUDE.md`
  exige que toda skill de `engineering/` tenha entrada no README top-level.
- **`writing-for-agents` model-invoked (paridade a partir da v1.2.2).** Na v1.2.0
  o upstream era inconsistente (frontmatter model-invoked, mas `openai.yaml` com
  `allow_implicit_invocation: false` e READMEs em User-invoked); antecipamos a
  correção para model-invoked. O upstream **alcançou isso na v1.2.2** (#766):
  dropou o bloco `policy`, corrigiu o `display_name`/`short_description` stale e
  moveu para Model-invoked nos READMEs. Não é mais divergência — está alinhado.
- **`.agents/` parcial.** Do upstream v1.2.0 importamos apenas
  `.agents/invocation.md` (adaptado). Os ADRs meta do Matt (`0001`, `0002`),
  `install-block.md` e `writing-docs.md` são específicos do repo dele e ficam de
  fora — mesma lógica da divergência de `docs/`.
- **Seção de instalação do README não reformulada.** O upstream v1.2.0 trocou o
  "Quickstart" por uma seção "Installation" com plugin de marketplace vs
  skills.sh, referências ao marketplace `mattpocock-skills` e ao ADR `0002`. Aqui
  a seção de install permanece a adaptada (`npx skills@latest add leandrocfe/skills`).

## Codex / dual-harness

Desde a v1.2.0, as skills funcionam em Claude Code e Codex:

- Cada skill tem `agents/openai.yaml` (metadata de UI do Codex + `policy` para
  user-invoked). Gerar/atualizar junto com a `SKILL.md`.
- `AGENTS.md` é symlink para `CLAUDE.md`.
- Modelo de invocação: `.agents/invocation.md`.

## Pendências conhecidas

- **`CLAUDE.md` e `plugin.json` só editáveis à mão.** O hook "ARS scope guard"
  bloqueia agents de escreverem ambos neste repo (falso positivo — protege o
  manifest/instruções do ARS, não os nossos). Edições precisam ser feitas
  manualmente pelo mantenedor.
- **`in-progress/loop-me`**: nunca traduzida; idêntica ao upstream. Bucket
  `in-progress`, baixa prioridade.
