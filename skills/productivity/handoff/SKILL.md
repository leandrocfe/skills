---
name: handoff
description: Compacta a conversa atual em um documento de handoff para outro agente continuar o trabalho. Use when user wants to hand off work to a fresh agent, save context for later, or mentions handoff.
argument-hint: "Para que a próxima sessão vai ser usada?"
---

Escreva um documento de handoff resumindo a conversa atual para que um agente novo possa continuar o trabalho. Salve num caminho gerado por `mktemp -t handoff-XXXXXX.md` (leia o arquivo antes de escrever nele).

Sugira as skills a serem usadas, se houver, pela próxima sessão.

Não duplique conteúdo já capturado em outros artefatos (PRDs, planos, ADRs, issues, commits, diffs). Referencie por caminho ou URL.

Se o usuário passou argumentos, trate-os como descrição do que a próxima sessão vai focar e ajuste o doc.
