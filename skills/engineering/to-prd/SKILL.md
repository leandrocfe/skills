---
name: to-prd
description: "Transforma o contexto da conversa atual em um PRD e publica no issue tracker do projeto. Use quando o usuário quiser criar um PRD a partir do contexto atual. Use when user wants to create a PRD from the current context."
---

Esta skill pega o contexto da conversa atual e o entendimento da codebase e produz um PRD. NÃO entreviste o usuário — só sintetize o que você já sabe.

O issue tracker e o vocabulário de triage labels já deveriam ter sido fornecidos a você — rode `/setup-leandrocfe-skills` se não.

## Processo

1. Explore o repo para entender o estado atual da codebase, se ainda não fez. Use o vocabulário do glossário de domínio do projeto ao longo do PRD, e respeite quaisquer ADRs na área que está tocando.

2. Esboce os módulos principais que você vai precisar construir ou modificar para completar a implementação. Busque ativamente oportunidades de extrair deep modules que possam ser testados em isolamento.

Um deep module (em oposição a um shallow module) é um que encapsula muita funcionalidade numa interface simples e testável que muda raramente.

Confira com o usuário se esses módulos batem com as expectativas. Confira com o usuário para quais módulos ele quer testes escritos.

3. Escreva o PRD usando o template abaixo, depois publique no issue tracker do projeto. Aplique a triage label `ready-for-agent` — sem necessidade de triagem adicional.

<prd-template>

## Problem Statement

O problema que o usuário está enfrentando, da perspectiva do usuário.

## Solution

A solução para o problema, da perspectiva do usuário.

## User Stories

Uma lista LONGA e numerada de user stories. Cada user story no formato:

1. Como um <ator>, eu quero um <feature>, para que <benefício>

<user-story-example>
1. Como cliente de mobile banking, eu quero ver o saldo nas minhas contas, para que eu possa tomar decisões mais bem informadas sobre meus gastos
</user-story-example>

Esta lista de user stories deve ser extremamente extensa e cobrir todos os aspectos do feature.

## Implementation Decisions

Uma lista de decisões de implementação tomadas. Pode incluir:

- Os módulos que serão construídos/modificados
- As interfaces desses módulos que serão modificadas
- Esclarecimentos técnicos do dev
- Decisões arquiteturais
- Schema changes
- API contracts
- Interações específicas

NÃO inclua paths de arquivo específicos nem code snippets. Podem ficar desatualizados rapidamente.

Exceção: se um protótipo produziu um snippet que codifica uma decisão mais precisamente que prosa (state machine, reducer, schema, type shape), inline dentro da decisão relevante e note brevemente que veio de protótipo. Apare para as partes ricas em decisão — não um demo funcional, só os pedaços importantes.

## Testing Decisions

Uma lista de decisões de teste tomadas. Inclua:

- Uma descrição do que faz um bom teste (só testar comportamento externo, não detalhes de implementação)
- Quais módulos serão testados
- Prior art para os testes (i.e. tipos similares de testes na codebase)

## Out of Scope

Uma descrição das coisas que estão fora de escopo deste PRD.

## Further Notes

Quaisquer notas adicionais sobre o feature.

</prd-template>
