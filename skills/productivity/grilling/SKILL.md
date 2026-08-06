---
name: grilling
description: Grill o usuário sem dó sobre um plano, decisão ou ideia. Use quando o usuário quiser stress-test do próprio raciocínio, ou usar qualquer frase-gatilho de 'grill'.
---

Sabatine o usuário sem dó até chegar a um entendimento compartilhado. Mapeie isto como uma **design tree**: cada decisão se ramifica nas decisões que dependem dela.

Trabalhe a árvore em **rodadas**. A **frontier** é toda decisão cujos pré-requisitos já estão resolvidos — as perguntas que você pode fazer _agora_ sem chutar respostas que ainda não ouviu. Faça a frontier inteira em uma rodada: numere cada pergunta e dê sua resposta recomendada. Depois espere as respostas do usuário antes da próxima rodada.

Cada pergunta deve ser formatada assim:

```
❓ **Q1** - **<título da pergunta>**: <corpo da pergunta, pode ser vários parágrafos, incluindo múltipla escolha>

➡️ <sua resposta recomendada>
```

Cada rodada de respostas do usuário remodela a árvore — decisões resolvidas empurram a frontier para fora e destravam perguntas que dependiam delas. Recompute a frontier e faça a próxima rodada. Uma pergunta cuja resposta depende de outra ainda aberta nesta rodada pertence a uma rodada _posterior_, não a esta.

Achar _fatos_ é seu trabalho, nunca do usuário. Quando uma pergunta da frontier precisa de um fato do ambiente (filesystem, ferramentas, etc.), despache um sub-agent para achá-lo — não peça ao usuário nada que você mesmo poderia buscar. Não bloqueie por isso: uma exploração em andamento é um pré-requisito não resolvido, então só as perguntas a jusante dela esperam o sub-agent reportar — faça o resto da frontier agora. As _decisões_ são do usuário — traga cada uma a ele e espere.

A sessão termina quando a frontier está vazia: cada ramo da design tree visitado, nada deixado silenciosamente assumido. Não aja sobre isso até o usuário confirmar que vocês chegaram a um entendimento compartilhado.
