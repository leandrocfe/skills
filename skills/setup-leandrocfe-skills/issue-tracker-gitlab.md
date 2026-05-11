# Rastreador de Issues: GitLab

Issues e PRDs deste repo vivem como GitLab issues. Use o CLI [`glab`](https://gitlab.com/gitlab-org/cli) pra todas operações.

## Convenções

- **Criar issue:** `glab issue create --title "..." --description "..."`. Use heredoc pra descrições multi-linha. `--description -` abre editor.
- **Ler issue:** `glab issue view <number> --comments`. Use `-F json` pra saída legível por máquina.
- **Listar issues:** `glab issue list -F json` com filtros `--label` apropriados.
- **Comentar em issue:** `glab issue note <number> --message "..."`. GitLab chama comentários de "notes".
- **Aplicar / remover labels:** `glab issue update <number> --label "..."` / `--unlabel "..."`. Múltiplas labels com vírgula ou repetindo a flag.
- **Fechar:** `glab issue close <number>`. `glab issue close` não aceita comentário de fechamento — poste a explicação antes com `glab issue note <number> --message "..."`, depois feche.
- **Merge requests:** GitLab chama PRs de "merge requests". Use `glab mr create`, `glab mr view`, `glab mr note`, etc. — mesma forma de `gh pr ...` com `mr` no lugar de `pr` e `note`/`--message` no lugar de `comment`/`--body`.

Infere o repo de `git remote -v` — `glab` faz isso automaticamente quando rodado dentro de um clone.

## Quando uma skill diz "publicar no Rastreador"

Criar issue no GitLab.

## Quando uma skill diz "buscar o ticket relevante"

Rodar `glab issue view <number> --comments`.
