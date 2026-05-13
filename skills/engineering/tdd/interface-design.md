# Interface Design para Testability

Boas interfaces tornam teste natural:

1. **Aceite dependências, não crie**

   ```typescript
   // Testável
   function processOrder(order, paymentGateway) {}

   // Difícil de testar
   function processOrder(order) {
     const gateway = new StripeGateway();
   }
   ```

2. **Retorne resultados, não produza side effects**

   ```typescript
   // Testável
   function calculateDiscount(cart): Discount {}

   // Difícil de testar
   function applyDiscount(cart): void {
     cart.total -= discount;
   }
   ```

3. **Superfície pequena**
   - Menos métodos = menos testes necessários
   - Menos params = setup de teste mais simples
