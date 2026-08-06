Skills organizadas em buckets dentro de `skills/`:

- `engineering/` — trabalho diário com código
- `productivity/` — ferramentas diárias de workflow não-código
- `misc/` — mantidas mas raramente usadas
- `personal/` — atreladas ao setup pessoal, não divulgadas
- `in-progress/` — rascunhos ainda não prontos
- `deprecated/` — não usadas mais

Toda skill em `engineering/`, `productivity/` ou `misc/` precisa ter uma referência no `README.md` top-level. Skills em `personal/`, `in-progress/` e `deprecated/` não devem aparecer no README top-level.

Cada entrada de skill no `README.md` top-level deve linkar o nome da skill para seu `SKILL.md`.

Cada bucket tem um `README.md` listando todas as skills do bucket com uma descrição de uma linha, com o nome linkado para o `SKILL.md`. Os READMEs dos buckets e o README top-level agrupam as entradas em **User-invoked** e **Model-invoked**.

Toda `SKILL.md` é ou user-invoked (`disable-model-invocation: true`, alcançável apenas pelo humano) ou model-invoked (alcançável por model ou usuário). Para as definições completas, convenções de description e por que uma user-invoked skill pode invocar model-invoked skills mas nunca outra user-invoked, veja `.agents/invocation.md`.

## Dual-harness (Claude Code + Codex)

Estas skills funcionam nos dois harnesses sem cópias geradas:

- Toda skill carrega um `agents/openai.yaml` ao lado da `SKILL.md` com a metadata de UI do Codex (`interface.display_name`, `interface.short_description`) e, para skills user-invoked, `policy.allow_implicit_invocation: false` — o análogo Codex de `disable-model-invocation: true`. Mantenha os dois em sincronia: uma skill é user-invoked em ambos ou em nenhum.
- `AGENTS.md` é um symlink para `CLAUDE.md`, para o Codex ler as mesmas instruções do repo.
- O modelo de invocação dual-harness está documentado em `.agents/invocation.md`.

## Sincronização com o upstream

Este repo é uma adaptação pt-BR de [mattpocock/skills](https://github.com/mattpocock/skills), sincronizada release a release:

- Estado e mapeamento de nomes: `UPSTREAM.md` (raiz).
- Processo completo: skill de projeto `/sync-upstream` (`.claude/skills/sync-upstream/`).
- Detecção automática de releases novos: workflow `.github/workflows/check-upstream.yml` (abre issue diariamente quando há release não sincronizado).

Nunca copie conteúdo do upstream automaticamente — toda mudança passa por adaptação e aprovação do mantenedor.
