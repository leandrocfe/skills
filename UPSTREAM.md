# Estado de sincronização com o upstream

upstream-version: v1.1.0

> A linha `upstream-version:` acima é lida por automação (GitHub Action).
> Atualize-a **somente** ao concluir um sync completo, e mantenha o formato exato.

- **Upstream**: https://github.com/mattpocock/skills (remote `upstream`)
- **Baseline atual**: `v1.1.0` — último sync completo em 2026-07-14
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

> Correção (v1.1.0): `in-progress/decision-mapping` estava listada aqui por engano.
> Ela **vinha do upstream** e foi renomeada para `engineering/wayfinder` na v1.1.0.
> `personal/edit-article` e `personal/obsidian-vault` também existem no upstream —
> não são exclusivas. Antes de marcar algo como exclusivo, confirme com
> `git ls-tree <tag> skills/`.

## Divergências deliberadas do upstream

Decisões permanentes deste projeto — não reabrir a cada sync:

- **Sem `docs/`.** O upstream mantém ~20 páginas em `docs/engineering/` e
  `docs/productivity/`. Aqui, a superfície de documentação é o `README.md`
  top-level mais os READMEs de bucket. Mudanças em `docs/` no upstream são
  ignoradas; o conteúdo relevante é absorvido nos READMEs.
- **`implement` e `resolving-merge-conflicts` listadas nos READMEs.** O upstream
  as omite dos READMEs (aparente descuido). Aqui elas são listadas, porque o
  `CLAUDE.md` exige que toda skill de `engineering/` tenha entrada no README
  top-level.

## Pendências conhecidas

- **`resolving-merge-conflicts` não está no `plugin.json`** — o upstream também a
  omite do plugin dele (aparente descuido: a skill existe desde a v1.0.0 mas nunca
  foi listada). Mantida a paridade. Se quiser distribuí-la, adicione a entrada aqui
  e registre como divergência deliberada.

- **`writing-great-skills` (SKILL.md)**: a adaptação pt-BR original havia perdido
  as seções "Leading words" e "Failure modes", presentes no upstream desde a
  v1.0.1. Restauradas no sync da v1.1.0 — vale reler contra o upstream se surgir
  divergência de comportamento.
- **`in-progress/loop-me`**: nunca traduzida; idêntica ao upstream. Bucket
  `in-progress`, baixa prioridade.
- **Guard do plugin `academic-research-skills`**: o hook "ARS scope guard" bloqueia
  agents de escrever `.claude-plugin/plugin.json` neste repo (falso positivo — ele
  protege o manifest do ARS, não o nosso). Edições no `plugin.json` precisam ser
  feitas manualmente pelo mantenedor.
