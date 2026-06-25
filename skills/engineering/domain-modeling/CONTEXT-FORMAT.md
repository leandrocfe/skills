# CONTEXT.md Format

## Estrutura

```md
# {Nome do Contexto}

{Uma ou duas frases descrevendo o que este contexto é e por que existe.}

## Language

**Order**:
{Uma ou duas frases descrevendo o termo}
_Avoid_: Purchase, transaction

**Invoice**:
Uma requisição de pagamento enviada a um cliente após a entrega.
_Avoid_: Bill, payment request

**Customer**:
Uma pessoa ou organização que faz pedidos.
_Avoid_: Client, buyer, account
```

## Regras

- **Seja opinativo.** Quando múltiplas palavras existirem para o mesmo conceito, escolha a melhor e liste as outras em `_Avoid_`.
- **Mantenha definições apertadas.** Máximo uma ou duas frases. Defina o que É, não o que faz.
- **Só inclua termos específicos ao contexto deste projeto.** Conceitos gerais de programação (timeouts, tipos de erro, padrões utilitários) não pertencem mesmo que o projeto os use extensivamente. Antes de adicionar um termo, pergunte: isso é um conceito único deste contexto, ou um conceito geral de programação? Só o primeiro pertence.
- **Agrupe termos sob subheadings** quando clusters naturais emergirem. Se todos os termos pertencerem a uma única área coesa, uma lista plana está bom.

## Repos single vs multi-context

**Single context (maioria dos repos):** Um `CONTEXT.md` na raiz do repo.

**Múltiplos contextos:** Um `CONTEXT-MAP.md` na raiz lista os contextos, onde eles vivem e como se relacionam:

```md
# Context Map

## Contexts

- [Ordering](./src/ordering/CONTEXT.md) — recebe e rastreia pedidos de clientes
- [Billing](./src/billing/CONTEXT.md) — gera invoices e processa pagamentos
- [Fulfillment](./src/fulfillment/CONTEXT.md) — gerencia picking no armazém e envio

## Relationships

- **Ordering → Fulfillment**: Ordering emite eventos `OrderPlaced`; Fulfillment consome para iniciar picking
- **Fulfillment → Billing**: Fulfillment emite eventos `ShipmentDispatched`; Billing consome para gerar invoices
- **Ordering ↔ Billing**: Tipos compartilhados para `CustomerId` e `Money`
```

A skill infere qual estrutura se aplica:

- Se `CONTEXT-MAP.md` existir, leia para encontrar os contextos
- Se só existir um `CONTEXT.md` na raiz, contexto único
- Se nenhum existir, crie um `CONTEXT.md` na raiz de forma lazy quando o primeiro termo for resolvido

Quando múltiplos contextos existirem, infira qual o tópico atual se relaciona. Se não estiver claro, pergunte.
