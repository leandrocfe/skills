---
name: tdd
description: Test-driven development. Use quando o usuário quiser construir features ou corrigir bugs test-first, mencionar "red-green-refactor", ou quiser testes de integração.
---

# Test-Driven Development

## Filosofia

**Princípio central**: Testes devem verificar comportamento através de interfaces públicas, não detalhes de implementação. O código pode mudar completamente; os testes não devem.

**Bons testes** são integration-style: exercitam caminhos reais de código através de APIs públicas. Descrevem _o que_ o sistema faz, não _como_. Um bom teste lê como uma especificação — "user can checkout with valid cart" te diz exatamente qual capacidade existe. Esses testes sobrevivem a refactors porque não se importam com estrutura interna.

**Testes ruins** são acoplados à implementação. Mockam colaboradores internos, testam métodos privados ou verificam por meios externos (como fazer query direto no database em vez de usar a interface). Sinal de alerta: seu teste quebra quando você refatora, mas o comportamento não mudou. Se você renomeia uma função interna e testes quebram, esses testes estavam testando implementação, não comportamento.

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

### 1. Planejamento

Ao explorar a codebase, leia `CONTEXT.md` (se existir) para que nomes de teste e vocabulário da interface batam com a linguagem de domínio do projeto, e respeite ADRs na área que você está tocando.

Antes de escrever qualquer código:

- [ ] Confirme com o usuário quais mudanças de interface são necessárias
- [ ] Confirme com o usuário quais comportamentos testar (priorize)
- [ ] Identifique oportunidades de deep modules (interface pequena, implementação profunda) — rode a skill `/codebase-design` para o vocabulário e os checks de testabilidade
- [ ] Liste os comportamentos a testar (não passos de implementação)
- [ ] Obtenha aprovação do usuário no plano

Pergunte: "Como a interface pública deve ficar? Quais comportamentos são mais importantes de testar?"

**Você não consegue testar tudo.** Confirme com o usuário exatamente quais comportamentos importam mais. Foque esforço de teste em critical paths e lógica complexa, não em todo edge case possível.

### 2. Tracer Bullet

Escreva UM teste que confirma UMA coisa sobre o sistema:

```
RED:   Escreva teste para o primeiro comportamento → teste falha
GREEN: Escreva código mínimo para passar → teste passa
```

Este é seu tracer bullet — prova que o caminho funciona end-to-end.

### 3. Loop Incremental

Para cada comportamento restante:

```
RED:   Escreva próximo teste → falha
GREEN: Código mínimo para passar → passa
```

Regras:

- Um teste por vez
- Só código suficiente para passar o teste atual
- Não antecipe testes futuros
- Mantenha testes focados em comportamento observável

### 4. Refactor

Depois que todos os testes passarem, procure por [candidatos de refactor](refactoring.md):

- [ ] Extraia duplicação
- [ ] Aprofunde módulos (mova complexidade atrás de interfaces simples)
- [ ] Aplique princípios SOLID onde natural
- [ ] Considere o que o novo código revela sobre código existente
- [ ] Rode testes depois de cada passo de refactor

**Nunca refatore enquanto RED.** Chegue em GREEN primeiro.

## Checklist por Ciclo

```
[ ] Teste descreve comportamento, não implementação
[ ] Teste usa apenas interface pública
[ ] Teste sobreviveria a um refactor interno
[ ] Código é mínimo para este teste
[ ] Nenhuma feature especulativa adicionada
```
