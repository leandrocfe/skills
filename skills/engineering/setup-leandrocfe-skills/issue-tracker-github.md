# Issue tracker: GitHub

Issues e PRDs deste repo vivem como GitHub issues. Use a CLI `gh` para todas as operações.

## Convenções

- **Criar uma issue**: `gh issue create --title "..." --body "..."`. Use heredoc para bodies multi-linha.
- **Ler uma issue**: `gh issue view <number> --comments`, filtrando comments com `jq` e também buscando labels.
- **Listar issues**: `gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'` com filtros `--label` e `--state` apropriados.
- **Comentar numa issue**: `gh issue comment <number> --body "..."`
- **Aplicar / remover labels**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **Fechar**: `gh issue close <number> --comment "..."`

Infira o repo a partir de `git remote -v` — `gh` faz isso automaticamente quando rodado dentro de um clone.

## Quando uma skill diz "publicar no issue tracker"

Crie uma GitHub issue.

## Quando uma skill diz "buscar o ticket relevante"

Rode `gh issue view <number> --comments`.
