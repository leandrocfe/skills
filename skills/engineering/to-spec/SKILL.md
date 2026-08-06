---
name: to-spec
description: Transforma a conversa atual em uma spec e publica no issue tracker do projeto — sem entrevista, só síntese do que você já discutiu.
disable-model-invocation: true
---

Esta skill pega o contexto atual da conversa e o entendimento da codebase e produz uma spec. NÃO entreviste o usuário — apenas sintetize o que já sabe.

O issue tracker e o vocabulário de triage labels devem ter sido fornecidos a você — rode `/setup-leandrocfe-skills` se não.

## Processo

1. Explore o repo para entender o estado atual da codebase, se ainda não fez isso. Use o vocabulário do glossário de domínio do projeto ao longo de toda a spec, e respeite quaisquer ADRs na área que você está tocando.

2. Esboce os seams nos quais você vai testar a feature. Seams existentes são preferíveis a novos. Use o seam mais alto possível. Se novos seams forem necessários, proponha-os no ponto mais alto que conseguir. Quanto menos seams espalhados pela codebase, melhor — o número ideal é um.

Confirme com o usuário que esses seams batem com o que ele espera.

3. Escreva a spec usando o template abaixo e publique no issue tracker do projeto. Aplique a triage label `ready-for-agent` — não é preciso triage adicional.

<spec-template>

## Problem Statement

O problema que o usuário enfrenta, da perspectiva dele.

## Solution

A solução para o problema, da perspectiva do usuário.

## User Stories

Uma lista numerada LONGA de user stories. Cada user story deve estar no formato:

1. Como <ator>, quero <feature>, para que <benefício>

<user-story-example>
1. Como cliente de banco mobile, quero ver o saldo das minhas contas, para que eu possa tomar decisões mais bem informadas sobre meus gastos
</user-story-example>

Esta lista de user stories deve ser extremamente extensa e cobrir todos os aspectos da feature.

## Implementation Decisions

Uma lista das decisões de implementação tomadas. Pode incluir:

- Os módulos que serão construídos/modificados
- As interfaces desses módulos que serão modificadas
- Esclarecimentos técnicos do desenvolvedor
- Decisões arquiteturais
- Mudanças de schema
- Contratos de API
- Interações específicas

NÃO inclua caminhos de arquivo específicos nem trechos de código. Eles podem ficar desatualizados muito rápido.

Exceção: se um prototype produziu um trecho que codifica uma decisão com mais precisão do que a prosa consegue (state machine, reducer, schema, formato de tipo), inclua-o dentro da decisão relevante e anote brevemente que veio de um prototype. Corte para as partes ricas em decisão — não é um demo funcional, só o que importa.

## Testing Decisions

Uma lista das decisões de teste tomadas. Inclua:

- Uma descrição do que faz um bom teste (teste apenas comportamento externo, não detalhes de implementação)
- Quais módulos serão testados
- Prior art para os testes (ou seja, tipos similares de teste já existentes na codebase)

## Out of Scope

Uma descrição do que está fora do escopo desta spec.

## Further Notes

Quaisquer notas adicionais sobre a feature.

</spec-template>
