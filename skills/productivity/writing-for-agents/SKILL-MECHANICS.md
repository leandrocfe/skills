# Skill mechanics

O branch específico-de-skill de [`writing-for-agents`](SKILL.md): o que muda quando o documento é uma skill — frontmatter, a escolha de invocação e router skills. Todo o resto sobre escrevê-la é a referência universal em `SKILL.md`.

## Invocação

Duas escolhas, trocando as duas cargas:

- Uma skill **model-invoked** mantém uma `description`, então o agent pode dispará-la autonomamente — e outras skills podem alcançá-la. Você ainda pode digitar o nome dela: model-invocation sempre _inclui_ o alcance do usuário; uma description só adiciona descoberta pelo agent, nunca remove a do humano. A description é o context pointer top-level da skill, forçado a ficar carregado o tempo todo — context load permanente em troca de descobribilidade. Uma skill model-invoked cujo conteúdo é todo reference é também um lar para reference compartilhada: outra skill pode invocá-la, então reference precisada por várias skills vive num lugar só. Mecânica: omita `disable-model-invocation`, e escreva uma description voltada ao model carregando os trigger branches (as regras de escrita de pointer em `SKILL.md` valem por inteiro).
- Uma skill **user-invoked** tira a description do alcance do agent: só o humano digitando o nome dela pode invocá-la, e nenhuma outra skill pode. Zero context load, mas gasta cognitive load — você é o índice que precisa lembrar que ela existe. Mecânica: defina `disable-model-invocation: true`; a `description` vira voltada ao humano — um resumo de uma linha, listas de trigger removidas.

Escolha model-invocation só quando o agent precisa alcançar a skill por conta própria, ou outra skill precisa. Se ela só dispara na mão, faça-a user-invoked e não pague context load algum.

Reference compartilhada que duas skills user-invoked ambas precisam não pode viver em nenhuma delas — sem descriptions, nenhuma pode disparar a outra. Empurre-a para um arquivo simples fora do sistema de skills: reference externa que qualquer skill pode apontar.

## Dividir por invocação

O corte de invocação de dividir (o corte de sequência vive em `SKILL.md`): separe uma skill model-invoked quando você tem uma leading word distinta que deveria dispará-la por conta própria — uma trigger word que você de fato usa nos seus prompts — ou outra skill precisa alcançá-la. Você paga context load pela nova description sempre-carregada, então esse alcance independente tem que valer a pena.

## Router skills

Quando skills user-invoked se multiplicam além do que você consegue lembrar, essa cognitive load empilhada é curada por uma **router skill**: uma skill user-invoked que nomeia as outras e quando alcançar cada uma, para o humano ter uma skill a lembrar em vez de muitas. Ela só pode dar dica, nunca dispará-las: skills user-invoked não têm description, então nada além do humano pode alcançá-las.
