---
name: diagnose
description: "Loop disciplinado de diagnóstico para bugs difíceis e regressões de performance. Reproduzir → minimizar → hipotetizar → instrumentar → corrigir → testar regressão. Use quando o usuário disser \"diagnostica isso\" / \"debuga isso\", reportar um bug, disser que algo está quebrado/lançando erro/falhando, ou descrever uma regressão de performance. Use when user says \"diagnose this\" / \"debug this\", reports a bug, says something is broken/throwing/failing, or describes a performance regression."
---

# Diagnose

Disciplina para bugs difíceis. Pule fases só com justificativa explícita.

Ao explorar a codebase, use o glossário de domínio do projeto para ter um modelo mental claro dos módulos relevantes e cheque ADRs na área que está tocando.

## Fase 1 — Construa um feedback loop

**Esta é a skill.** Tudo o mais é mecânico. Se você tem um sinal pass/fail rápido, determinístico e agent-runnable para o bug, você vai achar a causa — bisseção, hypothesis-testing e instrumentação só consomem esse sinal. Se você não tem, nenhum tempo encarando código vai te salvar.

Gaste esforço desproporcional aqui. **Seja agressivo. Seja criativo. Recuse-se a desistir.**

### Formas de construir um — tente nesta ordem aproximada

1. **Teste que falha** em qualquer seam que alcance o bug — unit, integration, e2e.
2. **Curl / script HTTP** contra um dev server rodando.
3. **Invocação de CLI** com um fixture input, diffando stdout contra um snapshot known-good.
4. **Script de headless browser** (Playwright / Puppeteer) — dirige a UI, asserta sobre DOM/console/network.
5. **Replay de trace capturado.** Salve um network request / payload / event log real em disco; replay no code path em isolamento.
6. **Harness descartável.** Suba um subconjunto mínimo do sistema (um service, deps mockadas) que exercite o code path do bug com uma única function call.
7. **Loop de property / fuzz.** Se o bug é "às vezes output errado", rode 1000 inputs aleatórios e procure o failure mode.
8. **Harness de bisseção.** Se o bug apareceu entre dois estados conhecidos (commit, dataset, versão), automatize "boota no estado X, cheque, repete" para poder fazer `git bisect run`.
9. **Loop diferencial.** Rode o mesmo input por versão-velha vs versão-nova (ou duas configs) e diffe outputs.
10. **Script bash HITL.** Último recurso. Se um humano precisa clicar, dirija _ele_ com `scripts/hitl-loop.template.sh` para o loop ainda ser estruturado. O output capturado realimenta você.

Construa o feedback loop certo e o bug está 90% corrigido.

### Itere sobre o próprio loop

Trate o loop como um produto. Quando tiver _um_ loop, pergunte:

- Posso torná-lo mais rápido? (Cachear setup, pular init não-relacionada, estreitar escopo de teste.)
- Posso tornar o sinal mais nítido? (Asserir sobre o sintoma específico, não "não crashou".)
- Posso torná-lo mais determinístico? (Fixar tempo, semear RNG, isolar filesystem, congelar rede.)

Um loop flaky de 30s é mal melhor que nenhum loop. Um loop determinístico de 2s é um superpoder de debugging.

### Bugs não-determinísticos

A meta não é um repro limpo, é uma **taxa de reprodução mais alta**. Loop o trigger 100×, paralelize, adicione stress, estreite janelas de timing, injete sleeps. Um bug com 50% de flake é debuggable; 1% não é — aumente a taxa até ficar debuggable.

### Quando você genuinamente não consegue construir um loop

Pare e diga explicitamente. Liste o que tentou. Peça ao usuário: (a) acesso ao ambiente que reproduz, (b) um artefato capturado (HAR file, log dump, core dump, gravação de tela com timestamps), ou (c) permissão para adicionar instrumentação temporária em produção. **Não** prossiga para hipotetizar sem um loop.

Não prossiga para a Fase 2 até ter um loop em que você acredita.

