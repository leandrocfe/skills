# Rastreador de Issues: Markdown Local

Issues e PRDs deste repo vivem como arquivos markdown em `.scratch/`.

## Convenções

- Uma feature por diretório: `.scratch/<feature-slug>/`
- O PRD é `.scratch/<feature-slug>/PRD.md`
- Issues de implementação são `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numeradas a partir de `01`
- Estado de triagem é registrado como linha `Status:` perto do topo de cada arquivo de issue (ver `triage-labels.md` pras strings de papéis)
- Comentários e histórico de conversa anexam ao fim do arquivo sob cabeçalho `## Comentários`

## Quando uma skill diz "publicar no Rastreador"

Criar arquivo novo em `.scratch/<feature-slug>/` (criando o diretório se necessário).

## Quando uma skill diz "buscar o ticket relevante"

Ler o arquivo no path referenciado. Usuário normalmente passa o path ou número da issue direto.
