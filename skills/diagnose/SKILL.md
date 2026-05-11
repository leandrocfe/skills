---
name: diagnose
description: "Diagnostica bug difícil ou regressão de performance através de um loop de feedback determinístico — construir o loop é a habilidade central; bisseção, teste de hipótese e instrumentação são consumo dele. Use quando usuário pedir \"diagnosticar bug\", \"investigar bug difícil\", \"achar regressão\", \"por que está quebrando\", \"bug intermitente\", ou invocar /diagnose. Triggers: \"diagnose\", \"debug\", \"regression\", \"root cause\", \"feedback loop\"."
---

# diagnose

Disciplina para bugs difíceis. Pule fases somente com justificativa explícita.

Ao explorar o codebase, use o glossário de domínio do projeto pra ter modelo mental claro dos módulos relevantes, e cheque ADRs na área que vai tocar.

## <o-que-fazer>

### Fase 1 — Construir um loop de feedback

**Esta é a habilidade.** Tudo o mais é mecânico. Se você tem um sinal de pass/fail rápido, determinístico, executável por agente para o bug, você **vai** achar a causa — bisseção, teste de hipótese e instrumentação **apenas consomem esse sinal**. Sem loop, nenhum encarar de código vai te salvar.

Gaste esforço desproporcional aqui. **Seja agressivo. Seja criativo. Recuse desistir.**

#### Maneiras de construir um — tente nesta ordem aproximada

1. **Teste que falha** em qualquer seam que alcance o bug — unitário, integração, e2e
2. **Script curl / HTTP** contra dev server rodando
3. **Invocação CLI** com input de fixture, diff do stdout contra snapshot conhecido-bom
4. **Script de browser headless** (Playwright / Puppeteer) — dirige a UI, asserta DOM/console/rede
5. **Replay de trace capturado.** Salva requisição/payload/log de evento real em disco; replay pelo caminho de código isolado
6. **Harness descartável.** Sobe subset mínimo do sistema (1 serviço, deps mockadas) que exercita o caminho do bug com uma chamada
7. **Loop de propriedade / fuzz.** Se o bug é "às vezes output errado", roda 1000 inputs aleatórios e procura o padrão de falha
8. **Harness de bisseção.** Se o bug apareceu entre dois estados conhecidos (commit, dataset, versão), automatize "boot no estado X, cheque, repita" pra rodar `git bisect run`
9. **Loop diferencial.** Roda o mesmo input em versão-antiga vs versão-nova (ou 2 configs) e diff outputs
10. **Script bash HITL.** Último recurso. Se humano tem que clicar, dirija-o com [`scripts/hitl-loop.template.sh`](scripts/hitl-loop.template.sh) pro loop continuar estruturado. Output capturado volta pra você.

**Construa o loop certo, e o bug está 90% consertado.**

#### Itere no próprio loop

Trate o loop como produto. Quando tiver _um_ loop, pergunte:

- **Dá pra fazer mais rápido?** (cachear setup, pular init não-relacionado, estreitar escopo do teste)
- **Dá pra fazer o sinal mais nítido?** (assertar no sintoma específico, não em "não crashou")
- **Dá pra fazer mais determinístico?** (pin de tempo, seed do RNG, isolar filesystem, congelar rede)

Loop flaky de 30s mal é melhor que nenhum loop. Loop determinístico de 2s é **superpoder de debug**.

#### Bugs não-determinísticos

O objetivo não é repro limpa, é **taxa maior de reprodução**. Loop do trigger 100×, paralelize, adicione stress, estreite janelas de timing, injete sleeps. Bug flake-50% é debugável; 1% não é — continue subindo a taxa até virar debugável.

#### Quando você genuinamente não consegue construir um loop

Pare e diga isso explicitamente. Liste o que tentou. Peça ao usuário: (a) acesso ao ambiente que reproduz, (b) artefato capturado (HAR file, dump de log, core dump, gravação de tela com timestamps), ou (c) permissão pra adicionar instrumentação temporária em produção. **Não** prossiga pra hipotetizar sem loop.

**Não vá para Fase 2 sem um loop em que você acredita.**

### Fase 2 — Reproduzir

