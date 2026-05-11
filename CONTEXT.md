# Vocabulário Canônico

Este documento define a **linguagem ubíqua** usada por todas as skills deste plugin. Quando uma skill precisa se referir a um conceito recorrente, ela deve usar o termo canônico definido aqui — não redefinir, não inventar sinônimo.

Skills evoluem. Termos novos entram aqui antes de aparecerem em SKILL.md.

---

## Rastreador de Issues

Sistema onde issues são criadas, comentadas, atribuídas, fechadas.

- **Default:** GitHub Issues
- **Aceito em contexto explícito:** Jira, Linear, Azure DevOps, GitLab Issues
- **Rejeitar:** "ticket system", "bug tracker", "sistema de chamados"

Skills que dependem do tracker devem perguntar ao usuário qual é o tracker no início se não estiver claro.

---

## Issue

Unidade de trabalho rastreável: bug, feature, tarefa, débito técnico, investigação.

- **Forma plural:** issues (não "issuezinhas", não "chamados")
- **Aceito como sinônimo:** "ticket" apenas em contexto Jira
- **Rejeitar:** "chamado" (vocabulário de suporte, não de engenharia)

Issue tem ciclo: **aberta → em triagem → priorizada → em progresso → em revisão → fechada**.

---

## PRD (Product Requirements Document)

Documento que descreve **problema**, **requisitos**, **critérios de aceitação** e **escopo fora**.

- Termo mantido em inglês (consagrado na indústria)
- Não confundir com **spec técnica** (PRD é problema + critério; spec é solução)

Skills que geram PRD devem incluir minimamente: contexto, problema, requisitos, critérios de aceitação, fora de escopo.

---

## Triagem

Processo de classificar issue recém-aberta segundo dimensões:

- **Prioridade:** P0 (parar tudo) → P3 (quando der)
- **Tipo:** bug, feature, débito técnico, dúvida
- **Tamanho:** XS / S / M / L / XL
- **Owner:** quem é responsável pela próxima ação

Não confundir com **priorização** (priorização decide ordem; triagem classifica).

---

## Handoff

Transferência estruturada de contexto entre agentes ou sessões, registrada em documento.

Um handoff bom contém: **onde paramos**, **o que foi tentado**, **o que falhou**, **próximo passo concreto**, **arquivos críticos**, **decisões em aberto**.

Não confundir com **resumo de conversa** (resumo é descritivo; handoff é acionável).

---

## Fatia Vertical

Implementação que atravessa todas as camadas (UI → controller → service → DB) entregando 1 caminho funcional ponta-a-ponta.

Oposto de **fatia horizontal**, que entrega 1 camada inteira (ex: "fazer todo o DB primeiro").

Skills como `tdd` operam em fatias verticais.

---

## ADR (Architecture Decision Record)

Registro datado de uma decisão arquitetural relevante, com contexto, alternativas consideradas, decisão tomada e consequências.

- Termo mantido em inglês (consagrado)
- Localização default: `docs/adr/NNNN-titulo.md`
- Formato: ver `grill-with-docs/SKILL.md` para template usado

---

## Vibe Coding

Anti-padrão: programar sem método, sem teste, sem entender o problema, deixando o LLM "tentar até passar".

Skills deste plugin existem para **combater vibe coding**: forçar disciplina, evidência e entendimento antes de código.

---

## Agente AFK

Agente que opera **autonomamente, sem humano disponível** pra responder dúvidas durante a execução. Pega issue marcada como `pronta-pra-agente`, lê o **agent brief**, e entrega.

- Forma plural: agentes AFK
- AFK = "away from keyboard" (humano longe do teclado)
- Aceito como sinônimo em contexto: "agente autônomo", "agente offline"
- Rejeitar: "bot" (genérico demais), "robô" (impreciso)

Diferença crítica: agente AFK **não pergunta**. Se a issue não está completamente especificada, o resultado é lixo. Por isso a triagem separa `pronta-pra-agente` de `pronta-pra-humano`.

---

## Agent Brief

Comentário estruturado postado em issue `pronta-pra-agente`. **Contrato** com o qual o agente AFK trabalha.

Contém: categoria, resumo, comportamento atual, comportamento desejado, interfaces relevantes, critérios de aceitação, fora de escopo.

- Termo mantido em inglês (consagrado no Total TypeScript / contexto deste plugin)
- Aceito como sinônimo: "brief"
- Rejeitar: "especificação técnica" (genérico), "ticket detalhado" (vago)

Agent brief tem propriedade central: **durabilidade**. Continua útil mesmo com arquivos renomeados — descreve interfaces e comportamentos, não paths/linhas.

---

## Out-of-Scope

Knowledge base de features rejeitadas, guardada em `.out-of-scope/<conceito>.md` no repo.

Serve a dois propósitos: **memória institucional** (por que rejeitou) e **deduplicação** (pedido similar futuro mostra a decisão anterior).

- Forma: kebab-case por conceito, não por issue
- Aceito como sinônimo: "fora de escopo permanente"
- Rejeitar: "backlog frio" (sugere que volta), "won't fix list" (não captura "por quê")

Diferente de **fora de escopo de PRD** (que escopa **uma entrega**). Out-of-scope é **decisão arquitetural durável** — feature não entra no produto, ponto.

---

## Feedback Loop

Sinal **rápido, determinístico, executável por agente** de pass/fail pra uma hipótese de bug.

Núcleo da skill [diagnose](skills/diagnose/SKILL.md). Sem loop, debug é especulação. Com loop, debug é mecânico — bisseção, hipótese e instrumentação **consomem** o loop.

- Aceito como sinônimo: "loop de feedback", "loop de repro"
- Rejeitar: "smoke test" (genérico demais), "checagem" (vago)

Métrica: tempo do loop. Loop de 30s flaky mal é melhor que nada. Loop de 2s determinístico é superpoder.

---

## Fatia Horizontal

**Anti-padrão.** Implementação que entrega uma camada inteira sem o restante (ex: "todos os models primeiro, depois todos os controllers").

Oposto de **Fatia Vertical**. Skills deste plugin **rejeitam** fatia horizontal porque:

- Nunca chega a ponta-a-ponta até tarde demais
- Esconde acoplamento até integração
- Em TDD, vira "escreve todos os testes, depois todo o código" (testes ruins, ancorados em comportamento imaginado)

Termo aparece neste plugin **somente para nomear o que evitar**.
