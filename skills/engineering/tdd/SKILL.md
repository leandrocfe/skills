---
name: tdd
description: Test-driven development. Use quando o usuário quiser construir features ou corrigir bugs test-first, mencionar "red-green-refactor", ou quiser testes de integração.
---

# Test-Driven Development

TDD é o loop red → green. Esta skill é a referência que faz esse loop produzir testes que valem a pena manter: o que é um bom teste, onde os testes ficam, os anti-patterns e as regras do loop. Toda seção vale em todo ciclo — consulte-as antes e durante o loop, não depois.

Ao explorar a codebase, leia `CONTEXT.md` (se existir) para que nomes de teste e vocabulário da interface batam com a linguagem de domínio do projeto, e respeite ADRs na área que você está tocando.

## O que é um bom teste

Testes verificam comportamento através de interfaces públicas, não detalhes de implementação. O código pode mudar por completo; os testes não deveriam. Um bom teste se lê como uma especificação — "user can checkout with valid cart" te diz exatamente qual capacidade existe — e sobrevive a refactors porque não se importa com estrutura interna.

Veja [tests.md](tests.md) para exemplos e [mocking.md](mocking.md) para diretrizes de mocking.

## Seams — onde os testes ficam

Um **seam** é a fronteira pública na qual você testa: a interface onde você observa comportamento sem enfiar a mão por dentro. Testes vivem em seams, nunca contra internals.

**Teste apenas em seams pré-acordados.** Antes de escrever qualquer teste, anote os seams sob teste e confirme-os com o usuário. Nenhum teste é escrito num seam não confirmado. Você não consegue testar tudo — acordar os seams antes é o que faz o esforço de teste cair nos critical paths e na lógica complexa, em vez de em todo edge case possível.

Pergunte: "Qual é a interface pública, e quais seams devemos testar?"

## Anti-patterns

- **Acoplado à implementação** — mocka colaboradores internos, testa métodos privados, ou verifica por um canal lateral (fazendo query no database em vez de usar a interface). O sinal: o teste quebra quando você refatora, mas o comportamento não mudou.
- **Tautológico** — a asserção recalcula o valor esperado do mesmo jeito que o código calcula (`expect(add(a, b)).toBe(a + b)`, um snapshot derivado à mão pelo mesmo caminho, uma constante afirmada igual a si mesma), então ele passa por construção e nunca consegue discordar do código. Valores esperados precisam vir de uma fonte de verdade independente — um literal sabidamente correto, um exemplo trabalhado à mão, a spec.
- **Horizontal slicing** — escrever todos os testes primeiro e depois toda a implementação. Testes escritos em bulk verificam comportamento _imaginado_: você testa o _shape_ das coisas em vez do comportamento user-facing, os testes ficam insensíveis a mudanças reais, e você se compromete com a estrutura de teste antes de entender a implementação. Trabalhe em **vertical slices** — um teste → uma implementação → repete, cada teste sendo um **tracer bullet** que responde ao que o ciclo anterior te ensinou.

## Regras do loop

- **Red antes de green.** Escreva primeiro o teste que falha, depois só o código suficiente para passá-lo. Não antecipe testes futuros nem adicione features especulativas.
- **Uma slice por vez.** Um seam, um teste, uma implementação mínima por ciclo.
- **Refactoring não faz parte do loop.** Ele pertence ao estágio de review (veja a skill `code-review`), não ao ciclo de implementação red → green.
