Skills organizadas em buckets dentro de `skills/`:

- `engineering/` — trabalho diário com código
- `productivity/` — ferramentas diárias de workflow não-código
- `misc/` — mantidas mas raramente usadas
- `personal/` — atreladas ao meu setup, não divulgadas
- `in-progress/` — rascunhos ainda não prontos
- `deprecated/` — não usadas mais

Toda skill em `engineering/`, `productivity/` ou `misc/` precisa ter uma referência no `README.md` top-level e uma entrada em `.claude-plugin/plugin.json`. Skills em `personal/`, `in-progress/` e `deprecated/` não devem aparecer em nenhum dos dois.

Cada entrada de skill no `README.md` top-level deve linkar o nome da skill para seu `SKILL.md`.

Cada bucket tem um `README.md` listando todas as skills do bucket com uma descrição de uma linha, com o nome linkado para o `SKILL.md`.
