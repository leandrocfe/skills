# Issue tracker: Markdown Local

Issues e PRDs deste repo vivem como arquivos markdown em `.scratch/`.

## Convenções

- Uma feature por diretório: `.scratch/<feature-slug>/`
- O PRD é `.scratch/<feature-slug>/PRD.md`
- Issues de implementação são `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numerados a partir de `01`
- Estado de triagem é registrado como linha `Status:` perto do topo de cada arquivo de issue (veja `triage-labels.md` para as strings de role)
- Comments e histórico de conversa anexam ao fim do arquivo sob um heading `## Comments`

## Quando uma skill diz "publicar no issue tracker"

Crie um arquivo novo sob `.scratch/<feature-slug>/` (criando o diretório se necessário).

## Quando uma skill diz "buscar o ticket relevante"

Leia o arquivo no path referenciado. O usuário normalmente passa o path ou o número da issue diretamente.
