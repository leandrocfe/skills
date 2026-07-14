# Engineering

Skills que uso todo dia para trabalho com código.

## User-invoked

Alcançáveis apenas quando você digita (`disable-model-invocation: true`).

- **[ask-matt](./ask-matt/SKILL.md)** — Pergunte qual skill ou fluxo encaixa na sua situação. Um router sobre as skills deste repo.
- **[grill-with-docs](./grill-with-docs/SKILL.md)** — Sessão de sabatina que também constrói o domain model do seu projeto, afiando terminologia e atualizando `CONTEXT.md` e ADRs inline.
- **[triage](./triage/SKILL.md)** — Move issues e PRs externos através de uma máquina de estados de roles de triage.
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)** — Escaneia uma codebase em busca de oportunidades de deepening, apresenta como relatório HTML visual e depois sabatina a escolhida.
- **[setup-leandrocfe-skills](./setup-leandrocfe-skills/SKILL.md)** — Configura este repo para as engineering skills (issue tracker, triage labels, layout de docs de domínio). Rode uma vez por repo.
- **[to-spec](./to-spec/SKILL.md)** — Transforma a conversa atual em uma spec e publica no issue tracker.
- **[to-tickets](./to-tickets/SKILL.md)** — Quebra qualquer plano, spec ou conversa em tickets tracer-bullet, cada um declarando suas blocking edges — texto num arquivo local, ou links de blocking nativos num tracker de verdade.
- **[wayfinder](./wayfinder/SKILL.md)** — Planeja um pedaço enorme de trabalho — maior do que uma sessão de agent segura — como um mapa compartilhado de tickets de investigação no issue tracker, resolvidos um por vez até o caminho até o destino ficar claro.
- **[implement](./implement/SKILL.md)** — Implementa um pedaço de trabalho a partir de uma spec ou conjunto de tickets, conduzindo `/tdd` e fechando com `/code-review`.

## Model-invoked

Alcançáveis por model ou usuário (rich trigger phrasing para o model poder alcançá-las).

- **[prototype](./prototype/SKILL.md)** — Constrói um protótipo descartável para responder a uma pergunta de design: um app terminal executável para estado/lógica, ou várias variações de UI alternáveis.
- **[diagnosing-bugs](./diagnosing-bugs/SKILL.md)** — Loop disciplinado de diagnóstico para bugs difíceis e regressões de performance: reproduzir → minimizar → hipotetizar → instrumentar → corrigir → regression-test.
- **[research](./research/SKILL.md)** — Investiga uma pergunta contra fontes primárias de alta confiança e registra os achados como um Markdown citado no repo, rodando como background agent.
- **[tdd](./tdd/SKILL.md)** — Test-driven development com o loop red → green. Constrói features ou corrige bugs uma vertical slice por vez, em seams pré-acordados.
- **[domain-modeling](./domain-modeling/SKILL.md)** — Constrói e afia ativamente o modelo de domínio de um projeto — desafia termos, stress-testa com cenários, atualiza `CONTEXT.md` e ADRs inline.
- **[codebase-design](./codebase-design/SKILL.md)** — Disciplina e vocabulário compartilhados para projetar deep modules: interfaces pequenas, seams limpos, testáveis através da interface.
- **[code-review](./code-review/SKILL.md)** — Revisão em dois eixos do diff desde um ponto fixo: **Standards** (segue os padrões do repo, mais uma baseline de code smells do Fowler?) e **Spec** (implementa fielmente a issue/spec de origem?), rodando como sub-agents paralelos.
- **[resolving-merge-conflicts](./resolving-merge-conflicts/SKILL.md)** — Loop para resolver um merge ou rebase em andamento com conflitos.
