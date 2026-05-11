---
name: triage
description: Move issues do Rastreador por uma máquina de estados de papéis de triagem — `precisa-de-triagem`, `precisa-de-info`, `pronta-pra-agente`, `pronta-pra-humano`, `wontfix` — separando bugs de features e gerando agent briefs durável quando a issue está pronta para um agente AFK pegar. Use quando usuário pedir "triar issues", "fazer triagem", "classificar bug", "preparar issue pra agente", "achar issues prontas", ou invocar /triage. Triggers: "triage", "classify", "ready for agent", "AFK", "agent brief".
---

# triage

Move issues do Rastreador por uma **máquina de estados pequena de papéis de triagem**. Combate dois anti-padrões em paralelo:

1. Issue parada porque ninguém sabe se é urgente, quem pega, ou nem entendeu
2. Agente AFK (autônomo, sem humano disponível) pega issue mal-especificada e produz lixo

Triagem deste plugin **não é** priorização por número (P0/P1/P2). É classificação por **papel** + decisão de se a issue está **pronta pra ser pega por um agente** sem precisar de mais contexto humano.

## <o-que-fazer>

Todo comentário ou issue postado **pelo agente** durante triagem **deve** começar com:

```
> *Gerado por IA durante triagem.*
```

### Papéis

Dois papéis de **categoria** (escolher exatamente 1):

- `bug` — algo está quebrado
- `enhancement` — feature nova ou melhoria

Cinco papéis de **estado** (escolher exatamente 1):

- `precisa-de-triagem` — mantenedor precisa avaliar
- `precisa-de-info` — esperando reporter dar mais informação
- `pronta-pra-agente` — totalmente especificada, AFK-ready (agente pega sem contexto humano)
- `pronta-pra-humano` — precisa de humano (decisão arquitetural, acesso externo, julgamento)
- `wontfix` — não vai ser feita

Toda issue triada carrega **1 categoria + 1 estado**. Se estados conflitam, sinalize e pergunte ao mantenedor antes de qualquer coisa.

Nomes acima são **canônicos**. Strings reais no Rastreador podem diferir — o mapeamento deve ter sido provido por [setup-leandrocfe-skills](../setup-leandrocfe-skills/SKILL.md). Se não, rode antes.

### Transições

```
sem-label  →  precisa-de-triagem  →  precisa-de-info ↔ precisa-de-triagem
                                  →  pronta-pra-agente
                                  →  pronta-pra-humano
                                  →  wontfix
```

`precisa-de-info` volta pra `precisa-de-triagem` quando reporter responde. Mantenedor pode sobrescrever qualquer transição — sinalize transições estranhas antes de prosseguir.

### Invocação

Mantenedor invoca `/triage` e descreve o que quer em linguagem natural. Interprete e aja. Exemplos:

- "Mostra o que precisa da minha atenção"
- "Vamos olhar a #42"
- "Move #42 pra pronta-pra-agente"
- "O que tá pronto pra agente pegar?"

### Mostrar o que precisa de atenção

Consulta o Rastreador, apresenta 3 baldes, mais antigos primeiro:

1. **Sem label** — nunca triadas
2. **`precisa-de-triagem`** — avaliação em curso
3. **`precisa-de-info` com atividade do reporter desde o último comentário de triagem** — precisa de reavaliação

Mostre contagem e resumo de 1 linha por issue. Mantenedor escolhe.

### Triar issue específica

1. **Coletar contexto.** Ler corpo completo da issue (body, comentários, labels, reporter, datas). Parse notas de triagem prévias pra não re-perguntar coisa resolvida. Explorar codebase usando o vocabulário de `CONTEXT.md`, respeitando ADRs. Ler `.out-of-scope/*.md` e sinalizar qualquer rejeição prévia que pareça com esta issue.

2. **Recomendar.** Diga ao mantenedor sua recomendação de categoria + estado com justificativa, mais resumo curto de codebase relevante. **Aguarde direção.**

3. **Reproduzir (só bugs).** Antes de qualquer grill, tente reproduzir: leia os passos do reporter, trace o código relevante, rode testes/comandos. Reporte o que aconteceu — reprodução bem-sucedida com caminho de código, reprodução falha, ou detalhe insuficiente (sinal forte de `precisa-de-info`). Reprodução confirmada faz agent brief muito mais forte.

4. **Grelhar (se preciso).** Se a issue precisa de mais carne, rode [grill-with-docs](../grill-with-docs/SKILL.md).

5. **Aplicar o resultado:**
   - `pronta-pra-agente` → postar **agent brief** ([AGENT-BRIEF.md](AGENT-BRIEF.md))
   - `pronta-pra-humano` → mesma estrutura, mas notar **por que não dá pra delegar** (julgamento, acesso externo, decisão de design, teste manual)
   - `precisa-de-info` → postar notas de triagem (template abaixo)
   - `wontfix` (bug) → explicação cordial, fechar
   - `wontfix` (enhancement) → escrever em `.out-of-scope/`, linkar do comentário, fechar ([OUT-OF-SCOPE.md](OUT-OF-SCOPE.md))
   - `precisa-de-triagem` → aplicar papel. Comentário opcional se houver progresso parcial.

### Override rápido de estado

Se mantenedor diz "move #42 pra pronta-pra-agente", confie e aplique direto. Confirme o que vai fazer (mudanças de papel, comentário, fechamento), aja. Pule grill. Se mover pra `pronta-pra-agente` sem ter grelhado, pergunte se quer escrever agent brief.

