---
name: to-issues
description: Quebra plano, PRD ou spec em issues independentes, acionáveis e bem-dimensionadas, e submete ao Rastreador de Issues. Use quando usuário pedir "criar issues", "quebrar em tickets", "gerar issues do GitHub", "transformar PRD em backlog", ou invocar /to-issues. Triggers: "to issues", "break down", "tickets".
---

# to-issues

Pega um plano (PRD, ADR, documento de design) e quebra em issues que **uma pessoa consegue pegar e fechar** sem precisar adivinhar requisitos. Combate o anti-padrão de issue genérica ("implementar autenticação") que vira projeto de um mês.

## <o-que-fazer>

### Passo 1 — Receber a entrada

Confirme com o usuário **o que** será quebrado:

- URL/conteúdo de um PRD existente (preferencial)
- Texto da conversa atual
- Documento de design/spec

Se a entrada é vaga ou cobre muito, **pare e proponha** rodar [to-prd](../to-prd/SKILL.md) primeiro para consolidar.

### Passo 2 — Identificar fatias verticais

Releia a entrada procurando **unidades verticais** — cada uma com:

- Comportamento observável (ou diagnóstico observável, no caso de tarefa interna)
- Critério de aceitação claro
- Independência ou dependência **explícita** de outra issue

Cada fatia vertical = 1 issue.

Regra de tamanho:

- **Pequeno:** 1–4h de trabalho focado → 1 issue, tamanho S
- **Médio:** 1–2 dias → 1 issue, tamanho M
- **Grande:** > 2 dias → quebrar em mais
- **Enorme (> 1 semana):** indica que não é issue — é epic. Volte ao PRD.

### Passo 3 — Escrever cada issue com o template

```markdown
## Contexto

<1–3 linhas. Por que esta issue existe. Link pro PRD/ADR se houver.>

## Comportamento esperado

<O que precisa ser verdade ao fim. Observável.>

## Critérios de aceitação

- [ ] <Critério 1>
- [ ] <Critério 2>
- [ ] <Critério 3>

## Fora de escopo desta issue

<O que **não** está sendo entregue aqui. Lista pequena.>

## Dependências

- Bloqueada por: #NN (se aplicável)
- Bloqueia: #NN

## Notas técnicas

<Apontamentos relevantes: arquivos prováveis, padrão a seguir, links pra docs. Curto.>
```

### Passo 4 — Definir labels e tamanho

Labels mínimas:

- **Tipo:** `feature`, `bug`, `chore`, `débito-técnico`, `docs`
- **Tamanho:** `size/XS`, `size/S`, `size/M`, `size/L`
- **Domínio:** opcional, conforme convenção do projeto (ex: `auth`, `billing`)

Tamanho é estimativa, não promessa. Em dúvida, suba (M em vez de S).

### Passo 5 — Definir ordem

Identifique:

- **Issues independentes** — podem ser pegadas em paralelo
- **Issues bloqueadoras** — devem ser feitas primeiro; outras dependem
- **Ordem recomendada** — qual sequência minimiza retrabalho

Registre dependências explicitamente na seção "Dependências" de cada issue.

### Passo 6 — Validar com o usuário

Antes de criar nada no tracker, apresente:

- Lista das issues (título + tamanho)
- Diagrama curto de dependências (ordem + paralelizável)

Pergunte:

- Falta algum comportamento que merece issue própria?
- Algum item poderia entrar em escopo "fora desta issue" para reduzir?
- Tamanho parece compatível com a complexidade real?

Iterar até aprovação explícita.

### Passo 7 — Submeter ao Rastreador

Para GitHub Issues via `gh`:

```bash
# Issue por issue, em ordem
gh issue create \
  --title "<título>" \
  --body-file /tmp/issue-1.md \
  --label "feature,size/M" \
  --milestone "<milestone se houver>"
```

