# Quando Mockar

Mock **somente em fronteiras de sistema**:

- APIs externas (pagamento, email, etc.)
- Bancos de dados (às vezes — prefira banco de teste)
- Tempo / aleatoriedade
- Sistema de arquivos (às vezes)

Não mock:

- Suas próprias classes/módulos
- Colaboradores internos
- Qualquer coisa que você controla

## Designing for Mockability

Em fronteiras de sistema, desenhe interfaces que **são fáceis de mockar**:

### 1. Use dependency injection

Passa dependências externas em vez de criar internamente:

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

### 2. Prefira interfaces SDK-style sobre fetchers genéricos

Crie funções específicas pra cada operação externa em vez de uma função genérica com lógica condicional:

```typescript
// BOM: cada função mockável independentemente
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};

// RUIM: mockar exige lógica condicional dentro do mock
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

Abordagem SDK significa:

- Cada mock retorna **uma forma específica**
- **Sem lógica condicional** no setup do teste
- Mais fácil ver quais endpoints o teste exercita
- Type safety por endpoint

## Quando mockar tempo

Tempo é fronteira de sistema. Sempre injete relógio:

```typescript
// Testável
function isExpired(expiresAt: Date, now: () => Date) {
  return now() > expiresAt;
}

// Difícil de testar
function isExpired(expiresAt: Date) {
  return new Date() > expiresAt;
}
```

Em teste:

```typescript
const fixedNow = () => new Date("2026-01-15T12:00:00Z");
expect(isExpired(new Date("2026-01-14"), fixedNow)).toBe(true);
```

Vale o mesmo pra randomness, UUID generation, IDs, timestamps.

## Quando NÃO mockar banco

Prefira banco real em **sqlite em memória** ou **container de teste**:

- Pega bugs de SQL real (NULL handling, transactions, tipos)
- Não engana com mocks que "sempre retornam o esperado"
- Permite teste de integração de verdade

Quando aceitar mock de banco:

- Teste unitário focado em lógica pura (sem acesso a dado)
- Performance crítica (1000 testes que rodam em CI)
- Banco caro de setar up (raro)

## Heurística final

Pergunta: **se eu mockar isso, e a implementação real estiver bugada, meu teste pega?**

- Sim → mock ok
- Não → mock perigoso. Considere alternativa real.
