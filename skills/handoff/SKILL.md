---
name: handoff
description: "Comprime a conversa atual em documento de handoff acionável (onde paramos, o que foi tentado, o que falhou, próximo passo, arquivos críticos, decisões em aberto) para continuação em outra sessão ou por outro agente. Use quando usuário disser \"passar bastão\", \"fazer handoff\", \"compactar contexto\", \"passar pra outra sessão\", \"contexto saturando\", ou invocar /handoff. Triggers: \"handoff\", \"context handoff\", \"pass the baton\"."
---

# handoff

Transferência de contexto de uma sessão/agente para a próxima. Documento de handoff bom é **acionável** — quem recebe deve conseguir continuar sem precisar reler toda a conversa anterior. Combate o anti-padrão de "vou retomar depois" e descobrir que metade do contexto evaporou.

## <o-que-fazer>

### Quando rodar

Sinais de que é hora de handoff:

- Contexto da sessão está chegando ao limite (tokens/janela)
- Vai pausar trabalho e retomar em outra hora/dia
- Vai passar pra outro agente ou pessoa
- Bug ficou pendente, precisa retomar com cabeça fresca
- Conversa virou muito longa e está difícil navegar

### Passo 1 — Confirmar escopo do handoff

Pergunte ao usuário:

- O handoff cobre **toda a sessão** ou só **uma sub-tarefa** específica?
- Quem vai receber? (você mesmo depois, outro agente, outra pessoa)
- Algum detalhe que **não** deve ir no doc (decisão exploratória descartada, dado sensível)?

### Passo 2 — Coletar do conversa

Extraia:

- **Objetivo da sessão** — qual era o "Por quê estamos aqui"
- **Onde paramos** — último estado verificável
- **O que funcionou** — caminhos confirmados, decisões tomadas
- **O que falhou** — tentativas que não vingaram (para o próximo não repetir)
- **Próximo passo concreto** — qual é a próxima ação executável
- **Arquivos críticos** — paths exatos relevantes
- **Decisões em aberto** — o que ainda precisa decidir
- **Comandos úteis** — invocações que o próximo vai precisar

### Passo 3 — Escrever o handoff usando o template

```markdown
# Handoff — <título curto> — YYYY-MM-DD HH:MM

## Objetivo

<1 parágrafo. Por que esta sessão existe. O que tentamos fazer.>

## Onde paramos

<Estado atual concreto. Verificável: "branch X tem commits Y", "arquivo Z na linha N",
"último teste rodado: <comando> retornou <resultado>".>

## O que funcionou

- <Decisão/abordagem 1 que ficou de pé>
- <Decisão/abordagem 2>

## O que tentei e não funcionou

- <Tentativa 1 — por quê não funcionou (1 frase)>
- <Tentativa 2 — por quê>

## Próximo passo concreto

<1 ação executável. Não "continuar". Algo como "rodar `npm test -- auth.test.ts`
e investigar a falha em `auth/middleware.ts:42`".>

## Arquivos críticos

- `path/para/arquivo1.ts` — <o que faz / por que importa>
- `path/para/arquivo2.ts` — <idem>
- `docs/adr/0008-xyz.md` — <decisão recente relacionada>

## Decisões em aberto

- [ ] <Decisão 1 — quem decide, com quem alinhar>
- [ ] <Decisão 2>

## Comandos úteis

```bash
# Rodar testes do módulo afetado
npm test -- auth.test.ts

# Verificar estado do banco local
psql -d dev -c "SELECT * FROM users LIMIT 3"
```

## Contexto extra

<Qualquer informação que o próximo precisa e não cabe nas seções acima.
Manter curto. Se for grande, virou ADR.>

## Como recuperar contexto rápido

<Lista de 2-3 ações para o próximo "se aquecer":
1. Ler issue #NN
2. Rodar `git log --oneline -10` na branch atual
3. Abrir o arquivo Y e ver o TODO da linha N>
```

### Passo 4 — Apresentar para validação

Mostre o documento para o usuário **antes** de salvar. Pergunte:

- Falta alguma decisão importante?
- Algum item em "tentei e não funcionou" que deve sair (info sensível)?
- O "próximo passo concreto" é mesmo a próxima ação, ou tem algo antes?

Iterar até aprovação.

### Passo 5 — Salvar onde o próximo vai achar

Opções por contexto:

- **Mesmo repo, próxima sessão sua:** `docs/handoffs/YYYY-MM-DD-<topic>.md`
- **Outro agente:** local combinado (geralmente repo do projeto + comentar no PR/issue relevante)
- **Outra pessoa:** mensagem no canal acordado (Slack, email) + link pro doc
- **Sessão temporária:** `/tmp/handoff-<topic>.md` se for descartável

Confirme com o usuário o destino antes de salvar.

### Passo 6 — Ações finais

- Commit do handoff se ele entra no repo (mensagem: `docs: handoff <topic>`)
- Linkar o handoff em issue/PR relevante (comentário curto: "Handoff atual: <link>")
- Se for handoff "vou voltar daqui a dias", criar lembrete (issue, calendário, agenda)

