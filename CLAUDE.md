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

Toda `SKILL.md` é ou user-invoked (`disable-model-invocation: true`, alcançável apenas pelo humano) ou model-invoked (alcançável por model ou usuário). Para as definições completas, convenções de description e por que uma user-invoked skill pode invocar model-invoked skills mas nunca outra user-invoked, veja a documentação de invocação no repositório original.

## Sincronização com o upstream

Este repo é uma adaptação pt-BR de [mattpocock/skills](https://github.com/mattpocock/skills), sincronizada release a release:

- Estado e mapeamento de nomes: `UPSTREAM.md` (raiz).
- Processo completo: skill de projeto `/sync-upstream` (`.claude/skills/sync-upstream/`).
- Detecção automática de releases novos: workflow `.github/workflows/check-upstream.yml` (abre issue diariamente quando há release não sincronizado).

Nunca copie conteúdo do upstream automaticamente — toda mudança passa por adaptação e aprovação do mantenedor.
