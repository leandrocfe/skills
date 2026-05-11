---
name: zoom-out
description: "Sai do detalhe e apresenta a área de código em um nível de abstração acima — mapa de módulos relevantes, callers, fronteiras de contexto e papel da peça no sistema, usando o vocabulário do CONTEXT.md. Use quando usuário disser \"zoom out\", \"me dá contexto\", \"como isso encaixa\", \"mostra o sistema todo\", \"tô perdido aqui\", ou invocar /zoom-out. Triggers: \"zoom out\", \"big picture\", \"system context\", \"where does this fit\"."
disable-model-invocation: true
---

# zoom-out

Combate o anti-padrão de mexer em código sem entender **onde ele vive no sistema**. Você fica preso em uma função, perde o quadro, faz mudança que parece local mas quebra coisa três módulos longe.

Skill curta de propósito. Não há workflow grande — é uma **instrução clara** pro agente sair do detalhe.

## <o-que-fazer>

Quando esta skill for invocada:

1. **Pare de olhar o detalhe.** Sai do arquivo aberto, sai da função sob foco.

2. **Suba uma camada de abstração.** Pergunte: este código é parte de qual **módulo**? Esse módulo serve qual **fronteira de contexto** (no sentido do `CONTEXT.md`)?

3. **Mapeie callers e callees.**
   - Quem chama essa peça? (entrypoints — UI, API, jobs, CLI, testes)
   - Em quem essa peça depende? (deps diretas — outros módulos, libs, infra)
   - **Limite a 1 nível em cada direção.** Mapa de 3 níveis vira ruído.

4. **Use o vocabulário do `CONTEXT.md`.** Não invente termo. Se o módulo é "Notificações" no glossário, use "Notificações" — não "messaging system", "alert handler", etc.

5. **Sinalize ADRs relevantes.** Se houver decisão arquitetural registrada que toca essa área (`docs/adr/`), aponte. Isso economiza descobertas via tentativa e erro.

6. **Apresente como mapa**, não prosa. Use:
   - Lista bulleted de módulos
   - Setas pra fluxo (`A → B → C`)
   - Pequenos blocos de árvore quando hierarquia importa

7. **Termine com pergunta de re-foco.** "Voltando ao detalhe: o que você quer mudar aqui?"

### Formato típico de saída

```markdown
## Mapa — `<área-tocada>`

**Pertence ao módulo:** [Nome do módulo no CONTEXT.md]
**Contexto:** [contexto se for multi-contexto]

### Callers (1 nível)

- `UI` → `<feature>/<página>` chama através de `<endpoint>`
- `Cron` → job `<nome>` chama diretamente
- `Worker` → consumer `<nome>` reage a evento `<EventName>`

### Dependências (1 nível)

- `<Módulo X>` — usado para [propósito]
- `<Lib externa Y>` — para [propósito]
- `<Tabela/coleção Z>` — leitura e escrita

### ADRs relevantes

- ADR-NN — [decisão] (impacta como você deve mudar aqui)
- ADR-MM — [decisão]

### Sinais não-óbvios

- [Acoplamento escondido, restrição, gotcha]
- [Outra peculiaridade]

---

Voltando ao detalhe: o que você quer mudar?
```

## <info-de-apoio>

### Quando usar zoom-out

- Acabou de abrir área de código que **nunca tocou**
- Modificação que parece simples mas **toca 3+ arquivos**
- Pré-PR de mudança grande — confirme que mapa mental está alinhado
- Bug que reproduz em um lugar mas **provavelmente** é causado em outro
- Onboarding rápido em features novas

### Quando NÃO usar

- Sabe exatamente o que vai mudar (não enche)
- Mudança trivial (rename, formatação)
- Já fez zoom-out **nesta mesma área nesta sessão** — usa o mapa anterior

### Anti-padrões

- **NÃO** desenhe mapa de 3 níveis. Mapa virou ruído.
- **NÃO** invente termo de módulo. Use `CONTEXT.md`.
- **NÃO** termine sem pergunta de re-foco. Zoom-out sem voltar pro detalhe é especulação.
- **NÃO** confunda com `improve-codebase-architecture`. Zoom-out **descreve**, não propõe mudança.

### Por que `disable-model-invocation`

Esta skill é **comando explícito do usuário**, não disparada por contexto. Agente que faz zoom-out automaticamente sem ser pedido enche o output. Frontmatter `disable-model-invocation: true` impede invocação por engano.

### Diferença zoom-out vs grill-me

| | zoom-out | grill-me |
|---|---|---|
| Pergunta central | "Onde estou no sistema?" | "O que falta decidir?" |
| Direção | Agente apresenta mapa | Agente pergunta |
| Saída | Mapa estruturado | Decisões refinadas |

## Cross-references

- [grill-me](../grill-me/SKILL.md) — depois do zoom-out, grill pode refinar o que mudar
- [improve-codebase-architecture](../improve-codebase-architecture/SKILL.md) — quando zoom-out revela mau cheiro arquitetural
- [diagnose](../diagnose/SKILL.md) — bugs com causa em lugar diferente do sintoma frequentemente precisam de zoom-out
- [`CONTEXT.md`](../../CONTEXT.md) — vocabulário canônico que o mapa deve usar
