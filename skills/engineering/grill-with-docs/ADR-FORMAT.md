# ADR Format

ADRs vivem em `docs/adr/` e usam numeração sequencial: `0001-slug.md`, `0002-slug.md`, etc.

Crie o diretório `docs/adr/` com preguiça — só quando o primeiro ADR for necessário.

## Template

```md
# {Título curto da decisão}

{1-3 frases: qual o contexto, o que decidimos e por quê.}
```

É isso. Um ADR pode ser um único parágrafo. O valor está em registrar *que* uma decisão foi tomada e *por quê* — não em preencher seções.

## Seções opcionais

Inclua apenas quando agregam valor genuíno. A maioria dos ADRs não vai precisar.

- **Status** no frontmatter (`proposed | accepted | deprecated | superseded by ADR-NNNN`) — útil quando decisões são revisitadas
- **Considered Options** — só quando as alternativas rejeitadas valem ser lembradas
- **Consequences** — só quando efeitos downstream não-óbvios precisam ser destacados

## Numeração

Varra `docs/adr/` pelo maior número existente e incremente em um.

## Quando oferecer um ADR

Os três precisam ser verdade:

1. **Difícil de reverter** — o custo de mudar de ideia depois é significativo
2. **Surpreendente sem contexto** — um leitor futuro vai olhar o código e se perguntar "por que diabos fizeram desse jeito?"
3. **Resultado de um trade-off real** — havia alternativas genuínas e você escolheu uma por razões específicas

Se uma decisão for fácil de reverter, pule — você só vai reverter depois. Se não é surpreendente, ninguém vai se perguntar por quê. Se não havia alternativa real, não há nada a registrar além de "fizemos o óbvio".

### O que qualifica

- **Shape arquitetural.** "Usamos monorepo." "O write model é event-sourced, o read model é projetado em Postgres."
- **Padrões de integração entre contextos.** "Ordering e Billing comunicam via domain events, não HTTP síncrono."
- **Escolhas de tecnologia com lock-in.** Database, message bus, auth provider, deployment target. Não toda lib — só as que tomariam um trimestre para trocar.
- **Decisões de fronteira e escopo.** "Customer data é dono pelo Customer context; outros contextos referenciam por ID só." Os "não-s" explícitos valem tanto quanto os "sim-s".
- **Desvios deliberados do caminho óbvio.** "Usamos SQL manual em vez de ORM porque X." Qualquer coisa em que um leitor razoável assumiria o oposto. Isso impede que o próximo engenheiro "conserte" algo que era deliberado.
- **Constraints não visíveis no código.** "Não podemos usar AWS por requisitos de compliance." "Tempos de resposta precisam ficar abaixo de 200ms por causa do partner API contract."
- **Alternativas rejeitadas quando a rejeição é não-óbvia.** Se considerou GraphQL e escolheu REST por razões sutis, registre — senão alguém vai sugerir GraphQL de novo em seis meses.