Rode o loop. Veja o bug aparecer.

Confirme:

- [ ] O loop produz o modo de falha que o **usuário** descreveu — não outro modo que acontece próximo. Bug errado = correção errada.
- [ ] Falha é reprodutível em múltiplas rodadas (ou, para não-determinístico, taxa suficiente pra debugar contra)
- [ ] Você capturou o sintoma exato (mensagem de erro, output errado, timing lento) pra fases seguintes verificarem que o fix endereça mesmo

**Não prossiga até reproduzir.**

### Fase 3 — Hipotetizar

Gere **3–5 hipóteses ranqueadas** antes de testar qualquer uma. Geração de hipótese única ancora na primeira ideia plausível.

Cada hipótese deve ser **falsificável**: declare a predição que faz.

> Formato: "Se <X> é a causa, então <mudar Y> faz o bug sumir / <mudar Z> piora."

Se você não consegue declarar a predição, a hipótese é vibe — descarte ou refine.

**Mostre a lista ranqueada para o usuário antes de testar.** Eles frequentemente têm conhecimento de domínio que re-ranqueia na hora ("a gente acabou de fazer deploy de mudança no #3"), ou conhecem hipóteses já descartadas. Checkpoint barato, economia grande. Não bloqueie nisso — siga com seu ranqueamento se usuário está AFK.

### Fase 4 — Instrumentar

Cada sonda deve mapear pra uma predição específica da Fase 3. **Mude uma variável por vez.**

Preferência de ferramenta:

1. **Inspeção de debugger / REPL** se o ambiente suporta. Um breakpoint vence dez logs.
2. **Logs alvejados** nas fronteiras que distinguem hipóteses.
3. **Nunca** "loga tudo e grep depois".

**Tagueie todo log de debug** com prefixo único, ex: `[DEBUG-a4f2]`. Limpeza no fim vira um único grep. Logs sem tag sobrevivem; logs tagueados morrem.

**Branch de performance.** Para regressão de performance, logs geralmente estão errados. Em vez disso: estabeleça medida de baseline (harness de timing, `performance.now()`, profiler, plano de query), depois bissecte. **Meça primeiro, conserte depois.**

### Fase 5 — Corrigir + teste de regressão

Escreva o teste de regressão **antes do fix** — mas **somente se houver seam correto** para ele.

Seam correto = onde o teste exercita o **padrão real do bug** como ele ocorre no call site. Se o único seam disponível é raso demais (teste de single-caller quando o bug precisa de múltiplos callers, teste unitário que não replica a cadeia que disparou o bug), teste de regressão ali dá **falsa confiança**.

**Se não existe seam correto, isso em si é o achado.** Anote. Arquitetura do codebase está impedindo o bug de ser travado. Sinalize pra próxima fase.

Se seam correto existe:

1. Transforme a repro minimizada em teste que falha no seam
2. Veja falhar
3. Aplique o fix
4. Veja passar
5. Re-rode o loop da Fase 1 contra o cenário original (não-minimizado)

### Fase 6 — Limpeza + post-mortem

Obrigatório antes de declarar pronto:

- [ ] Repro original não reproduz mais (re-rodar o loop da Fase 1)
- [ ] Teste de regressão passa (ou ausência de seam está documentada)
- [ ] Toda instrumentação `[DEBUG-...]` removida (`grep` o prefixo)
- [ ] Protótipos descartáveis deletados (ou movidos pra local claramente marcado de debug)
- [ ] A hipótese que se mostrou correta está declarada na mensagem de commit / PR — pra próximo debugger aprender

**Depois pergunte: o que teria prevenido esse bug?** Se a resposta envolve mudança arquitetural (sem bom seam de teste, callers emaranhados, acoplamento escondido), faça handoff pra alguém revisitar arquitetura. Faça a recomendação **depois** do fix estar dentro, não antes — você tem mais informação agora do que quando começou.

## <info-de-apoio>

### Anti-padrões