### Template — Notas de Triagem (precisa-de-info)

```markdown
> *Gerado por IA durante triagem.*

## Notas de Triagem

**O que já foi estabelecido:**

- ponto 1
- ponto 2

**O que ainda precisamos de você (@reporter):**

- pergunta específica 1
- pergunta específica 2
```

Capture tudo o que foi resolvido durante grill em "já foi estabelecido" — não perca o trabalho. Perguntas têm que ser **específicas e acionáveis**, não "manda mais info".

### Retomando sessão prévia

Se notas de triagem prévias existem na issue, leia-as, cheque se reporter respondeu alguma pergunta pendente, e apresente quadro atualizado antes de continuar. **Não re-pergunte coisa resolvida.**

## <info-de-apoio>

### Anti-padrões

- **NÃO** marque issue como `pronta-pra-agente` sem critério de aceitação testável. Agente AFK vai entregar lixo.
- **NÃO** marque como `pronta-pra-agente` se a decisão precisa de humano. Categoria é `pronta-pra-humano` mesmo se o trabalho seja pequeno.
- **NÃO** feche issue como `wontfix` (enhancement) sem escrever em `.out-of-scope/`. Próximo pedido similar vai re-litigar do zero.
- **NÃO** invente label novo sem registrar no mapeamento de triagem. Vocabulário do projeto importa.
- **NÃO** misture papel de estado e categoria. `bug` + `pronta-pra-agente` são labels independentes — sempre 1 de cada.
- **NÃO** mude prioridade alheia sem alinhar. Triagem é classificação inicial.

### Quando categoria não está clara

- Comportamento bate com documentação/expectativa, usuário só não gostou → `enhancement`
- Comportamento difere de documentação/expectativa explícita → `bug`
- Misto (parte é bug, parte feature nova) → quebre em 2 issues; categoria por issue

### Quando `pronta-pra-humano` em vez de `pronta-pra-agente`

Sinais de que humano precisa:

- Decisão arquitetural ainda em aberto
- Acesso externo (admin de fornecedor, conta paga, ambiente físico)
- Julgamento subjetivo (cópia de marketing, escolha de design)
- Teste manual obrigatório (UX em browser, mobile, acessibilidade)
- Toca compliance / segurança / dado sensível

Quando dúvida: `pronta-pra-humano`. Custo de pôr agente em algo que precisa humano > custo de humano fazer algo que agente faria.

### Exemplo — triando bug mal-formado

**Issue #142 — "Tá lento"**

Corpo: "a página de pedidos demora muito a abrir". Sem comentários.

**Análise:**
- Categoria: provável `bug`, mas pode ser performance esperada
- Estado: impossível ir além de `precisa-de-info`

**Ação:** aplicar `bug` + `precisa-de-info`. Postar:

```markdown
> *Gerado por IA durante triagem.*

## Notas de Triagem

**O que já foi estabelecido:**

- Reporter relata lentidão em "página de pedidos"

**O que ainda precisamos de você (@reporter):**

- Qual URL exata? (a listagem? o detalhe? um filtro específico?)
- Qual o tempo que está vendo? (segundos aproximados)
- Sempre lento ou intermitente?
- Quantos pedidos esse usuário tem? (carga aproximada)
- Browser / dispositivo / região
```

### Exemplo — triando bug bem-formado pra `pronta-pra-agente`

**Issue #143 — "POST /orders retorna 500 quando carrinho tem >50 itens"**

Corpo: reprodução clara, log de erro anexado, ambiente especificado.

**Análise:**
- Categoria: `bug`
- Reprodução: confirmada local com `npm test -- carts.large.test.ts`
- Caminho de código: `src/cart/validate.ts` faz O(n²) em validação de items
- Estado: `pronta-pra-agente`

**Ação:** aplicar labels + postar agent brief seguindo [AGENT-BRIEF.md](AGENT-BRIEF.md).

### Exemplo — triando enhancement pra `wontfix`

**Issue #211 — "Adicionar modo escuro"**

Mantenedor decide que está fora de escopo (projeto foca em geração estática, theming é responsabilidade de quem consome).

**Ação:**
1. Cheque `.out-of-scope/` — não existe `dark-mode.md`. Criar.
2. Escreva arquivo seguindo [OUT-OF-SCOPE.md](OUT-OF-SCOPE.md)
3. Postar no issue: link para `.out-of-scope/dark-mode.md` + decisão
4. Fechar com `wontfix`

## Cross-references

- [AGENT-BRIEF.md](AGENT-BRIEF.md) — como escrever briefs durável para agentes AFK
- [OUT-OF-SCOPE.md](OUT-OF-SCOPE.md) — knowledge base de features rejeitadas
- [grill-with-docs](../grill-with-docs/SKILL.md) — usado em passo 4 quando issue precisa de mais carne
- [diagnose](../diagnose/SKILL.md) — destino comum de issues `bug` + `pronta-pra-agente`
- [to-issues](../to-issues/SKILL.md) — quando triagem revela que issue é epic disfarçado
- [setup-leandrocfe-skills](../setup-leandrocfe-skills/SKILL.md) — define mapeamento de papéis para labels reais do Rastreador
- [`CONTEXT.md`](../../CONTEXT.md) — definição canônica de Triagem e Issue
