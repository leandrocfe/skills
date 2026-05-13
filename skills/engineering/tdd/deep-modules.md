# Deep Modules

De "A Philosophy of Software Design":

**Deep module** = interface pequena + muita implementação

```
┌─────────────────────┐
│   Small Interface   │  ← Poucos métodos, params simples
├─────────────────────┤
│                     │
│                     │
│  Deep Implementation│  ← Lógica complexa escondida
│                     │
│                     │
└─────────────────────┘
```

**Shallow module** = interface grande + pouca implementação (evite)

```
┌─────────────────────────────────┐
│       Large Interface           │  ← Muitos métodos, params complexos
├─────────────────────────────────┤
│  Thin Implementation            │  ← Só passa adiante
└─────────────────────────────────┘
```

Ao desenhar interfaces, pergunte:

- Posso reduzir o número de métodos?
- Posso simplificar os parâmetros?
- Posso esconder mais complexidade lá dentro?
