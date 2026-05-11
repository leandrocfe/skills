# Rastreador de Issues: GitHub

Issues e PRDs deste repo vivem como GitHub issues. Use o CLI `gh` pra todas operações.

## Convenções

- **Criar issue:** `gh issue create --title "..." --body "..."`. Use heredoc para corpos multi-linha.
- **Ler issue:** `gh issue view <number> --comments`, filtrando comentários com `jq` e também buscando labels.
- **Listar issues:** `gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'` com filtros `--label` e `--state` apropriados.
- **Comentar em issue:** `gh issue comment <number> --body "..."`
- **Aplicar / remover labels:** `gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **Fechar:** `gh issue close <number> --comment "..."`

Infere o repo de `git remote -v` — `gh` faz isso automaticamente quando rodado dentro de um clone.

## Quando uma skill diz "publicar no Rastreador"

Criar issue no GitHub.

## Quando uma skill diz "buscar o ticket relevante"

Rodar `gh issue view <number> --comments`.
