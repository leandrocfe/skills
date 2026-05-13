---
name: prototype
description: Constrói um protótipo descartável para flush out de design antes de se comprometer. Roteia entre duas vertentes — uma terminal app executável para perguntas de estado/business logic, ou várias variações radicalmente diferentes de UI alternáveis numa rota só. Use quando o usuário quiser prototipar, fazer sanity-check de data model ou state machine, mockar uma UI, explorar opções de design, ou disser "prototipa isso", "deixa eu brincar", "tenta uns designs". Use when user wants to prototype, sanity-check a data model or state machine, mock up a UI, explore design options.
---

# Prototype

Um protótipo é **código descartável que responde uma pergunta**. A pergunta define o formato.

## Escolha a vertente

Identifique qual pergunta está sendo respondida — pelo prompt do usuário, pelo código ao redor, ou perguntando se o usuário estiver disponível:

- **"Essa lógica / state model parece certa?"** → [LOGIC.md](LOGIC.md). Construa uma terminal app interativa minúscula que empurre a state machine por casos difíceis de raciocinar no papel.
- **"Como isso deveria parecer?"** → [UI.md](UI.md). Gere várias variações radicalmente diferentes de UI numa rota só, alternáveis via URL search param e uma floating bottom bar.

As duas vertentes produzem artefatos muito diferentes — errar isso desperdiça o protótipo inteiro. Se a pergunta for genuinamente ambígua e o usuário não estiver disponível, default para a vertente que melhor combina com o código ao redor (módulo backend → logic; page ou component → UI) e declare a suposição no topo do protótipo.

## Regras que valem para ambas

1. **Descartável desde o dia um, e marcado claramente como tal.** Localize o código do protótipo perto de onde vai ser usado de verdade (ao lado do módulo ou page que está prototipando) para o contexto ficar óbvio — mas nomeie de forma que um leitor casual veja que é protótipo, não produção. Para rotas UI descartáveis, obedeça a convenção de routing que o projeto já usa; não invente uma nova estrutura top-level.
2. **Um comando para rodar.** O que o task runner existente do projeto suportar — `pnpm <nome>`, `python <path>`, `bun <path>`, etc. O usuário tem que conseguir startar sem pensar.
3. **Sem persistência por default.** Estado vive em memória. Persistência é a coisa que o protótipo está *checando*, não algo de que ele deve depender. Se a pergunta envolve database explicitamente, aponte para um scratch DB ou um arquivo local com nome claro tipo "PROTOTYPE — wipe me".
4. **Pule o polish.** Sem testes, sem error handling além do que torna o protótipo *executável*, sem abstrações. O ponto é aprender algo rápido e deletar.
5. **Exponha o estado.** Após cada ação (logic) ou em cada switch de variante (UI), imprima ou renderize todo o estado relevante para o usuário ver o que mudou.
6. **Delete ou absorva quando terminar.** Quando o protótipo responder sua pergunta, ou delete ou absorva a decisão validada no código real — não deixe apodrecendo no repo.

## Quando terminar

A *resposta* é a única coisa que vale a pena guardar de um protótipo. Capture em algum lugar durável (commit message, ADR, issue, ou um `NOTES.md` ao lado do protótipo) junto com a pergunta que ele respondia. Se o usuário estiver disponível, essa captura é uma conversa rápida; se não, deixe o placeholder para que ele (ou você, no próximo pass) preencha o veredito antes de deletar o protótipo.