## Fase 2 — Reproduzir

Rode o loop. Veja o bug aparecer.

Confirme:

- [ ] O loop produz o failure mode que o **usuário** descreveu — não um failure diferente que acontece de estar perto. Bug errado = fix errado.
- [ ] O failure é reprodutível em múltiplas runs (ou, para bugs não-determinísticos, reprodutível a uma taxa alta o suficiente para debugar contra).
- [ ] Você capturou o sintoma exato (mensagem de erro, output errado, timing lento) para que fases posteriores verifiquem se o fix de fato endereça.

Não prossiga até reproduzir o bug.

## Fase 3 — Hipotetizar

Gere **3-5 hipóteses ranqueadas** antes de testar qualquer uma. Geração de hipótese única ancora na primeira ideia plausível.

Cada hipótese precisa ser **falsificável**: declare a predição que faz.

> Formato: "Se <X> é a causa, então <mudar Y> vai fazer o bug sumir / <mudar Z> vai piorar."

Se você não consegue declarar a predição, a hipótese é vibe — descarte ou afie.

**Mostre a lista ranqueada ao usuário antes de testar.** Eles geralmente têm conhecimento de domínio que re-ranqueia na hora ("acabamos de deployar uma mudança no #3"), ou sabem de hipóteses que já descartaram. Checkpoint barato, grande economia de tempo. Não bloqueie nisso — prossiga com seu ranking se o usuário estiver AFK.

## Fase 4 — Instrumentar

Cada probe precisa mapear para uma predição específica da Fase 3. **Mude uma variável de cada vez.**

Preferência de ferramenta:

1. **Inspeção via debugger / REPL** se o env suporta. Um breakpoint vence dez logs.
2. **Logs direcionados** nas fronteiras que distinguem hipóteses.
3. Nunca "logue tudo e dê grep".

**Tagueie cada log de debug** com um prefixo único, ex.: `[DEBUG-a4f2]`. Cleanup no fim vira um grep só. Logs sem tag sobrevivem; logs taggeados morrem.

**Branch de perf.** Para regressões de performance, logs costumam estar errados. Em vez disso: estabeleça medição de baseline (timing harness, `performance.now()`, profiler, query plan), depois bissecte. Meça primeiro, conserte depois.

## Fase 5 — Fix + teste de regressão

Escreva o teste de regressão **antes do fix** — mas só se houver um **seam correto** para ele.

Um seam correto é onde o teste exercita o **padrão real do bug** como ocorre no call site. Se o único seam disponível é raso demais (teste single-caller quando o bug precisa de múltiplos callers, unit test que não consegue replicar a chain que disparou o bug), um teste de regressão lá dá falsa confiança.

**Se nenhum seam correto existe, isso por si é o achado.** Anote. A arquitetura da codebase está impedindo o bug de ser trancado. Sinalize para a próxima fase.

Se um seam correto existe:

1. Transforme o repro minimizado num teste que falha nesse seam.
2. Veja-o falhar.
3. Aplique o fix.
4. Veja-o passar.
5. Re-rode o feedback loop da Fase 1 contra o cenário original (não-minimizado).

## Fase 6 — Cleanup + post-mortem

Obrigatório antes de declarar feito:

- [ ] Repro original não reproduz mais (re-rode o loop da Fase 1)
- [ ] Teste de regressão passa (ou ausência de seam está documentada)
- [ ] Toda instrumentação `[DEBUG-...]` removida (`grep` o prefixo)
- [ ] Protótipos descartáveis deletados (ou movidos para uma localização de debug claramente marcada)
- [ ] A hipótese que se mostrou correta está declarada na commit / PR message — para o próximo debugger aprender

**Aí pergunte: o que teria evitado este bug?** Se a resposta envolve mudança arquitetural (sem seam de teste bom, callers emaranhados, coupling escondido) faça handoff para a skill `/improve-codebase-architecture` com os detalhes. Faça a recomendação **depois** do fix entrar, não antes — você tem mais informação agora que quando começou.