- **NÃO corrija sintoma sem entender causa.** Você só está empurrando o bug pra outro lugar. Pior: novos sintomas serão atribuídos a coisas não-relacionadas.
- **NÃO mude duas coisas ao mesmo tempo.** Mata a capacidade de saber qual mudança consertou (ou quebrou).
- **NÃO pule para "vou tentar mudar isso".** Cada mudança consome contexto e introduz risco. Hipótese antes.
- **NÃO ignore reprodução intermitente.** "Acho que consertou" depois de bug intermitente = bug ainda existe. Reproduza em loop com instrumentação.
- **NÃO termine sem teste de regressão.** O bug vai voltar. Esta é a única forma de prevenir.
- **NÃO commite `console.log` esquecidos.** Lint pega; revisão pega; aja como se não pegasse.
- **NÃO vá pra Fase 3 sem loop da Fase 1.** Hipotetizar sem ferramenta de teste é especulação.

### Regressão de performance

Mesmo loop, com adaptações:

- **Reprodução:** benchmark reproduzível. `time` ou ferramenta de profiling.
- **Minimização:** menor input que ainda mostra a regressão
- **Hipótese:** "essa query agora retorna N+1; era 1 antes" — sempre quantitativa
- **Instrumentação:** profiler, query log, flame graph
- **Correção:** valida com mesmo benchmark
- **Regressão:** teste de performance que falha se passar de X ms

### Bug em produção que você não consegue reproduzir local

Sequência:

1. Capturar todos os logs / telemetria do incidente — antes de qualquer outra coisa
2. Aumentar verbosidade de log no ambiente afetado (com cuidado)
3. Recriar o estado de dado em ambiente local (se tem dump anonimizado)
4. Se for de timing: stress test em loop com instrumentação
5. Se nada funciona: adicionar observabilidade defensiva (telemetria estruturada na área suspeita) e esperar repetir — então tem dado pra Fase 1

### Exemplo: bug de cache

**Sintoma:** usuário atualiza foto de perfil; sites/app mostram a antiga por ~5min.

**Fase 1 — Loop:** `curl -I http://app/user/123/profile.json` retorna headers em <100ms; sinal claro (presença/ausência de cabeçalho `Cache-Control` específico). Determinístico, rodável por agente.

**Fase 2 — Reproduzir:** rodar o loop antes do update → header `Cache-Control: max-age=300`. Depois do update → mesmo header. Confirma sintoma.

**Fase 3 — Hipotetizar:**
- H1 (alta): CDN cacheia a resposta. Predição: mudar `Cache-Control` da resposta pra `no-cache` resolve o sintoma na CDN edge.
- H2 (média): Cache da app não invalida. Predição: cache de Redis tem objeto antigo após update.
- H3 (baixa): SW do browser cacheia. Predição: limpar SW resolve só nesse browser.

**Fase 4 — Instrumentar:** `curl -I` da CDN edge mostra `Cache-Control: max-age=300` vindo da app. H1 confirmada.

**Fase 5 — Fix + regressão:** mudar response para `Cache-Control: no-cache, must-revalidate` em rotas de perfil. Teste de integração: `GET /user/:id/profile.json` retorna o header esperado. Falha → fix → passa.

**Fase 6 — Limpeza:** remover logs temporários, mensagem de commit registra a hipótese confirmada.

### Quando reproduzir é tão difícil que o loop vira o projeto

Aceitável. Bug crítico de prod sem reprodução local pode exigir 2 dias só pra Fase 1. Trate isso como **trabalho real**, não pré-trabalho.

Sinais de que vale a pena investir:

- Bug está afetando receita / SLA agora
- Custo de não-debug > custo de construir loop
- Reprodução boa serve pra teste de regressão depois

Sinais de que **não** vale:

- Bug aparece 1× a cada 6 meses e tem workaround
- Você está chasing fantasma (talvez nem seja bug)

## Cross-references

- [tdd](../tdd/SKILL.md) — Fase 5 (teste de regressão) é o teste vermelho do próximo ciclo TDD
- [grill-me](../grill-me/SKILL.md) — se usuário descreve o bug vago, grill antes
- [triage](../triage/SKILL.md) — bug priorizado decide quanto investir em diagnose
- [`scripts/hitl-loop.template.sh`](scripts/hitl-loop.template.sh) — template pra loop HITL
- [`CONTEXT.md`](../../CONTEXT.md) — vocabulário canônico
