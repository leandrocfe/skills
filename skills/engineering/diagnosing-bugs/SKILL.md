---
name: diagnosing-bugs
description: Loop de diagnóstico para bugs difíceis e regressões de performance. Use quando o usuário disser "diagnose"/"debug this", ou relatar algo quebrado/lançando/falhando/lento.
---

# Diagnosing Bugs

Uma disciplina para bugs difíceis. Pule fases só quando explicitamente justificado.

Ao explorar a codebase, leia `CONTEXT.md` (se existir) para ter um modelo mental claro dos módulos relevantes, e verifique ADRs na área que você está tocando.

## Redija

Esta skill faz você mostrar comandos, outputs e artefatos capturados. **Redija todo secret primeiro** — escreva `<REDACTED>` no lugar. Construa loops contra env vars, para a credencial ficar no ambiente em vez de no que você mostra. Artefatos capturados carregam auth headers: cite apenas as linhas que carregam o sinal.

Se o output redigido não bastar para diagnosticar o bug, diga isso e pergunte ao usuário.

## Fase 1 — Construa um feedback loop

**Esta é a skill.** Todo o resto é mecânico. Se você tiver um sinal **apertado** de pass/fail para o bug — um que fica vermelho neste bug específico — você vai encontrar a causa; bisection, teste de hipóteses e instrumentação só consomem ele. Se não tiver, nenhuma quantidade de olhar código vai salvar você.

Dedique esforço desproporcional aqui. **Seja agressivo. Seja criativo. Recuse desistir.**

### Formas de construir um — tente mais ou menos nesta ordem

1. **Teste falhando** no seam que alcança o bug — unit, integration, e2e.
2. **Curl / script HTTP** contra um dev server rodando.
3. **Invocação CLI** com uma fixture de input, diffando stdout contra um snapshot known-good.
4. **Script de headless browser** (Playwright / Puppeteer) — dirige a UI, afirma sobre DOM/console/network.
5. **Replay de um trace capturado.** Salve uma requisição real de rede / payload / log de evento em disco; replay através do caminho do código em isolamento.
6. **Harness descartável.** Suba um subconjunto mínimo do sistema (um serviço, deps mockadas) que exercita o caminho do código do bug com uma única chamada de função.
7. **Loop de property / fuzz.** Se o bug é "às vezes output errado", rode 1000 inputs aleatórios e procure o modo de falha.
8. **Harness de bisection.** Se o bug apareceu entre dois estados conhecidos (commit, dataset, versão), automatize "boot no estado X, cheque, repita" para poder `git bisect run`.
9. **Loop diferencial.** Rode o mesmo input em versão-antiga vs versão-nova (ou duas configs) e diff outputs.
10. **Script HITL bash.** Último recurso. Se um humano precisa clicar, dirija _ele_ com `scripts/hitl-loop.template.sh` para o loop ainda ser estruturado. Output capturado volta para você.

Construa o feedback loop certo, e o bug está 90% resolvido.

### Aperta o loop

Trate o loop como um produto. Uma vez que você tem _um_ loop, **aperte**:

- Posso torná-lo mais rápido? (Cache setup, pule init irrelevante, estreite o escopo do teste.)
- Posso tornar o sinal mais nítido? (Afirme no sintoma específico, não "não crashou".)
- Posso torná-lo mais determinístico? (Pin time, seed RNG, isole filesystem, congele network.)

Um loop flaky de 30 segundos é pouco melhor que nenhum; um determinístico de 2 segundos é apertado — um superpoder de debug.

### Bugs não-determinísticos

O objetivo não é um repro limpo, mas uma **taxa de reprodução mais alta**. Rode o trigger 100×, paralelize, adicione stress, estreite janelas de timing, injete sleeps. Um bug de 50% flake é debuggável; 1% não é — continue subindo a taxa até ser debuggável.

### Quando você genuinamente não consegue construir um loop

Pare e diga explicitamente. Liste o que tentou. Peça ao usuário: (a) acesso ao ambiente que reproduz, (b) um artefato capturado redigido (HAR file, log dump, core dump, screen recording com timestamps), ou (c) permissão para adicionar instrumentação temporária em produção. **Não** prossiga para hipotetizar sem um loop.

### Critério de conclusão — um loop apertado que fica vermelho

Fase 1 está pronta quando o loop está **apertado** e **red-capable**: você consegue nomear **um comando** — um caminho de script, uma invocação de teste, um curl — que você **já rodou pelo menos uma vez** (mostre a invocação e seu output, redigidos), e que é:

- [ ] **Red-capable** — dirige o caminho real do código do bug e afirma o **sintoma exato do usuário**, de forma que possa ficar vermelho neste bug e verde quando corrigido. Não "roda sem erro" — precisa conseguir _pegar este bug específico_.
- [ ] **Determinístico** — mesmo veredito toda execução (bugs flaky: uma taxa alta de reprodução pinada, conforme acima).
- [ ] **Rápido** — segundos, não minutos.
- [ ] **Agent-runnable** — você pode rodá-lo sem supervisão; humano no loop só via `scripts/hitl-loop.template.sh`.

