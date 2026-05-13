# Quando Mockar

Mock só em **fronteiras do sistema**:

- APIs externas (payment, email, etc.)
- Databases (às vezes — prefira test DB)
- Tempo/aleatoriedade
- File system (às vezes)

Não mocke:

- Suas próprias classes/módulos
- Colaboradores internos
- Qualquer coisa que você controla

## Desenhando para Mockability

Em fronteiras do sistema, desenhe interfaces que são fáceis de mockar:

**1. Use dependency injection**

Passe dependências externas em vez de criá-las internamente:

```typescript
// Fácil de mockar
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// Difícil de mockar
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**2. Prefira interfaces estilo SDK em vez de fetchers genéricos**

Crie funções específicas para cada operação externa em vez de uma função genérica com lógica condicional:

```typescript
// BOM: Cada função é mockável independentemente
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};

// RUIM: Mockar exige lógica condicional dentro do mock
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

A abordagem SDK significa:
- Cada mock retorna um shape específico
- Sem lógica condicional no setup de teste
- Mais fácil ver quais endpoints um teste exercita
- Type safety por endpoint
