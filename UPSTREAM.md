# Estado de sincronização com o upstream

upstream-version: v1.0.1

> A linha `upstream-version:` acima é lida por automação (GitHub Action).
> Atualize-a **somente** ao concluir um sync completo, e mantenha o formato exato.

- **Upstream**: https://github.com/mattpocock/skills (remote `upstream`)
- **Baseline atual**: `v1.0.1` — último sync completo em 2026-06-25 (PR #3, `sync-matt-pocock-v1`)
- **Como sincronizar**: ver `notes.md` na raiz da pasta de trabalho (processo tag-a-tag)

## Mapeamento de nomes (upstream → este repo)

Skills renomeadas de propósito para preservar a identidade do projeto:

| Upstream | Este repo | Motivo |
|---|---|---|
| `engineering/setup-matt-pocock-skills` | `engineering/setup-leandrocfe-skills` | Identidade do plugin |
| `engineering/ask-matt` | `engineering/ask-matt` | Mantido (nome é a marca do fluxo) |

Todos os demais diretórios usam o **mesmo nome do upstream**. Renames feitos pelo
Matt (ex.: `to-prd`→`to-spec`) devem ser espelhados aqui no próximo sync, exceto
se listados acima.

## Skills exclusivas deste repo (não existem no upstream)

Nunca remover em sync — não têm correspondente para comparar:

- `personal/dev-pipeline`
- `in-progress/decision-mapping`

## Pendências conhecidas (delta v1.0.1 → v1.1.0+, ainda não sincronizado)

- Renames upstream não aplicados: `to-prd`→`to-spec`; `to-issues`+`to-plan`→`to-tickets`
- Skills novas no upstream: `engineering/code-review` (promovida de `in-progress/review` — este repo ainda tem `in-progress/review` antiga), `engineering/research`, `engineering/wayfinder`
- `in-progress` upstream novos: `claude-handoff`, `setup-ts-deep-modules`, `wizard`
- `.claude-plugin/plugin.json` deste repo está **desatualizado**: lista `diagnose`,
  `zoom-out`, `write-a-skill`, `caveman` e `to-issues`/`to-prd`, que não batem com
  os diretórios reais em `skills/`. Corrigir no próximo sync e passar a validar
  plugin.json × diretórios a cada sync.
- Este repo não tem campo `version` no plugin.json — adotar a versão upstream
  espelhada (ex.: `1.1.0`) a partir do próximo sync.
