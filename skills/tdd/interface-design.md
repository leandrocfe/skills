# Design de Interface para Testabilidade

Interfaces boas tornam teste natural:

## 1. Aceite dependências, não crie

```typescript
// Testável
function processOrder(order, paymentGateway) { ... }

// Difícil de testar
function processOrder(order) {
  const gateway = new StripeGateway();
}
```

Em teste, passar gateway mockado é direto. Sem injeção, exige patch de import ou monkeypatch.

## 2. Retorne resultados, não cause efeitos

```typescript
// Testável
function calculateDiscount(cart): Discount { ... }

// Difícil de testar
function applyDiscount(cart): void {
  cart.total -= discount;
}
```

Função pura retornando valor: assertar o retorno. Função que muta: precisa olhar estado depois — frágil.

## 3. Superfície de área pequena

- Menos métodos = menos testes
- Menos parâmetros = setup de teste mais simples
- Menos overloads = casos de teste mais previsíveis

## 4. Tipos que forçam estado válido

```typescript
// Ruim: precisa testar combinação inválida
type Order = {
  status: "pending" | "paid" | "shipped";
  paidAt?: Date;
  shippedAt?: Date;
};

// Bom: tipo torna estado inválido impossível de representar
type Order =
  | { status: "pending" }
  | { status: "paid"; paidAt: Date }
  | { status: "shipped"; paidAt: Date; shippedAt: Date };
```

Discriminated union elimina classe inteira de testes de "e se status é pending mas paidAt está presente?".

## 5. Erros tipados, não exceções genéricas

```typescript
// Ruim: caller adivinha o que pode dar errado
function chargeCard(amount): Promise<void> {
  // pode lançar várias coisas
}

// Bom: tipo de retorno declara possibilidades
type ChargeResult =
  | { ok: true; transactionId: string }
  | { ok: false; reason: "insufficient_funds" | "card_declined" | "network_error" };

function chargeCard(amount): Promise<ChargeResult> { ... }
```

Testes podem assertar reasons específicos. Try/catch genérico desaparece.

## 6. Async claro, sem callbacks aninhados

```typescript
// Ruim: callback hell, difícil de testar fluxo
function processOrder(order, cb) {
  validate(order, (err, valid) => {
    if (err) return cb(err);
    charge(order, (err, charge) => {
      if (err) return cb(err);
      ship(order, cb);
    });
  });
}

// Bom: async/await, fluxo linear, fácil de mockar cada step
async function processOrder(order) {
  await validate(order);
  await charge(order);
  await ship(order);
}
```

## Quando descobrir que a interface está errada via teste

Sinais durante TDD:

- Setup de teste é maior que o teste em si → módulo precisa de menos dependências
- Mock complicado pra fazer função funcionar → falta DI
- Não consegue assertar resultado sem ler estado interno → falta retornar valor
- Mesmo cenário precisa de 5 testes pra cobrir → tipo permite estados inválidos

**Não force o teste.** Refatore a interface. TDD revela design — escute.
