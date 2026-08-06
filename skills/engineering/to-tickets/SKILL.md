---
name: to-tickets
description: Quebra um plano, spec ou a conversa atual em um conjunto de tickets tracer-bullet, cada um declarando suas blocking edges, publicados no tracker configurado — edges como texto em um arquivo por ticket localmente, ou links de blocking nativos num tracker de verdade.
disable-model-invocation: true
---

# To Tickets

Quebre um plano, spec ou conversa em um conjunto de **tickets** — vertical slices no estilo tracer bullet, cada um declarando os tickets que o **bloqueiam**.

O issue tracker e o vocabulário de triage labels devem ter sido fornecidos a você — rode `/setup-leandrocfe-skills` se não.

## Processo

### 1. Reúna o contexto

Trabalhe com o que já está no contexto da conversa. Se o usuário passar uma referência como argumento (o caminho de uma spec, um número ou URL de issue), busque-a e leia o corpo completo e os comentários.

### 2. Explore a codebase (opcional)

Se ainda não explorou a codebase, explore para entender o estado atual do código. Títulos e descrições de ticket devem usar o vocabulário do glossário de domínio do projeto, e respeitar os ADRs na área que você está tocando.

Procure oportunidades de prefactor no código para facilitar a implementação. "Torne a mudança fácil, depois faça a mudança fácil."

### 3. Rascunhe as vertical slices

Quebre o trabalho em tickets **tracer bullet**.

<vertical-slice-rules>

- Cada slice corta um caminho estreito mas COMPLETO através de todas as camadas (schema, API, UI, testes) — vertical, NÃO um slice horizontal de uma única camada
- Uma slice concluída é demonstrável ou verificável por si só
- Cada slice é dimensionada para caber em uma única context window nova
- Qualquer prefactoring deve vir primeiro

</vertical-slice-rules>

Dê a cada ticket suas **blocking edges** — os outros tickets que precisam estar concluídos antes que ele possa começar. Um ticket sem blockers pode começar imediatamente.

**Wide refactors são a exceção ao vertical slicing.** Um **wide refactor** é uma única mudança mecânica — renomear uma coluna, retipar um símbolo compartilhado — cujo **blast radius** se espalha pela codebase inteira: uma edição só quebra milhares de call sites de uma vez e nenhuma vertical slice consegue ficar verde. Não force isso num tracer bullet; sequencie como **expand–contract**. Primeiro expand: adicione a forma nova ao lado da antiga, para que nada quebre. Depois migre os call sites em lotes dimensionados pelo blast radius (por pacote, por diretório), cada lote sendo seu próprio ticket bloqueado pelo expand, mantendo o CI verde lote a lote porque a forma antiga ainda existe. Por fim contract: apague a forma antiga quando não restar nenhum caller, num ticket bloqueado por todos os lotes de migração. Quando nem os lotes conseguem ficar verdes sozinhos, mantenha a sequência mas deixe que compartilhem uma integration branch, e que todos bloqueiem um ticket final de integrar-e-verificar — o verde só é prometido ali.

### 4. Sabatine o usuário

Apresente a quebra proposta como uma lista numerada. Para cada ticket, mostre:

- **Título**: nome curto e descritivo
- **Blocked by**: quais outros tickets (se houver) precisam terminar antes
- **O que entrega**: o comportamento ponta a ponta que este ticket faz funcionar

Pergunte ao usuário:

- A granularidade parece certa? (grossa demais / fina demais)
- As blocking edges estão corretas — cada ticket depende apenas de tickets que genuinamente o travam?
- Algum ticket deveria ser fundido ou quebrado ainda mais?

Itere até o usuário aprovar a quebra.

### 5. Publique os tickets no tracker configurado

Publique os tickets aprovados. **Como** depende do tracker que o `/setup-leandrocfe-skills` configurou — os tickets são os mesmos nos dois casos, só muda a forma das blocking edges:

- **Arquivos locais** → escreva um arquivo por ticket sob `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numerados a partir de `01` em ordem de dependência (blockers primeiro). O "Blocked by" de cada arquivo lista os números/títulos dos quais depende. Use o template de arquivo por ticket abaixo — um ticket por arquivo, nunca um único arquivo combinado.
- **Um issue tracker de verdade (GitHub, Linear, …)** → publique uma issue por ticket em ordem de dependência (blockers primeiro), para que as blocking edges de cada ticket possam referenciar identificadores reais. Use a relação nativa de blocking / sub-issue da plataforma onde ela existir; caso contrário, preencha o "Blocked by" de cada ticket com as issues bloqueadoras. Aplique a triage label `ready-for-agent` salvo instrução em contrário — os tickets são pegáveis por agent por construção.

Trabalhe a **frontier**: qualquer ticket cujos blockers estejam todos concluídos. Numa cadeia puramente linear, isso significa de cima para baixo.

NÃO feche nem modifique nenhuma issue pai.

<local-ticket-template>

# <NN> — <Título do ticket>

**What to build:** o comportamento ponta a ponta que este ticket faz funcionar, da perspectiva do usuário — não uma lista de implementação camada por camada.

**Blocked by:** os números/títulos dos tickets que travam este, ou "Nenhum — pode começar imediatamente".

**Status:** ready-for-agent

- [ ] Critério de aceite 1
- [ ] Critério de aceite 2

</local-ticket-template>

<issue-template>

## Parent

Uma referência à issue pai no tracker (se a origem foi uma issue existente; caso contrário, omita esta seção).

## What to build

O comportamento ponta a ponta que este ticket faz funcionar, da perspectiva do usuário — não implementação camada por camada.

## Acceptance criteria

- [ ] Critério 1
- [ ] Critério 2

## Blocked by

- Uma referência a cada ticket bloqueador, ou "Nenhum — pode começar imediatamente".

</issue-template>

Em qualquer das formas, evite caminhos de arquivo específicos ou trechos de código — eles ficam obsoletos rápido. Exceção: se um prototype produziu um trecho que codifica uma decisão com mais precisão do que a prosa consegue (state machine, reducer, schema, formato de tipo), inclua-o e anote brevemente que veio de um prototype. Corte para as partes ricas em decisão — não é um demo funcional, só o que importa.
