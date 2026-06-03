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
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request

**Customer**:
A person or organization that places orders.
_Avoid_: Client, buyer, account
```

## Regras

- **Seja opinativo.** Quando múltiplas palavras existem para o mesmo conceito, escolha a melhor e liste as outras como aliases a evitar.
- **Mantenha definições apertadas.** Uma ou duas frases no máximo. Defina o que ISSO É, não o que ISSO FAZ.
- **Inclua só termos específicos ao contexto deste projeto.** Conceitos gerais de programação (timeouts, error types, padrões utilitários) não cabem mesmo que o projeto use bastante. Antes de adicionar um termo, pergunte: é conceito único a este contexto ou conceito geral de programação? Só o primeiro cabe.
- **Agrupe termos sob subheaders** quando clusters naturais emergem. Se todos os termos pertencem a uma única área coesa, lista plana serve.

## Repos de contexto único vs múltiplo

**Contexto único (maioria dos repos):** Um `CONTEXT.md` na raiz do repo.

**Múltiplos contextos:** Um `CONTEXT-MAP.md` na raiz lista os contextos, onde vivem e como se relacionam:

```md
# Context Map

## Contexts

- [Ordering](./src/ordering/CONTEXT.md) — recebe e rastreia orders de clientes
- [Billing](./src/billing/CONTEXT.md) — gera invoices e processa payments
- [Fulfillment](./src/fulfillment/CONTEXT.md) — gerencia picking e shipping no warehouse

## Relationships

- **Ordering → Fulfillment**: Ordering emite eventos `OrderPlaced`; Fulfillment consome para iniciar picking
- **Fulfillment → Billing**: Fulfillment emite eventos `ShipmentDispatched`; Billing consome para gerar invoices
- **Ordering ↔ Billing**: Tipos compartilhados para `CustomerId` e `Money`
```

A skill infere qual estrutura aplica:

- Se `CONTEXT-MAP.md` existir, leia para achar contextos
- Se só um `CONTEXT.md` na raiz existir, contexto único
- Se nenhum existir, crie um `CONTEXT.md` na raiz com preguiça quando o primeiro termo for resolvido

Quando múltiplos contextos existirem, infira a qual o tópico atual se relaciona. Se incerto, pergunte.
