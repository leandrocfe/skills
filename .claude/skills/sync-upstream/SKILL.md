---
name: sync-upstream
description: Sincroniza este repositório com um novo release do upstream (mattpocock/skills), adaptando as mudanças para pt-BR em vez de copiá-las. Use quando sair um release novo no upstream ou quando uma issue de "Sync upstream" for aberta pelo workflow check-upstream.
disable-model-invocation: true
---

# Sync com o upstream

Este repositório é uma adaptação em português do Brasil de [mattpocock/skills](https://github.com/mattpocock/skills). O objetivo **não é tradução literal**: cada skill mantém o propósito, comportamento, fluxo e intenção da original, com linguagem, exemplos e contexto adequados ao público brasileiro.

O upstream é versionado com releases semver e mantém um `CHANGELOG.md` explicando cada mudança. A sincronização é feita **release a release**, nunca por acompanhamento contínuo de branch.

## Fonte da verdade

`UPSTREAM.md`, na raiz deste repo:

- `upstream-version:` — última tag do upstream totalmente sincronizada;
- mapeamento de renames intencionais (identidade deste projeto);
- skills exclusivas deste repo (**nunca remover** — não têm correspondente no upstream);
- pendências conhecidas.

O remote `upstream` aponta para o repo do Matt. Se não existir: `git remote add upstream https://github.com/mattpocock/skills.git`.

## Processo

### 1. Descobrir o delta

```bash
git fetch upstream --tags
```

- `BASE` = valor de `upstream-version:` em `UPSTREAM.md`.
- `ALVO` = tag mais recente do upstream.
- `BASE == ALVO` → nada a fazer, encerre.

### 2. Entender as mudanças — CHANGELOG primeiro, diff depois

1. Leia as seções do `CHANGELOG.md` do upstream entre `BASE` e `ALVO` (`git show ALVO:CHANGELOG.md`). Ele explica o que mudou **e por quê** — use como esqueleto do relatório, não reconstrua do zero.
2. Gere o diff real, com detecção de renames:

   ```bash
   git diff -M BASE..ALVO -- skills/ docs/ .claude-plugin/plugin.json
   ```

3. Cruze o diff com o mapeamento de nomes do `UPSTREAM.md` (ex.: mudanças em `setup-matt-pocock-skills` aplicam-se a `setup-leandrocfe-skills`).

### 3. Relatório e proposta — antes de tocar em qualquer arquivo

Apresente ao mantenedor:

- mudanças agrupadas por categoria (novas skills, renames, alterações, remoções);
- para cada uma: o que mudou, por que importa (cite o CHANGELOG) e o impacto nesta versão;
- proposta de adaptação, respeitando as regras abaixo;
- pontos que exigem decisão humana, destacados explicitamente.

**Pare aqui e aguarde aprovação.** Havendo ambiguidade, conflito entre versões ou mais de uma adaptação válida, pergunte antes de continuar.

### 4. Aplicar — somente após aprovação

- Adapte skill por skill; nunca copie e cole.
- Espelhe renames do upstream com `git mv`, exceto os listados no mapeamento do `UPSTREAM.md`.
- Atualize `.claude-plugin/plugin.json`: a lista de skills deve bater com os diretórios reais e o campo `version` deve espelhar a tag sincronizada.
- Valide ao final: cada entrada do plugin.json existe em `skills/`; cada skill promovida tem entrada; READMEs de bucket e top-level atualizados conforme o `CLAUDE.md`.

### 5. Fechar o sync

1. Atualize `upstream-version:` no `UPSTREAM.md` para `ALVO` e limpe pendências resolvidas.
2. Commit: `sync: upstream ALVO`.
3. Tag espelhando o upstream: `git tag ALVO && git push origin ALVO`.
4. Feche a issue de sync aberta pelo workflow, se houver.
5. Opcional: traduza a seção do CHANGELOG do release e publique como release notes deste repo.

## Regras de adaptação

- **Nunca copie automaticamente** conteúdo do upstream.
- Preserve a identidade deste projeto (nomes mapeados em `UPSTREAM.md`).
- Escreva em português do Brasil; mantenha termos técnicos consagrados em inglês.
- Priorize comportamento e intenção da skill, não a mesma redação.
- Exemplos muito específicos da realidade do Matt → proponha equivalentes do contexto brasileiro quando fizer sentido.
- Preserve personalizações existentes deste repo, exceto quando conflitarem com melhorias importantes do upstream — nesse caso, aponte o conflito no relatório do passo 3.
- **Nunca remova** as skills exclusivas listadas em `UPSTREAM.md`.

Prefira uma atualização cuidadosa e bem justificada a uma sincronização automática. Explique o motivo de cada sugestão antes de aplicá-la.
