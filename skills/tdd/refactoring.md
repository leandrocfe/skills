# Candidatos a Refator

Após ciclo TDD (verde), olhar para:

- **Duplicação** → Extrair função/classe
- **Métodos longos** → Quebrar em helpers privados (manter testes na interface pública)
- **Módulos rasos** → Combinar ou aprofundar (ver [deep-modules.md](deep-modules.md))
- **Feature envy** → Mover lógica pra onde o dado vive
- **Primitive obsession** → Introduzir value objects
- **Código existente** que o código novo revela como problemático

## Duplicação

Três pontos parecidos = sinal pra extrair. Dois ainda é coincidência.

```typescript
// Antes
function formatUserName(user) {
  return `${user.firstName.trim()} ${user.lastName.trim()}`;
}
function formatCustomerName(customer) {
  return `${customer.firstName.trim()} ${customer.lastName.trim()}`;
}
function formatAuthorName(author) {
  return `${author.firstName.trim()} ${author.lastName.trim()}`;
}

// Depois
function formatPersonName({ firstName, lastName }) {
  return `${firstName.trim()} ${lastName.trim()}`;
}
```

Cuidado: **duplicação acidental** (mesmas linhas, conceitos diferentes) não deve ser unificada. Vai te morder depois quando um dos conceitos evoluir.

## Métodos longos

Sinal: comentários separando blocos. Se você escreveu `// validar entrada`, `// processar`, `// salvar`, são 3 helpers.

```typescript
// Antes
function processOrder(order) {
  // validar entrada
  if (!order.items?.length) throw new Error("vazio");
  // ...10 linhas
  
  // processar
  const total = calculateTotal(order);
  // ...8 linhas
  
  // salvar
  return db.orders.insert({ ...order, total });
}

// Depois
function processOrder(order) {
  validateOrder(order);
  const total = calculateTotal(order);
  return saveOrder({ ...order, total });
}
```

Testes ficam na interface pública (`processOrder`). Helpers ficam privados, sem teste próprio.

## Feature envy

Função que mexe mais em dado de **outro objeto** do que do próprio. Sinal: muitos `.` em fila.

```typescript
// Cheiroso (feature envy de User)
function canUserOrder(order, user) {
  return user.account.subscription.status === "active"
    && user.account.balance > order.total;
}

// Melhor
class User {
  canAffordAndIsActive(amount: number): boolean {
    return this.subscription.isActive() && this.account.balance > amount;
  }
}
function canUserOrder(order, user) {
  return user.canAffordAndIsActive(order.total);
}
```

Lógica foi pra onde o dado vive.

## Primitive obsession

Passar `string`, `number`, `boolean` por toda parte vira bug.

```typescript
// Cheiroso
function transfer(from: string, to: string, amount: number, currency: string) { ... }
// Caller: transfer(userId, accountId, amount, "USD") — fácil trocar args

// Melhor
class Money {
  constructor(public amount: number, public currency: Currency) {}
}
function transfer(from: AccountId, to: AccountId, money: Money) { ... }
```

Compilador agora previne `transfer(amount, userId, accountId, ...)`.

## Quando o código novo revela problema no antigo

Caso comum: ciclo TDD faz você notar que função antiga já tinha um cheiro.

**Não pare o ciclo atual.** Termine o ciclo (verde + commit). Anote pra próximo ciclo.

Próximo ciclo escolhe: corrigir o cheiro antigo (com teste de regressão) **ou** continuar feature e refatorar depois.

Não misture dois ciclos.

## Sempre rodar testes entre passos

Refator é "mudança sem mudar comportamento". A garantia disso é **teste passando**.

- Rode testes depois de cada passo não-trivial
- Se quebrar, **desfaça**. Não tente "consertar o teste".
- Se for refator complexo, commit intermediário a cada step seguro

## Nunca refatorar no vermelho

Se algum teste está vermelho, **acabe o verde primeiro**. Refator no vermelho:

- Não dá feedback (você não sabe se está progredindo)
- Mistura duas atividades (corrigir + limpar)
- Quebra a disciplina do ciclo
