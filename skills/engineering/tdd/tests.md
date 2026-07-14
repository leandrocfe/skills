# Testes Bons e Ruins

## Testes Bons

**Integration-style**: Testam através de interfaces reais, não mocks de partes internas.

```typescript
// BOM: Testa comportamento observável
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

Características:

- Testa comportamento que usuários/callers se importam
- Usa só API pública
- Sobrevive a refactors internos
- Descreve O QUE, não COMO
- Uma asserção lógica por teste

## Testes Ruins

**Testes de detalhe de implementação**: Acoplados à estrutura interna.

```typescript
// RUIM: Testa detalhes de implementação
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

Red flags:

- Mockar colaboradores internos
- Testar métodos privados
- Asserir contagem/ordem de calls
- Teste quebra ao refatorar sem mudança de comportamento
- Nome do teste descreve COMO, não O QUE
- Verificar por meios externos em vez da interface

```typescript
// RUIM: Pula a interface para verificar
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// BOM: Verifica através da interface
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

**Testes tautológicos**: O valor esperado reenuncia a implementação, então o teste passa por construção.

```typescript
// RUIM: O valor esperado é recalculado do mesmo jeito que o código calcula
test("calculateTotal sums line items", () => {
  const items = [{ price: 10 }, { price: 5 }];
  const expected = items.reduce((sum, i) => sum + i.price, 0);
  expect(calculateTotal(items)).toBe(expected);
});

// BOM: O valor esperado é um literal independente e conhecido
test("calculateTotal sums line items", () => {
  expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```