## <info-de-apoio>

### Anti-padrões

- **NÃO escreva resumo descritivo.** "Discutimos várias abordagens..." é resumo, não handoff. Handoff é **acionável**: o próximo lê e sabe o que fazer.
- **NÃO inclua "talvez", "podemos considerar".** Handoff é decisões tomadas + ação concreta + abertas explícitas. Hedging confunde.
- **NÃO esconda fracasso.** "Tentei X e não deu" é **valor** — economiza o tempo do próximo. Esconder por vergonha custa horas depois.
- **NÃO inclua dump bruto de conversa.** Transcrição não é handoff. Comprimir é o ponto.
- **NÃO assuma que o próximo lembra tudo.** Mesmo que o próximo seja você daqui a 2 horas — escreva como se fosse alguém novo.
- **NÃO termine sem "próximo passo concreto".** É a peça mais importante do doc. Sem isso, handoff é descrição.

### Como saber se o handoff está bom

Teste mental: **abra só o handoff** (sem conversa anterior). Você consegue:

- Saber qual é o objetivo? ✅
- Saber qual é o próximo comando/ação? ✅
- Saber quais arquivos abrir primeiro? ✅
- Saber o que **não** tentar de novo? ✅
- Saber o que precisa decidir antes de prosseguir? ✅

Se algum "não" — handoff incompleto. Volte e adicione.

### Tamanho típico

- **Mínimo viável:** ~30 linhas (handoff de sub-tarefa pequena)
- **Típico:** 60–150 linhas
- **Suspeito:** > 300 linhas (provavelmente está incluindo dump de conversa — compressar)

### Combine com `caveman` durante a escrita

Conversa antes do handoff frequentemente se beneficia de [caveman](../caveman/SKILL.md) ativo — denso, sem ruído. O handoff em si não precisa ser caveman: pode ser prosa normal, mas direta.

### Exemplo: handoff de bug não-resolvido

```markdown
# Handoff — Bug intermitente no checkout — 2026-05-11 14:30

## Objetivo

Resolver bug intermitente onde `POST /checkout` retorna 500 sob carga, ~3% dos requests
em produção. Issue #243.

## Onde paramos

- Branch `bug/243-checkout-500` em `origin`
- Adicionei logging estruturado em `src/checkout/process.ts:88-104`
- Deploy de canary com logging ativo às 13:20 — coletei 4h de dados
- Conjunto de logs em `tmp/checkout-logs-2026-05-11.json` (gitignored)

## O que funcionou

- Reproduzir local com `scripts/stress-checkout.sh` (50 req/s por 2min) → reproduz em ~1 de 200
- Logging estruturado mostra que a falha sempre ocorre na chamada para gateway de pagamento
- Hipótese atual: timeout não-tratado quando gateway demora >2s

## O que tentei e não funcionou

- Aumentar timeout do client HTTP de 2s para 5s: bug ainda ocorre, em frequência menor
- Adicionar retry síncrono: piorou latência média sem resolver
- Logar payload completo: não revelou padrão no input (não é dado específico)

## Próximo passo concreto

Implementar circuit breaker entre `checkout/process.ts` e gateway, com fallback para
"pagamento em processamento" + reconciliação assíncrona. Começar pelo teste:

```bash
git checkout bug/243-checkout-500
npm test -- checkout/process.test.ts -t "circuit breaker"
```

(o teste ainda não existe — escrever vermelho primeiro)

## Arquivos críticos

- `src/checkout/process.ts:60-130` — handler do checkout
- `src/integrations/gateway-client.ts` — cliente do gateway (sem circuit breaker hoje)
- `docs/adr/0006-pagamentos-async.md` — decisão prévia sobre async (limite o escopo do circuit breaker)
- `tmp/checkout-logs-2026-05-11.json` — logs de produção da janela do bug

## Decisões em aberto

- [ ] Circuit breaker abre por quanto tempo? (sugestão inicial: 30s)
- [ ] Reconciliação assíncrona usa fila existente ou cria nova? (alinhar com @leandrocfe)

## Comandos úteis

```bash
# Reproduzir local
docker compose up gateway-mock
./scripts/stress-checkout.sh

# Ver logs estruturados ordenados
jq -s 'sort_by(.ts)' tmp/checkout-logs-2026-05-11.json | less
```

## Como recuperar contexto rápido

1. Ler issue #243 (descrição original + comentário de hoje 14:00)
2. Ler ADR-0006 (limites async já decididos)
3. Abrir `src/checkout/process.ts` e ver os logs novos das linhas 88-104
```

## Cross-references

- [caveman](../caveman/SKILL.md) — bom durante a sessão que vai gerar handoff (denso, menos contexto consumido)
- [diagnose](../diagnose/SKILL.md) — bugs frequentemente precisam de handoff porque levam dias
- [`CONTEXT.md`](../../CONTEXT.md) — definição canônica de Handoff