Se você se pegar lendo código para construir uma teoria antes deste comando existir, **pare — pular direto para hipótese é exatamente a falha que esta skill previne.** Sem comando red-capable, sem Fase 2.

## Fase 2 — Reproduza + minimize

Rode o loop. Veja ele ficar vermelho — o bug aparece.

Confirme:

- [ ] O loop produz o modo de falha que o **usuário** descreveu — não uma falha diferente que acontece por perto. Bug errado = correção errada.
- [ ] A falha é reprodutível em múltiplas execuções (ou, para bugs não-determinísticos, reprodutível em taxa alta o suficiente para debug).
- [ ] Você capturou o sintoma exato (mensagem de erro, output errado, timing lento) para que fases posteriores possam verificar que a correção realmente o endereça.

### Minimize

Uma vez vermelho, encolha o repro para o **menor cenário que ainda fica vermelho**. Corte inputs, callers, config, dados e passos **um de cada vez**, re-rodando o loop depois de cada corte — mantenha só o que é load-bearing para a falha.

Por que vale: um repro mínimo encolhe o espaço de hipóteses na Fase 3 (menos peças móveis para suspeitar) e vira o regression test limpo na Fase 5.

Pronto quando **todo elemento restante for load-bearing** — remover qualquer um faz o loop ficar verde.

Não prossiga até ter reproduzido **e** minimizado.

## Fase 3 — Hipotetize

Gere **3–5 hipóteses ranqueadas** antes de testar qualquer uma. Geração de hipótese única ancora na primeira ideia plausível.

Cada hipótese deve ser **falsificável**: declare a predição que ela faz.

> Formato: "Se <X> for a causa, então <mudar Y> fará o bug desaparecer / <mudar Z> vai piorar."

Se você não conseguir declarar a predição, a hipótese é um vibe — descarte ou afine.

**Mostre a lista ranqueada ao usuário antes de testar.** Eles frequentemente têm conhecimento de domínio que re-ranqueia instantaneamente ("acabamos de deployar uma mudança no #3"), ou sabem hipóteses que já foram descartadas. Checkpoint barato, grande economia de tempo. Não bloqueie por isso — prossiga com seu ranking se o usuário estiver AFK.

## Fase 4 — Instrumente

Cada sonda deve mapear para uma predição específica da Fase 3. **Mude uma variável por vez.**

Preferência de ferramenta:

1. **Debugger / REPL inspection** se o ambiente suportar. Um breakpoint ganha de dez logs.
2. **Logs direcionados** nos boundaries que distinguem hipóteses.
3. Nunca "logue tudo e grep".

**Tag todo debug log** com um prefixo único, ex. `[DEBUG-a4f2]`. Limpeza no final vira um único grep. Logs sem tag sobrevivem; logs tageados morrem.

**Ramo de perf.** Para regressões de performance, logs geralmente estão errados. Em vez disso: estabeleça uma medição baseline (harness de timing, `performance.now()`, profiler, query plan), depois bisect. Meça primeiro, corrija depois.

## Fase 5 — Corrija + regression test

Escreva o regression test **antes da correção** — mas só se houver um **seam correto** para ele.

Um seam correto é aquele onde o teste exercita o **padrão real do bug** como ele ocorre no call site. Se o único seam disponível for muito shallow (teste de single-caller quando o bug precisa de múltiplos callers, unit test que não consegue replicar a cadeia que disparou o bug), um regression test ali dá confiança falsa.

**Se nenhum seam correto existir, isso em si é o achado.** Note. A arquitetura da codebase está impedindo que o bug seja trancado. Flag isso para a próxima fase.

Se um seam correto existir:

1. Transforme o repro minimizado em um teste falhando naquele seam.
2. Veja falhar.
3. Aplique a correção.
4. Veja passar.
5. Re-execute o loop de feedback da Fase 1 contra o cenário original (não-minimizado).

## Fase 6 — Cleanup + post-mortem

Obrigatório antes de declarar done:

- [ ] O repro original não reproduz mais (re-execute o loop da Fase 1)
- [ ] Regression test passa (ou ausência de seam está documentada)
- [ ] Toda instrumentação `[DEBUG-...]` removida (`grep` o prefixo)
- [ ] Protótipos descartáveis deletados (ou movidos para um local de debug claramente marcado)
- [ ] A hipótese que se mostrou correta está declarada na mensagem de commit / PR — para o próximo debugger aprender

**Depois pergunte: o que teria prevenido este bug?** Se a resposta envolver mudança arquitetural (sem bom seam de teste, callers emaranhados, acoplamento escondido) passe para a skill `/improve-codebase-architecture` com os detalhes. Faça a recomendação **depois** que a correção estiver, não antes — você tem mais informação agora do que quando começou.
