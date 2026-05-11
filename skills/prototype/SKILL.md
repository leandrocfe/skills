---
name: prototype
description: "Constrói protótipo descartável para validar um design antes de comprometer com ele — roteia entre dois ramos: app de terminal interativo para perguntas de lógica/estado, ou várias variações radicalmente diferentes de UI em uma única rota. Use quando usuário disser \"prototipar isso\", \"deixa eu brincar com\", \"testa o data model\", \"mostra opções de UI\", \"tentar 3 layouts\", ou invocar /prototype. Triggers: \"prototype\", \"throwaway\", \"spike\", \"design options\", \"let me play\"."
---

# prototype

Protótipo é **código descartável que responde a uma pergunta**. A pergunta decide a forma.

Combate o anti-padrão de comprometer com design (data model, state machine, UI) sem ter sentido na mão. Discussões em papel sobre arquitetura raramente expõem o que sentar e brincar com algo expõe em 5 minutos.

## <o-que-fazer>

### Escolha o ramo

Identifique qual pergunta está sendo respondida — do prompt do usuário, do código ao redor, ou perguntando se o usuário está disponível:

- **"Essa lógica / state model faz sentido?"** → [LOGIC.md](LOGIC.md). Construa app pequeno de terminal interativo que empurra a state machine por casos difíceis de raciocinar no papel.
- **"Como isso deveria parecer?"** → [UI.md](UI.md). Gere várias variações radicalmente diferentes de UI em uma única rota, alternáveis via search param de URL + barra flutuante.

Os dois ramos produzem artefatos muito diferentes — escolher errado desperdiça o protótipo inteiro. Se a pergunta é genuinamente ambígua e usuário não está disponível, default pra o ramo que melhor casa com o código ao redor (módulo backend → lógica; página ou componente → UI) e declare a suposição no topo do protótipo.

### Regras que aplicam aos dois ramos

1. **Descartável desde o dia um, e claramente marcado.** Coloque o código do protótipo perto de onde efetivamente vai ser usado (próximo ao módulo ou página) pra contexto ser óbvio — mas nomeie de forma que leitor casual veja que é protótipo, não produção. Pra rotas descartáveis de UI, **obedeça** a convenção de roteamento do projeto; não invente estrutura top-level nova.

2. **Um comando pra rodar.** Seja qual for o task runner do projeto — `pnpm <nome>`, `python <path>`, `bun <path>`. Usuário deve conseguir iniciar sem pensar.

3. **Sem persistência por default.** Estado vive em memória. Persistência é o que o protótipo está **checando**, não algo de que deveria depender. Se a pergunta envolve banco explicitamente, use scratch DB ou arquivo local com nome claro "PROTÓTIPO — limpar".

4. **Pule o polimento.** Sem testes, sem error handling além do que faz o protótipo **rodar**, sem abstrações. O ponto é aprender rápido e deletar.

5. **Exponha o estado.** Após cada ação (lógica) ou cada troca de variante (UI), imprima ou renderize o **estado relevante completo** pra usuário ver o que mudou.

6. **Delete ou absorva quando terminar.** Quando o protótipo respondeu à pergunta, ou delete ou dobre a decisão validada no código real — não deixe apodrecendo no repo.

### Quando terminar

A **resposta** é a única coisa que vale a pena guardar de um protótipo. Capture em lugar durável (mensagem de commit, ADR, issue, ou `NOTES.md` ao lado do protótipo) junto com a pergunta que estava respondendo. Se usuário está disponível, essa captura é conversa rápida; se não, deixe placeholder pra ele (ou você, na próxima passada) preencher o veredito antes de deletar.

## <info-de-apoio>

### Anti-padrões

- **NÃO adicione testes.** Protótipo que precisa de teste deixou de ser protótipo.
- **NÃO conecte ao banco real.** Use store em memória a menos que a pergunta seja especificamente sobre persistência.
- **NÃO generalize.** Sem "e se a gente quisesse suportar X depois". Protótipo responde **uma** pergunta.
- **NÃO misture lógica e TUI/UI.** Se o reducer / state machine referencia `console.log`, prompts ou códigos de escape de terminal, deixou de ser portável. Mantenha shell fina sobre módulo puro.
- **NÃO envie o shell do protótipo pra produção.** Shell foi otimizado pra ser dirigido manualmente. Módulo de lógica atrás dele é a parte que vale guardar.
- **NÃO deixe protótipo apodrecendo no repo.** Decisão tomada → ou absorve no código real ou deleta. Protótipos antigos confundem o próximo leitor.

### Quando NÃO prototipar

- Mudança trivial bem entendida (rename, refator de método)
- Você **sabe** o design (não há pergunta em aberto)
- Bug conhecido em código de produção — vá direto pra [diagnose](../diagnose/SKILL.md)
- Documentação ou comunicação — não cabe protótipo

### Diferença vs spike vs MVP

| | Protótipo | Spike | MVP |
|---|---|---|---|
| Vida útil | Descartável | Descartável | Permanente (versão 1) |
| Audiência | Você | Time técnico | Usuários reais |
| Saída | Resposta a 1 pergunta | Estimativa de viabilidade | Produto funcional |
| Testes | Não | Não | Sim |
| Polimento | Zero | Zero | Mínimo viável |

Esta skill é **protótipo**. Spike é parente próximo. MVP **não** é prototipo — é produto em estágio inicial.

### Sinais de bom protótipo

- Levou < 1 dia pra ficar pronto
- Respondeu **a pergunta original**, não uma adjacente
- Acabou deletado (ou absorvido no código real)
- Aprendeu algo que não dava pra prever no papel
- Próximo passo concreto saiu dele

### Sinais de protótipo que virou monstro

- Já passou de 1 dia e ainda evoluindo
- Adicionou auth, banco real, testes ("só pra deixar mais sólido")
- Ninguém mais lembra qual era a pergunta original
- Está sendo demonstrado pra stakeholders externos
- Você se pega defendendo o protótipo em vez de aprender com ele

Se 2+ destes sinais batem: **pare**. Capture o que aprendeu. Delete o que sobrou. Recomece com escopo real.

## Cross-references

- [LOGIC.md](LOGIC.md) — protótipo de terminal pra lógica/estado
- [UI.md](UI.md) — variações de UI em uma rota
- [grill-me](../grill-me/SKILL.md) — usar antes pra clarear qual é **a** pergunta
- [tdd](../tdd/SKILL.md) — depois do protótipo responder, TDD constrói a versão real
- [`CONTEXT.md`](../../CONTEXT.md) — vocabulário canônico
