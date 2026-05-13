---
name: triage
description: Triagem de issues através de uma máquina-de-estado dirigida por triage roles. Use quando o usuário quiser criar uma issue, triagear issues, revisar bugs ou feature requests recebidos, preparar issues para um AFK agent, ou gerenciar workflow de issues. Use when user wants to create an issue, triage issues, review incoming bugs or feature requests, prepare issues for an AFK agent, or manage issue workflow.
---

# Triage

Mova issues no issue tracker do projeto por uma pequena máquina-de-estado de triage roles.

Todo comment ou issue postado no issue tracker durante triagem **precisa** começar com este disclaimer:

```
> *Gerado por IA durante triagem.*
```

## Docs de referência

- [AGENT-BRIEF.md](AGENT-BRIEF.md) — como escrever briefs duráveis de agente
- [OUT-OF-SCOPE.md](OUT-OF-SCOPE.md) — como funciona a knowledge base `.out-of-scope/`

## Roles

Duas **category** roles:

- `bug` — algo está quebrado
- `enhancement` — feature ou melhoria nova

Cinco **state** roles:

- `needs-triage` — mantenedor precisa avaliar
- `needs-info` — esperando informação do reporter
- `ready-for-agent` — totalmente especificada, pronta para AFK agent
- `ready-for-human` — precisa de implementação humana
- `wontfix` — não vai ser feita

Toda issue triageada deve carregar exatamente uma category role e uma state role. Se state roles conflitam, sinalize e pergunte ao mantenedor antes de qualquer coisa.

Estes são nomes de roles canônicos — as strings de label reais usadas no issue tracker podem diferir. O mapeamento já deveria ter sido fornecido a você — rode `/setup-leandrocfe-skills` se não.

Transições de estado: uma issue sem label normalmente vai para `needs-triage` primeiro; de lá move para `needs-info`, `ready-for-agent`, `ready-for-human` ou `wontfix`. `needs-info` volta para `needs-triage` quando o reporter responde. O mantenedor pode sobrepor a qualquer momento — sinalize transições que parecem incomuns e pergunte antes de prosseguir.

## Invocação

O mantenedor invoca `/triage` e descreve o que quer em linguagem natural. Interprete o pedido e aja. Exemplos:

- "Me mostra o que precisa da minha atenção"
- "Bora olhar a #42"
- "Move a #42 pra ready-for-agent"
- "O que tá pronto pros agents pegarem?"

## Mostre o que precisa de atenção

Faça query no issue tracker e apresente três buckets, mais velhas primeiro:

1. **Sem label** — nunca triageadas.
2. **`needs-triage`** — avaliação em andamento.
3. **`needs-info` com atividade do reporter desde as últimas triage notes** — precisa de re-avaliação.

Mostre contagens e um resumo de uma linha por issue. Deixe o mantenedor escolher.

## Triagear uma issue específica

1. **Junte contexto.** Leia a issue completa (body, comments, labels, reporter, dates). Parse quaisquer triage notes anteriores para não re-perguntar perguntas resolvidas. Explore a codebase usando o glossário de domínio do projeto, respeitando ADRs na área. Leia `.out-of-scope/*.md` e traga à tona qualquer rejeição anterior que se pareça com esta issue.

2. **Recomende.** Diga ao mantenedor sua recomendação de category e state com raciocínio, mais um resumo breve da codebase relevante à issue. Espere direção.

3. **Reproduzir (só bugs).** Antes de qualquer sabatina, tente reprodução: leia os passos do reporter, trace o código relevante, rode testes ou comandos. Reporte o que aconteceu — repro com sucesso com code path, repro falho ou detalhe insuficiente (um forte sinal de `needs-info`). Um repro confirmado faz um agent brief muito mais forte.

4. **Sabatine (se necessário).** Se a issue precisa de mais carne, rode uma sessão `/grill-with-docs`.

5. **Aplique o resultado:**
   - `ready-for-agent` — poste um comment de agent brief ([AGENT-BRIEF.md](AGENT-BRIEF.md)).
   - `ready-for-human` — mesma estrutura de um agent brief, mas note por que não pode ser delegado (judgment calls, acesso externo, decisões de design, teste manual).
   - `needs-info` — poste triage notes (template abaixo).
   - `wontfix` (bug) — explicação educada, depois feche.
   - `wontfix` (enhancement) — escreva em `.out-of-scope/`, linke num comment, depois feche ([OUT-OF-SCOPE.md](OUT-OF-SCOPE.md)).
   - `needs-triage` — aplique a role. Comment opcional se houver progresso parcial.

## Override de state rápido

Se o mantenedor disser "move a #42 pra ready-for-agent", confie e aplique a role direto. Confirme o que vai fazer (mudanças de role, comment, fechar), depois aja. Pule sabatina. Se mover para `ready-for-agent` sem sessão de sabatina, pergunte se ele quer escrever um agent brief.

## Template de needs-info

```markdown
## Triage Notes

**O que estabelecemos até agora:**

- ponto 1
- ponto 2

**O que ainda precisamos de você (@reporter):**

- pergunta 1
- pergunta 2
```

Capture tudo que foi resolvido durante a sabatina sob "estabelecemos até agora" para o trabalho não ser perdido. Perguntas precisam ser específicas e acionáveis, não "por favor forneça mais info".

## Retomando uma sessão anterior

Se triage notes anteriores existem na issue, leia, cheque se o reporter respondeu alguma pergunta pendente e apresente um quadro atualizado antes de continuar. Não re-pergunte questões resolvidas.
