---
name: tdd
description: "Test-driven development com loop red-green-refactor. Use quando o usuário quiser construir features ou corrigir bugs usando TDD, mencionar \"red-green-refactor\", quiser testes de integração, ou pedir desenvolvimento test-first. Use when user wants to build features or fix bugs using TDD, mentions \"red-green-refactor\", wants integration tests, or asks for test-first development."
---

# Test-Driven Development

## Filosofia

**Princípio central**: Testes devem verificar comportamento através de interfaces públicas, não detalhes de implementação. O código pode mudar inteiramente; os testes não devem.

**Bons testes** são integration-style: exercitam caminhos de código reais através de APIs públicas. Descrevem _o que_ o sistema faz, não _como_. Um bom teste lê como uma especificação — "user can checkout with valid cart" te diz exatamente qual capacidade existe. Esses testes sobrevivem a refactors porque não se importam com estrutura interna.

**Testes ruins** são acoplados à implementação. Mockam colaboradores internos, testam métodos privados ou verificam por meios externos (tipo fazer query direto no database em vez de usar a interface). Sinal de alerta: seu teste quebra quando você refatora, mas o comportamento não mudou. Se você renomeia uma função interna e testes quebram, esses testes estavam testando implementação, não comportamento.

Veja [tests.md](tests.md) para exemplos e [mocking.md](mocking.md) para diretrizes de mocking.

## Anti-Pattern: Horizontal Slices

**NÃO escreva todos os testes primeiro, depois toda a implementação.** Isso é "horizontal slicing" — tratar RED como "escrever todos os testes" e GREEN como "escrever todo o código".

Isso produz **testes ruins**:

- Testes escritos em bulk testam comportamento _imaginado_, não _real_
- Você acaba testando o _shape_ das coisas (data structures, function signatures) em vez de comportamento user-facing
- Testes ficam insensíveis a mudanças reais — passam quando o comportamento quebra, falham quando o comportamento está bem
- Você passa do farol, se comprometendo com estrutura de teste antes de entender a implementação

**Abordagem correta**: Vertical slices via tracer bullets. Um teste → uma implementação → repete. Cada teste responde ao que você aprendeu do ciclo anterior. Como você acabou de escrever o código, sabe exatamente qual comportamento importa e como verificar.

```
ERRADO (horizontal):
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

CERTO (vertical):
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
  ...
```

## Workflow

### 1. Planning

Ao explorar a codebase, use o glossário de domínio do projeto para que nomes de testes e vocabulário de interface combinem com a linguagem do projeto, e respeite ADRs na área que está tocando.

Antes de escrever qualquer código:

- [ ] Confirmar com o usuário quais mudanças de interface são necessárias
- [ ] Confirmar com o usuário quais comportamentos testar (priorizar)
- [ ] Identificar oportunidades para [deep modules](deep-modules.md) (interface pequena, implementação funda)
- [ ] Desenhar interfaces para [testability](interface-design.md)
- [ ] Listar os comportamentos a testar (não passos de implementação)
- [ ] Obter aprovação do usuário no plano

Pergunte: "Como deve ser a interface pública? Quais comportamentos são mais importantes de testar?"

**Você não consegue testar tudo.** Confirme com o usuário exatamente quais comportamentos mais importam. Foque o esforço de teste em paths críticos e lógica complexa, não em todo edge case possível.

### 2. Tracer Bullet

Escreva UM teste que confirma UMA coisa sobre o sistema:

```
RED:   Escrever teste para o primeiro comportamento → teste falha
GREEN: Escrever código mínimo para passar → teste passa
```

Este é seu tracer bullet — prova que o caminho funciona end-to-end.

### 3. Loop Incremental

Para cada comportamento restante:

```
RED:   Escrever próximo teste → falha
GREEN: Código mínimo para passar → passa
```

Regras:

- Um teste por vez
- Só código suficiente para passar o teste atual
- Não antecipe testes futuros
- Mantenha testes focados em comportamento observável

### 4. Refactor

Depois de todos os testes passarem, procure por [candidatos a refactor](refactoring.md):

- [ ] Extrair duplicação
- [ ] Aprofundar módulos (mover complexidade para trás de interfaces simples)
- [ ] Aplicar princípios SOLID onde natural
- [ ] Considerar o que o novo código revela sobre o código existente
- [ ] Rodar testes após cada passo de refactor

**Nunca refatore enquanto RED.** Chegue a GREEN primeiro.

## Checklist Por Ciclo

```
[ ] Teste descreve comportamento, não implementação
[ ] Teste usa só interface pública
[ ] Teste sobreviveria a refactor interno
[ ] Código é mínimo para este teste
[ ] Sem features especulativas adicionados
```
