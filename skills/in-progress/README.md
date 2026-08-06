# In Progress

Beta. Estas skills são públicas de propósito — experimente e me conte o que quebrar. Ficam fora do plugin e do README top-level até graduarem para um bucket estável, não têm páginas de docs e podem mudar ou sumir sem aviso.

O plugin não entrega estas. Instale uma diretamente:

```bash
npx skills@latest add leandrocfe/skills --skill=<nome>
```

- **[loop-me](./loop-me/SKILL.md)** — Grill yourself into implementable workflow specs over multiple sessions, using the current directory as a stateful workspace. User-invoked.
- **[writing-beats](./writing-beats/SKILL.md)** — Shape an article as a journey of beats, choose-your-own-adventure style. Pick a starting beat, write only that beat, then pivot to the next, until the article reaches a natural end.
- **[writing-fragments](./writing-fragments/SKILL.md)** — Grilling session that mines you for fragments — heterogeneous nuggets of writing — and appends them to a single document as raw material for a future article.
- **[writing-shape](./writing-shape/SKILL.md)** — Take a markdown file of raw material and shape it into an article paragraph by paragraph, arguing format choices at each step.
- **[claude-handoff](./claude-handoff/SKILL.md)** — Hand the current conversation off to a fresh background agent that picks up the work immediately, seeded with a handoff summary via `claude --bg`. User-invoked.
- **[setup-ts-deep-modules](./setup-ts-deep-modules/SKILL.md)** — Conecta o dependency-cruiser a um repo TypeScript para que cada package seja um módulo profundo — implementação escondida em subpastas, alcançável só pelos arquivos de entrada, com testes exercitando-a por eles. User-invoked.
