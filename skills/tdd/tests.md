# Testes Bons e Ruins

## Testes bons

**Estilo integração:** testa através de interfaces reais, não mocks de partes internas.

```typescript
// BOM: testa comportamento observável
test("usuário consegue finalizar compra com carrinho válido", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

Características:

- Testa comportamento que usuários/callers se importam
- Usa **somente** API pública
- Sobrevive a refators internos
- Descreve **O QUÊ**, não **COMO**
- Uma asserção lógica por teste

## Testes ruins

**Testes de detalhe de implementação:** acoplados à estrutura interna.

```typescript
// RUIM: testa detalhes de implementação
test("checkout chama paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

Sinais de alerta:

- Mock de colaboradores internos
- Teste de métodos privados
- Asserção em contagem/ordem de chamadas
- Teste quebra quando refatora **sem mudança de comportamento**
- Nome do teste descreve **COMO**, não **O QUÊ**
- Verifica via meios externos em vez de pela interface

```typescript
// RUIM: bypassa a interface pra verificar
test("createUser salva no banco", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// BOM: verifica via interface
test("createUser cria usuário recuperável", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

## O teste do refator

Pergunta-chave: **se eu refatorar o código sem mudar comportamento, o teste quebra?**

- Quebra → testa implementação. Reescreve.
- Continua passando → testa comportamento. Ótimo.

Este é o melhor filtro pra distinguir teste bom de ruim em prática.