Após criar todas, **edite cada uma** para preencher os `#NN` das dependências (que só são conhecidos após criação).

Retorne para o usuário:

- Lista das URLs criadas
- Ordem recomendada

### Passo 8 — Próximo passo

Sugira (não execute sem permissão):

- Rodar [triage](../triage/SKILL.md) para classificar prioridade/tipo/owner
- Pegar a primeira issue da ordem e rodar [tdd](../tdd/SKILL.md)

## <info-de-apoio>

### Anti-padrões

- **NÃO escreva issue gigante.** "Implementar cancelamento de pedido" não é issue — é PRD. Quebrar.
- **NÃO escreva issue genérica.** "Melhorar performance" não é acionável. "Reduzir tempo de resposta de `GET /orders` de 800ms para <200ms p95" é.
- **NÃO crie issue sem critério de aceitação.** Ninguém sabe quando "está pronto".
- **NÃO esconda dependência.** Se issue B precisa da A, **escreva** isso em ambas.
- **NÃO crie 30 issues de 1 hora cada.** Granularidade demais vira overhead. Em dúvida, agrupe.
- **NÃO submeta sem validação humana.** Issues criadas no tracker são compromisso visível — sempre passa pelo usuário antes.

### Como detectar que uma issue é grande demais

Sinais:

- Você consegue listar 5+ critérios de aceitação distintos → provavelmente é 2–3 issues
- A descrição menciona "e também", "depois disso", "em seguida" → sequenciar = quebrar
- A issue toca 4+ camadas (UI + API + DB + jobs + cache) sem fio condutor → fatia horizontal disfarçada
- Estimativa > 2 dias com confiança baixa → quebrar antes de começar

### Como detectar que uma issue é pequena demais

Sinais:

- Critério de aceitação único e trivial (ex: "renomear variável")
- Não tem teste/verificação possível por si só
- Bloqueia muitas outras issues para um ganho mínimo

Solução: agrupar com issue irmã.

### Quando criar issue de "infra/setup"

Quando faz sentido:

- Existe trabalho real antes da primeira feature funcionar (ex: provisionar fila, criar tabela)
- O trabalho tem critério de aceitação observável (ex: "fila Redis acessível em ambiente de dev")

Quando NÃO:

- Trabalho é parte natural da primeira fatia vertical — não separa

### Exemplo: quebrando o PRD de cancelamento de pedido

Do PRD anterior, fatias verticais possíveis:

1. **Issue #101 — Endpoint `POST /orders/:id/cancel` aceita cancelamento dentro da janela** (M)
   - Critérios: 200 se status válido + <1h; 409 se fora; testes de borda
   - Bloqueia: 102, 103
2. **Issue #102 — UI: botão "Cancelar pedido" aparece quando elegível** (S)
   - Critérios: visível em status válidos + <1h; sumir após; estado de loading
   - Bloqueada por: 101
3. **Issue #103 — Estorno via gateway no momento do cancelamento** (M)
   - Critérios: chama gateway; retry assíncrono se falhar; status registrado
   - Bloqueada por: 101
4. **Issue #104 — Email de confirmação de cancelamento** (S)
   - Critérios: dispara após confirmação; template pt-BR; testado em sandbox
   - Bloqueada por: 101
5. **Issue #105 — Painel suporte: motivo do cancelamento visível** (S)
   - Critérios: lista de motivos no schema; admin vê filtro; export CSV
   - Bloqueada por: 101

Decisão em aberto do PRD (motivo lista vs livre) vira **comentário** na issue 105, não issue separada.

## Cross-references

- [to-prd](../to-prd/SKILL.md) — entrada típica antes de `to-issues`
- [triage](../triage/SKILL.md) — destino comum após criar as issues
- [tdd](../tdd/SKILL.md) — pegar 1 issue e começar com teste vermelho
- [`CONTEXT.md`](../../CONTEXT.md) — definição de Issue e Rastreador de Issues
