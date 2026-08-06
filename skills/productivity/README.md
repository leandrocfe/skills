# Productivity

Ferramentas gerais de workflow, não específicas de código.

## User-invoked

Alcançáveis apenas quando você digita (Claude Code: `disable-model-invocation: true`; Codex: `policy.allow_implicit_invocation: false` em `agents/openai.yaml`).

- **[grill-me](./grill-me/SKILL.md)** — Seja sabatinado sem dó sobre um plano ou design até cada ramo da design tree estar resolvido.
- **[handoff](./handoff/SKILL.md)** — Compacta a conversa atual em documento de handoff para outro agent continuar o trabalho.
- **[teach](./teach/SKILL.md)** — Ensine um novo skill ou conceito ao usuário em múltiplas sessões, usando o diretório atual como workspace de ensino stateful.
- **[to-questionnaire](./to-questionnaire/SKILL.md)** — Transforma uma decisão que você não responde sozinho num questionário Markdown para a pessoa que responde — preenchido async, ou junto numa reunião.
- **[wait-what](./wait-what/SKILL.md)** — Dispare no momento em que uma mensagem não pega. O agent a repropõe com o contexto que faltava, em português simples, usando o vocabulário do seu `CONTEXT.md`.

## Model-invoked

Alcançáveis por model ou usuário (rich trigger phrasing para o model poder alcançá-las).

- **[grilling](./grilling/SKILL.md)** — Entrevista o usuário sem dó sobre um plano, decisão ou ideia até cada ramo da design tree estar resolvido. O loop reutilizável por trás de `grill-me` e `grill-with-docs`.
- **[writing-for-agents](./writing-for-agents/SKILL.md)** — Escrever documentos que agents consomem: skills, AGENTS.md/CLAUDE.md, e qualquer doc que um agent alcance por um pointer.
