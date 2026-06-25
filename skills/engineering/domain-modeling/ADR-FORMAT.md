# ADR Format

ADRs vivem em `docs/adr/` e usam numeração sequencial: `0001-slug.md`, `0002-slug.md`, etc.

Crie o diretório `docs/adr/` de forma lazy — só quando o primeiro ADR for necessário.

## Template

```md
# {Título curto da decisão}

{1-3 frases: qual o contexto, o que decidimos e por quê.}
```

Isso é tudo. Um ADR pode ser um único parágrafo. O valor está em registrar *que* uma decisão foi tomada e *por quê* — não em preencher seções.

## Seções opcionais

Só inclua estas quando adicionarem valor genuíno. A maioria dos ADRs não vai precisar.

- **Status** no frontmatter (`proposed | accepted | deprecated | superseded by ADR-NNNN`) — útil quando decisões são revisitadas
- **Considered Options** — só quando as alternativas rejeitadas valem a pena lembrar
- **Consequences** — só quando efeitos downstream não-óbvios precisarem ser destacados

## Numeração

Escaneie `docs/adr/` pelo maior número existente e incremente em um.

## Quando oferecer um ADR

Todas as três condições abaixo precisam ser verdadeiras:

1. **Difícil de reverter** — o custo de mudar de ideia depois é significativo
2. **Surpreendente sem contexto** — um leitor futuro vai olhar o código e se perguntar "por que diabos eles fizeram assim?"
3. **Resultado de um trade-off real** — havia alternativas genuínas e você escolheu uma por razões específicas

Se uma decisão é fácil de reverter, pule — você só vai revertê-la. Se não é surpreendente, ninguém vai se perguntar o porquê. Se não havia alternativa real, não há nada para registrar além de "fizemos o óbvio".

### O que qualifica

- **Forma arquitetural.** "Estamos usando um monorepo." "O write model é event-sourced, o read model é projetado em Postgres."
- **Padrões de integração entre contextos.** "Ordering e Billing se comunicam via domain events, não HTTP síncrono."
- **Escolhas tecnológicas que carregam lock-in.** Banco de dados, message bus, provedor de auth, alvo de deploy. Não toda biblioteca — só as que levariam um trimestre para trocar.
- **Decisões de boundary e escopo.** "Dados de Customer são de propriedade do contexto Customer; outros contextos referenciam apenas por ID." Os "não" explícitos são tão valiosos quanto os "sim".
- **Desvios deliberados do caminho óbvio.** "Estamos usando SQL manual em vez de ORM porque X." Qualquer coisa onde um leitor razoável assumiria o oposto. Isso impede o próximo engenheiro de "consertar" algo que foi intencional.
- **Constraints não visíveis no código.** "Não podemos usar AWS por requisitos de compliance." "Tempos de resposta devem ser abaixo de 200ms por causa do contrato da API do parceiro."
- **Alternativas rejeitadas quando a rejeição não é óbvia.** Se você considerou GraphQL e escolheu REST por razões sutis, registre — senão alguém vai sugerir GraphQL de novo em seis meses.
