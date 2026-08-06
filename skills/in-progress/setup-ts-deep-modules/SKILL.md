---
name: setup-ts-deep-modules
description: Wire dependency-cruiser into a TypeScript repo so each package is a deep module — implementation hidden in subfolders, reachable only through its entry-point files. User-invoked.
disable-model-invocation: true
---

# Setup TS Deep Modules

Faça de cada package deste repo um **módulo profundo** (deep module): muito comportamento atrás de uma interface pequena. A superfície pública de um package são seus **entry points** — os arquivos na raiz do package — e tudo nas subpastas fica escondido. Esta skill instala o [dependency-cruiser](https://github.com/sverweij/dependency-cruiser) e as regras que tornam os entry points o único caminho de entrada, depois prova que as regras mordem.

Para o vocabulário (deep module, interface, seam, profundidade), rode a skill `/codebase-design` — use a linguagem dela em todo o processo.

## O formato que isto impõe

```
src/packages/
  <name>/
    index.ts        ← um entry point (público). Importe este de fora.
    client.ts       ← outro entry point. Packages podem expor VÁRIOS.
    lib/            ← implementação: escondida de fora, livre pra importar entre si.
    tests/          ← testes co-localizados + fixtures (uma subpasta, então privada).
```

A superfície pública são os **arquivos de raiz** do package — não um `index.ts` designado. Por convenção a implementação vive em `lib/` e os testes em `tests/`, dando a todo package o mesmo formato de duas pastas. A regra em si é geral, porém: *qualquer coisa* em *qualquer* subpasta é privada, então você nunca estende a config pra adicionar uma pasta.

Quatro regras, todas `error`:

1. **Entry-point boundary** — código fora de um package (código da app ou outro package) só pode importar os entry points daquele package (seus arquivos de raiz), nunca nada em suas subpastas.
2. **Intra-package freedom** — os arquivos do próprio package se importam livremente.
3. **Tests through the entry points** — arquivos sob `<pkg>/tests/` podem importar os entry points de qualquer package e as fixtures do próprio `tests/`, mas nunca os internos de subpasta de nenhum package (nem os seus próprios). Testes de integração entre packages são ok; deep imports não.
4. **No cycles** — nenhum ciclo de dependência.

**Entry points, não um barrel.** Porque a superfície pública é *todo* arquivo de raiz, um package pode expor vários entry points pequenos (`index.ts`, `client.ts`, `server.ts`) em vez de afunilar tudo por um `index.ts` gigante. Barrel files que re-exportam uma subárvore inteira são desencorajados — mantenha os entry points pequenos e esconda a implementação em subpastas.

Layering (quais packages podem depender de quais) é uma preocupação *diferente* e fica como stub comentado na config, pra este repo preencher.

## Passos

### 1. Detectar o ambiente

- **Package manager** — `pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn, `bun.lockb` → bun, senão npm. Use-o em todo comando abaixo (`pnpm`/`yarn`/`npm run`/`bunx`).
- **Raiz dos packages** — se `src/` existe use `src/packages`, senão `packages`. Confirme a escolha com o usuário se o repo já tiver outra convenção óbvia.
- **Config existente** — cheque por um arquivo `.dependency-cruiser.*`. Se existir, **não** sobrescreva: mescle as quatro regras e as opções, e diga ao usuário o que você adicionou.

**Pronto quando:** package manager, raiz dos packages e status de config existente estiverem todos conhecidos.

### 2. Instalar o dependency-cruiser

Instale `dependency-cruiser` como devDependency com o package manager detectado.

**Pronto quando:** `dependency-cruiser` estiver em `devDependencies`.

### 3. Escrever a config

Copie [`dependency-cruiser.config.cjs`](./dependency-cruiser.config.cjs) para a raiz do repo como `.dependency-cruiser.cjs`. Ajuste `PACKAGES_ROOT` para a raiz detectada no passo 1. As regras são baseadas em profundidade de path e agnósticas de extensão, então nada mais precisa ser adaptado.

**Pronto quando:** `.dependency-cruiser.cjs` existir com o `PACKAGES_ROOT` correto, e as quatro regras `forbidden` estiverem presentes.

### 4. Ligar nos checks

- Adicione um script `lint:boundaries`: `depcruise <packages-root>` (ou `depcruise src`).
- Encaixe-o no comando guarda-chuva do repo — aquele que já roda typecheck (ex.: um script `check` / `ci` / `validate`). **Não** toque no `tsconfig` nem adicione path aliases.
- Se não houver script guarda-chuva, adicione `lint:boundaries` e diga ao usuário pra incluí-lo no CI.

**Pronto quando:** `lint:boundaries` existir e rodar como parte do mesmo comando que o typecheck.

### 5. Fazer o scaffold do package de exemplo

Crie um `<packages-root>/example/` commitado como template copie-me:

- `index.ts` — um entry point. Exporte uma função que delega para um arquivo interno (pra o package ser visivelmente *profundo*, não um pass-through).
- `lib/impl.ts` — um arquivo interno numa **subpasta**, importado por `index.ts`, inalcançável de fora.
- `tests/example.test.ts` — importa **só** `../index` (um entry point), e faz asserções contra a função pública.

Diga ao usuário que isto é um template inicial pra copiar ou deletar.

**Pronto quando:** o package de exemplo existir, expor seu comportamento por um entry point de raiz, e esconder `impl` numa subpasta.

### 6. Provar que as regras mordem

Este é o critério de conclusão da skill inteira — uma config que não falha numa violação não vale nada.

1. Rode `lint:boundaries`. Deve **passar** no exemplo limpo.
2. Adicione temporariamente um deep import a `tests/example.test.ts` (ex.: `import { thing } from "../lib/impl"`). Rode `lint:boundaries` de novo — deve **falhar** com `tests-through-entrypoints`.
3. Reverta o deep import. Rode mais uma vez — deve **passar**.

**Pronto quando:** você tiver observado um pass, depois um fail no deep import, depois um pass de novo. Se o passo 2 não falhar, as regras não estão ligadas corretamente — corrija antes de terminar.

### 7. Documentar a convenção

Escreva um `README.md` **na pasta dos packages** (`<packages-root>/README.md`) — ao lado dos packages que ele governa — cobrindo: o layout `src/packages/<name>/` (entry points na raiz, `lib/` pra implementação, `tests/` pra testes), "importe só pelos entry points de um package (seus arquivos de raiz)", e como rodar `lint:boundaries`. **Desencoraje barrel files** explicitamente — exponha vários entry points pequenos em vez de re-exportar uma subárvore inteira por um index. Mantenha no snippet copie-me mais as quatro regras em um parágrafo cada.

Depois adicione um **context pointer** a ele a partir do arquivo de instruções de agente do repo — `CLAUDE.md` se presente, senão `AGENTS.md` (crie `AGENTS.md` se nenhum existir). Uma linha basta, ex.: `Packages são deep modules — veja [src/packages/README.md](./src/packages/README.md) antes de adicionar ou importar um.` Isto é o que faz um agente descobrir a regra de boundary em vez de tropeçar nela.

**Pronto quando:** `<packages-root>/README.md` existir e desencorajar barrels, e o `CLAUDE.md`/`AGENTS.md` do repo linkar pra ele.

## Notes

- As back-references `$1` da config (group matching do dependency-cruiser) são o que deixa um package alcançar os próprios internos enquanto os de fora não podem — não achate isso em regras separadas por package.
- Público vs privado é decidido por **profundidade**: os arquivos de raiz de um package são entry points; qualquer coisa numa subpasta é privada. As subpastas convencionais são `lib/` (implementação) e `tests/`, mas a regra não as hardcoda — qualquer subpasta é privada, então uma pasta nova nunca precisa de mudança na config. Adicionar um entry point é só adicionar um arquivo de raiz — sem barrel.
- Packages são **flat**: um nível de filhos imediatos sob a raiz. Os internos de um package podem aninhar quão fundo você quiser; um package não pode conter outro package.
- Use `.cjs` (não `.js`) pra o `module.exports` da config funcionar mesmo em repos `"type": "module"`.
