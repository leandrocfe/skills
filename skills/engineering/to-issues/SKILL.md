---
name: to-issues
description: Quebra um plano, spec ou PRD em issues independentes no issue tracker do projeto usando vertical slices estilo tracer bullet. Use quando o usuário quiser converter um plano em issues, criar tickets de implementação ou quebrar trabalho em issues. Use when user wants to convert a plan into issues, create implementation tickets, or break down work into issues.
---

# To Issues

Quebre um plano em issues independentes usando vertical slices (tracer bullets).

O issue tracker e o vocabulário de triage labels já deveriam ter sido fornecidos a você — rode `/setup-leandrocfe-skills` se não.

## Processo

### 1. Junte contexto

Trabalhe com o que já está no contexto da conversa. Se o usuário passar uma referência de issue (número, URL ou caminho) como argumento, busque no issue tracker e leia o corpo completo e comments.

### 2. Explore a codebase (opcional)

Se ainda não explorou a codebase, faça isso para entender o estado atual do código. Títulos e descrições de issues devem usar o vocabulário do glossário de domínio do projeto e respeitar ADRs na área que você está tocando.

### 3. Rascunhe vertical slices

Quebre o plano em issues **tracer bullet**. Cada issue é uma vertical slice fina que corta TODAS as camadas de integração de ponta a ponta, NÃO uma horizontal slice de uma camada.

Slices podem ser 'HITL' ou 'AFK'. HITL slices precisam de interação humana, como decisão arquitetural ou design review. AFK slices podem ser implementadas e mergeadas sem interação humana. Prefira AFK sobre HITL onde possível.

<vertical-slice-rules>
- Cada slice entrega um caminho estreito mas COMPLETO por cada camada (schema, API, UI, tests)
- Uma slice completa é demoável ou verificável sozinha
- Prefira muitas slices finas sobre poucas grossas
</vertical-slice-rules>

### 4. Sabatine o usuário

Apresente a quebra proposta como lista numerada. Para cada slice, mostre:

- **Title**: nome descritivo curto
- **Type**: HITL / AFK
- **Blocked by**: quais outras slices (se houver) precisam terminar primeiro
- **User stories cobertas**: quais user stories isso endereça (se o material fonte tem)

Pergunte ao usuário:

- A granularidade parece certa? (grossa demais / fina demais)
- As relações de dependência estão corretas?
- Alguma slice deveria ser mergeada ou quebrada mais?
- As slices certas estão marcadas como HITL e AFK?

Itere até o usuário aprovar a quebra.

### 5. Publique as issues no issue tracker

Para cada slice aprovada, publique uma nova issue no issue tracker. Use o template de corpo de issue abaixo. Estas issues são consideradas prontas para agentes AFK, então publique com a triage label correta a menos que instruído de outra forma.

Publique issues em ordem de dependência (blockers primeiro) para poder referenciar identificadores de issue reais no campo "Blocked by".

<issue-template>
## Parent

Uma referência à issue parent no issue tracker (se a fonte foi uma issue existente, senão omita esta seção).

## What to build

Uma descrição concisa desta vertical slice. Descreva o comportamento end-to-end, não implementação camada-a-camada.

Evite paths de arquivo específicos ou code snippets — ficam stale rápido. Exceção: se um protótipo produziu um snippet que codifica uma decisão mais precisamente que prosa (state machine, reducer, schema, type shape), inline aqui e note brevemente que veio de protótipo. Apare para as partes ricas em decisão — não um demo funcional, só os pedaços importantes.

## Acceptance criteria

- [ ] Critério 1
- [ ] Critério 2
- [ ] Critério 3

## Blocked by

- Uma referência ao ticket bloqueador (se houver)

Ou "Nenhum — pode começar imediatamente" se sem blockers.

</issue-template>

NÃO feche nem modifique nenhuma issue parent.
