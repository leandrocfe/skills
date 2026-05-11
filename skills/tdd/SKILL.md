---
name: tdd
description: "Implementa feature ou corrige bug usando ciclo red-green-refactor com Fatias Verticais, testes de integração reais (não mock-everything) e commits pequenos por ciclo. Use quando usuário pedir \"usar TDD\", \"test-driven development\", \"fazer com testes primeiro\", \"red-green-refactor\", ou invocar /tdd. Triggers: \"TDD\", \"test first\", \"red green refactor\", \"integration test\"."
---

# tdd

Test-Driven Development feito com disciplina: 1 teste por vez, falha primeiro, código mínimo, refatora, commita. Combate o anti-padrão de escrever 200 linhas de produção e depois testar (ou pior: nunca testar).

## <o-que-fazer>

### Antes de qualquer código

Confirme:

1. **Você entende o comportamento esperado?** Se não, pare. Faça [grill-me](../grill-me/SKILL.md) ou peça exemplos concretos ao usuário (entrada → saída).
2. **Existe Fatia Vertical mínima?** TDD opera em fatias finas. "Implementar autenticação inteira" é fatia horizontal e gigante. "Aceitar `POST /login` com email/senha válidos retornando 200 + token" é fatia vertical mínima.
3. **Qual é o primeiro teste que falha?** Não comece com "felizes paths" abstratos. Comece com **o teste mais simples que faria você escrever a primeira linha útil**.

### O ciclo: Red → Green → Refactor

#### Red: escreve teste que falha

- Teste de **integração** sempre que viável (atravessa camadas reais)
- Mock só componentes que **realmente** precisam ser isolados (rede externa, relógio, randomness)
- Rode o teste. **Confirme que falha pelo motivo certo** (não por erro de sintaxe, não por config quebrado)
- Mensagem de falha deve ser legível e apontar para o comportamento ausente

```
NÃO: teste passa por acidente (assert sempre verdadeiro)
NÃO: teste falha por erro de import (ainda não está testando comportamento)
SIM: teste falha porque o comportamento não existe ainda
```

#### Green: código mínimo para passar

- Escreva **o suficiente** para fazer o teste virar verde. Nada além.
- Resista a adicionar "while I'm here" — outras features, otimização, refatoração
- Hardcode é permitido neste passo. Vai virar coisa real no próximo ciclo
- Rode **todos** os testes. Confirme que nada quebrou.

#### Refactor: limpa sem mudar comportamento

- Renomeia, extrai função, remove duplicação
- **Sem novos comportamentos**. Sem novos testes.
- Rode testes a cada mudança não-trivial
- Se a refatoração revela que o design tá errado, **pare e converse** antes de continuar

#### Commit

- 1 commit por ciclo completo (red + green + refactor)
- Mensagem descreve o **comportamento** adicionado, não as mudanças mecânicas

```
feat: aceita POST /login com credenciais válidas
```

Não:
```
chore: adiciona arquivo e testes
```

### Próximo ciclo

Volte para Red com o próximo teste. Boa heurística para escolher o próximo:

- **Caso de erro adjacente** ao que acabou de passar (`POST /login` com senha errada → 401)
- **Caso de borda óbvio** (email vazio, formato inválido)
- **Próxima fatia vertical** se a anterior está completa

### Quando parar

Pare quando:

- Não consegue pensar em mais 1 teste que adicionaria valor
- Critérios de aceitação do PRD/issue estão cobertos
- Cobertura natural está alta sem chase de número artificial

## <info-de-apoio>

### Anti-padrões

- **NÃO escreva 5 testes de uma vez.** 1 por ciclo. Mais que isso e você está adivinhando o design.
- **NÃO mock tudo.** Mock vira "teste passa, produção quebra". Banco real (sqlite em memória), HTTP real (servidor de teste), arquivo real (tmpdir). Mock só o que **tem que** ser isolado.
- **NÃO fatie horizontal.** "Implementar todos os models primeiro" não é TDD — é design upfront disfarçado.
- **NÃO refatore no green.** Refactor tem passo próprio. Green é só passar o teste.
- **NÃO ignore teste vermelho "vou consertar depois".** Vermelho fica vermelho até virar verde. Sem stash, sem skip.
- **NÃO escreva teste **depois** do código.** Isso é "testes existem", não TDD.

### Quando TDD não vale a pena

- **Spike / prototype:** explorando se uma abordagem funciona. Use [prototype mindset] sem testes, descarte depois.
- **Mudança trivial não-comportamental:** rename, mover arquivo, formatação.
- **UI puramente visual sem lógica:** teste manual / screenshot test é melhor.

Tudo o mais: TDD vale a pena, mesmo (especialmente) quando parece chato.

### Sobre cobertura

Cobertura é resultado, não objetivo. TDD bem-feito chega a cobertura alta naturalmente. Se você está mexendo em código e não tem teste falhando antes, você está fora do ciclo.

### Sobre mocks (resumo do meu critério)

Mock **sempre**:
- Chamadas HTTP para APIs externas pagas/com rate limit
- Relógio (`Date.now`, `setTimeout`)
- Randomness (`Math.random`, UUID generation)
- Sistemas externos não-controláveis (Stripe, SendGrid)

Mock **às vezes** (avalie caso a caso):
- Banco de dados — prefira sqlite ou container real
- Fila de jobs — prefira instância de teste
- Filesystem — prefira tmpdir

Nunca mock:
- Código que você está testando
- Validação que é parte do comportamento
- Lógica de domínio

### Exemplo: começando uma feature

Feature: usuário pode criar projeto com nome e descrição.

**Ciclo 1**
- Red: `POST /projects` com nome válido retorna 201 + projeto criado no DB
- Green: handler mínimo que insere e responde
- Refactor: nenhum (código já mínimo)
- Commit: `feat: aceita criação de projeto via POST /projects`

**Ciclo 2**
- Red: `POST /projects` sem nome retorna 400
- Green: adiciona validação
- Refactor: extrai validação para função pura
- Commit: `feat: rejeita projeto sem nome com 400`

**Ciclo 3**
- Red: nome com mais de 200 chars retorna 400
- Green: adiciona limite na validação
- Refactor: parametriza limite via constante
- Commit: `feat: limita nome de projeto a 200 caracteres`

E assim por diante.

## Cross-references

- [setup-leandrocfe-skills](../setup-leandrocfe-skills/SKILL.md) — rodar antes do TDD pra configurar docs de domínio
- [grill-me](../grill-me/SKILL.md) — use antes do TDD se o comportamento não está claro
- [to-prd](../to-prd/SKILL.md) — TDD assume que você sabe os critérios de aceitação; PRD os formaliza
- [diagnose](../diagnose/SKILL.md) — para bugs, comece com teste reproducível (red) antes de investigar
- [`tests.md`](tests.md) — testes bons vs ruins, com exemplos
- [`mocking.md`](mocking.md) — quando e como mockar
- [`deep-modules.md`](deep-modules.md) — interface pequena + implementação grande
- [`interface-design.md`](interface-design.md) — desenhar pra testabilidade
- [`refactoring.md`](refactoring.md) — candidatos a refator no passo refactor
- [`CONTEXT.md`](../../CONTEXT.md) — definição de Fatia Vertical
