# Módulos Profundos

De "A Philosophy of Software Design" (John Ousterhout):

**Módulo profundo** = interface pequena + implementação grande

```
┌─────────────────────┐
│   Interface pequena │  ← Poucos métodos, params simples
├─────────────────────┤
│                     │
│                     │
│  Implementação      │  ← Lógica complexa escondida
│  profunda           │
│                     │
└─────────────────────┘
```

**Módulo raso** = interface grande + implementação pequena (**evitar**)

```
┌─────────────────────────────────┐
│       Interface grande          │  ← Muitos métodos, params complexos
├─────────────────────────────────┤
│  Implementação fina             │  ← Só passa adiante
└─────────────────────────────────┘
```

## Por que módulo profundo importa

- **Esconde complexidade.** Quem consome não precisa entender o interior.
- **Reduz superfície de teste.** Poucos métodos = poucos testes.
- **Resiste a mudança.** Implementação pode evoluir sem afetar callers.
- **Aumenta reuso.** Interface simples cabe em mais cenários.

## Sinais de módulo raso

- Cada método interno é exposto na interface pública
- Parâmetros são `options: { ... }` com 15 chaves
- Documentação da interface > documentação do interior
- Caller precisa orquestrar várias chamadas pra fazer algo simples
- "Não me lembro qual ordem chamar essas 4 funções"

## Sinais de módulo profundo

- Uma função pública faz coisa que internamente toma 200 linhas
- Parâmetros são poucos e diretos (`order: Order`, não 8 flags)
- Implementação muda sem quebrar testes/callers
- Caller diz **o que quer**, não **como fazer**

## Quando desenhar

Ao desenhar interface (ou refator), pergunte:

- Dá pra reduzir número de métodos?
- Dá pra simplificar parâmetros?
- Dá pra esconder mais complexidade dentro?

## Exemplo: rasa → profunda

**Antes (raso):**

```typescript
const orderService = {
  validateCart(cart): ValidationResult { ... },
  calculateTotal(cart): number { ... },
  chargePayment(amount, method): PaymentResult { ... },
  createOrder(cart, total, payment): Order { ... },
  sendConfirmationEmail(order): void { ... },
  notifyWarehouse(order): void { ... },
};

// Caller orquestra tudo:
const validation = orderService.validateCart(cart);
if (!validation.ok) return validation.error;
const total = orderService.calculateTotal(cart);
const payment = await orderService.chargePayment(total, method);
if (!payment.success) return payment.error;
const order = orderService.createOrder(cart, total, payment);
orderService.sendConfirmationEmail(order);
orderService.notifyWarehouse(order);
```

**Depois (profundo):**

```typescript
const orderService = {
  placeOrder(cart: Cart, payment: PaymentMethod): Promise<Order | OrderError> { ... },
};

// Caller diz o que quer:
const result = await orderService.placeOrder(cart, payment);
```

Toda a orquestração foi pra dentro. Interface diminuiu. Caller ficou simples.

## Cuidado: profundidade não é monolitismo

Módulo profundo **encapsula** complexidade, não **acumula**. Dentro do módulo, ainda há decomposição — só que é detalhe interno.

Sinal de monolitismo (ruim):

- Implementação de 5000 linhas em um arquivo só
- Mudança simples exige entender o módulo inteiro
- Testes internos impossíveis

Profundidade boa:

- Interface pequena, lógica organizada internamente
- Sub-módulos privados podem existir
- Refator interno não vaza pra fora
