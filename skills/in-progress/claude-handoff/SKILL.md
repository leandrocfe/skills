---
name: claude-handoff
description: Passa a conversa atual para um background agent novo, que retoma o trabalho imediatamente.
argument-hint: "Para que a próxima sessão será usada?"
disable-model-invocation: true
---

Escreva um resumo de handoff da conversa atual para que um agent novo consiga continuar o trabalho. Em vez de salvá-lo, lance um background agent semeado com o resumo como prompt: `claude --bg --name "<nome descritivo>" "<resumo do handoff>"`. Ele começa no diretório de trabalho atual e retorna imediatamente; o usuário o gerencia com `claude agents`.

Sempre passe `-n`/`--name` com um nome descritivo (ex.: `--name "Corrigir bug de login"`) — ele define o nome de exibição mostrado na lista de jobs, no seletor de sessões e no título do terminal.

Inclua uma seção "skills sugeridas" no resumo, indicando as skills que o agent deve invocar.

Não duplique conteúdo já capturado em outros artefatos (specs, planos, ADRs, issues, commits, diffs). Referencie-os por caminho ou URL.

Redija fora qualquer informação sensível, como API keys, senhas ou informação pessoal identificável — o resumo vira o prompt do agent.

Se o usuário passou argumentos, trate-os como uma descrição do foco da próxima sessão e ajuste o resumo de acordo.
