---
name: wayfinder
description: Planeja um pedaço enorme de trabalho — maior do que uma sessão de agent consegue segurar — como um mapa compartilhado de tickets de investigação no seu issue tracker, e resolve um ticket por vez até que o caminho até o destino esteja claro.
disable-model-invocation: true
---

Chegou uma ideia solta — grande demais para uma sessão de agent, e envolta em névoa: o caminho daqui até o **destino** ainda não é visível. Wayfinding é sobre achar esse caminho, não sobre partir para cima do destino. Esta skill traça o caminho como um **mapa compartilhado** no issue tracker do repo, e então trabalha os tickets dele um por vez até a rota ficar clara.

O destino varia a cada empreitada, e nomeá-lo é o primeiro ato de traçar o mapa — ele molda cada ticket. Pode ser uma spec para entregar e iterar, uma decisão a travar antes de o planejamento começar, ou uma mudança feita no lugar, como uma migração de estrutura de dados. O mapa é agnóstico de domínio — trabalho de engenharia, conteúdo de curso, o que couber no formato.

## Planeje, não execute

Wayfinder é **planejamento** por padrão: cada ticket resolve uma decisão, e o mapa termina quando o caminho está claro — nada restando a decidir antes que alguém vá e faça a coisa. A vontade de simplesmente executar o trabalho é, em geral, o sinal de que você chegou à borda do mapa e é hora de fazer o handoff. Uma empreitada pode sobrescrever isso nas suas **Notes** — trazendo a execução para dentro do próprio mapa — mas, na ausência disso, produza decisões, não entregáveis.

## Refira pelo nome

Todo mapa e todo ticket é uma issue, então tem um **nome** — seu título. Em tudo que o humano lê — narração, o Decisions-so-far do mapa — refira-se a ele por esse nome, nunca por um id, número ou slug pelado. Uma parede de `#42, #43, #44` é ilegível; nomes se leem de relance. O id e a URL não somem — um nome embrulha seu link — mas eles viajam *dentro* do nome, nunca no lugar dele.

## O Mapa

O mapa é uma única issue no issue tracker deste repo, com a label `wayfinder:map` — o artefato canônico. Seus tickets são issues-filhas do mapa.

O mapa é um **índice**, não um armazém. Ele lista as decisões tomadas e aponta para os tickets que guardam o detalhe delas; uma decisão vive em exatamente um lugar — seu ticket — então o mapa nunca a repete, apenas resume e linka.

**Onde o mapa, seus tickets-filhos, o blocking e as queries de frontier moram fisicamente é específico do tracker.** O issue tracker deve ter sido fornecido a você — rode `/setup-leandrocfe-skills` se não. Consulte a seção "Wayfinding operations" do doc do tracker para saber como _este_ repo os expressa. Se nenhum tracker tiver sido fornecido, use o tracker local-markdown como padrão.

### O corpo do mapa

O mapa inteiro em baixa resolução, carregado uma vez por sessão. Tickets abertos **não** são listados — eles são issues-filhas abertas, encontradas por query.

```markdown
## Destination

<como é chegar ao fim deste mapa — a spec, decisão ou mudança que esta empreitada está buscando. Uma ou duas linhas; toda sessão se orienta por isso antes de escolher um ticket.>

## Notes

<domínio; skills que toda sessão deve consultar; preferências permanentes desta empreitada>

## Decisions so far

<!-- o índice — uma linha por ticket fechado: o suficiente para julgar relevância, depois dê zoom no link para o detalhe que o ticket guarda -->

- [<título do ticket fechado>](link) — <resumo de uma linha da resposta>

## Not yet specified

<!-- veja "Fog of war": névoa dentro do escopo que você ainda não consegue transformar em ticket; gradua conforme a frontier avança -->

## Out of scope

<!-- veja "Out of scope": trabalho decidido como além do destino; fechado, nunca gradua -->
```

### Tickets

Cada ticket é uma **issue-filha** do mapa; o id da issue no tracker é sua identidade. Seu corpo é a pergunta, dimensionada para uma sessão de agent de 100K tokens:

```markdown
## Question

<a decisão ou investigação que este ticket resolve>
```

Cada ticket carrega uma label `wayfinder:<tipo>` — uma de `research`, `prototype`, `grilling`, `task` (veja [Tipos de ticket](#tipos-de-ticket)).

Uma sessão **reivindica** (claim) um ticket atribuindo-o ao dev que está conduzindo o mapa, **primeiro**, antes de qualquer trabalho, para que sessões concorrentes o pulem. Esse assignee _é_ a reivindicação: um ticket aberto e sem assignee está livre.

O blocking usa a relação de dependência **nativa** do tracker — essencial porque ela renderiza a frontier _visualmente_ na própria UI do tracker, e assim o humano vê o que é pegável sem abrir o mapa. Só um tracker que não tenha blocking nativo cai no fallback de convenção no corpo. Um ticket está **desbloqueado** quando todo ticket que o bloqueia está fechado; a **frontier** são os filhos abertos, desbloqueados e não reivindicados — a borda do conhecido.

A resposta não faz parte do corpo — ela é registrada na resolução (veja [Trabalhar o mapa](#trabalhar-o-mapa)). Assets criados ao resolver um ticket são linkados da issue, não colados dentro dela.

## Tipos de ticket

Todo ticket é ou **HITL** — human in the loop, trabalhado *com* um humano que fala por si — ou **AFK**, conduzido pelo agent sozinho. Um ticket HITL só se resolve através dessa troca ao vivo; o agent nunca faz as vezes do lado humano dela (um agent de grilling que responde às próprias perguntas quebrou isso).

- **Research** (AFK): Ler documentação, APIs de terceiros ou recursos locais como bases de conhecimento. Cria um resumo em markdown como asset linkado. Use quando é preciso conhecimento fora do diretório de trabalho atual.
- **Prototype** (HITL): Eleva a fidelidade da discussão fazendo um artefato concreto, barato e tosco para reagir — um outline, um esboço, um stub, ou código de UI/lógica via a skill /prototype. Linka o prototype como asset. Use quando "como isso deve parecer" ou "como isso deve se comportar" é a pergunta central.
- **Grilling** (HITL): Conversa via as skills /grilling e /domain-modeling, uma pergunta por vez. O caso padrão.
- **Task** (HITL ou AFK): Trabalho manual que precisa acontecer antes que uma *decisão* possa ser tomada — não há nada a decidir, prototipar ou pesquisar, mas a discussão está travada até que esteja feito. Assinar um serviço para poder julgar sua API, provisionar acesso, mover dados para poder ver seu formato. Este é o único tipo que *faz* em vez de decidir — e ele conquista seu lugar por desbloquear uma decisão, não por entregar o destino. O agent o conduz sozinho quando dá (AFK); caso contrário, entrega ao humano um checklist preciso (HITL). Resolvido quando o trabalho está feito; a resposta registra o que foi feito e quaisquer fatos resultantes (onde ficam as credenciais, novas URLs, contagem de linhas) dos quais tickets posteriores dependem.

## Fog of war

O mapa é _deliberadamente_ incompleto: não trace o que você ainda não consegue ver. Além dos tickets vivos está a **fog of war** — a visão turva de decisões e investigações que você percebe que estão vindo mas ainda não consegue fixar, porque dependem de perguntas ainda abertas. Resolver um ticket dissipa a névoa à frente dele, graduando o que agora é especificável em tickets novos — um por vez, até que o caminho até o destino esteja claro e não reste nenhum ticket.

A seção **Not yet specified** do mapa é onde essa visão turva é anotada: a pergunta suspeita, a área a revisitar depois. É a frontier ainda não descoberta _rumo ao_ destino — tudo aqui está no escopo, só não está nítido o bastante para virar ticket. Escreva de forma tão solta ou tão completa quanto a visão permitir; isso também serve de placa para colaboradores lendo para onde a empreitada está indo.

**Névoa ou ticket?** O teste é se você consegue enunciar a pergunta com precisão agora — _não_ se consegue respondê-la agora.

- **Ticket quando** a pergunta já está nítida — mesmo que esteja bloqueada e você não possa agir nela ainda.
- **Not yet specified quando** você ainda não consegue formulá-la com essa nitidez. Não pré-fatie a névoa em pedaços do tamanho de ticket: ela é mais grossa que um ticket, e uma mancha pode graduar em vários tickets, ou em nenhum, quando a frontier chegar até ela.

**Not yet specified** exclui o que já foi decidido (Decisions so far), o que já é um ticket vivo, e o que está fora do escopo (a próxima seção).

## Out of scope

A névoa só se acumula _rumo ao_ destino. O destino fixa o escopo, então trabalho além dele está **out of scope** — não é névoa, e não pertence a **Not yet specified**. Ele ganha sua própria seção **Out of scope** no mapa: trabalho que você conscientemente descartou _desta_ empreitada. É o escopo, não a nitidez, que o coloca ali.

Trabalho out-of-scope nunca gradua — a frontier para no destino — então ele só volta se o destino for redesenhado, e aí como uma empreitada nova, não como retomada.

Declarar algo fora de escopo é um ato de escopo, não um passo na rota. Quando um ticket que já existe se revela além do destino — mal-escopado durante o traçado, ou exposto por uma resolução — **feche-o** (um ticket fechado está inequivocamente fora da frontier) e deixe uma linha na seção **Out of scope**: o resumo mais o porquê de estar fora, linkando o ticket fechado. Ele fica de fora de **Decisions so far**, que registra a rota efetivamente percorrida — uma fronteira de escopo não é um passo nela.

## Invocação

Dois modos. Em qualquer um deles, **nunca resolva mais de um ticket por sessão.**

### Traçar o mapa

O usuário invoca com uma ideia solta.

1. **Nomeie o destino.** Rode uma sessão de `/grilling` e `/domain-modeling` para fixar o que este mapa está buscando — a spec, decisão ou mudança. O destino fixa o escopo, então ele é resolvido primeiro.
2. **Mapeie a frontier.** Sabatine de novo, agora em **largura**: espalhe-se por todo o espaço em vez de aprofundar numa única linha, trazendo à tona as decisões abertas e os primeiros passos já pegáveis. **Se isso não revelar névoa alguma** — o caminho até o destino já está claro, a jornada inteira é pequena o bastante para uma sessão — você não precisa de mapa. Pare e pergunte ao usuário como ele quer prosseguir.
3. **Crie o mapa** (label `wayfinder:map`): Destination e Notes preenchidos, Decisions-so-far vazio, a névoa esboçada em **Not yet specified**.
4. **Crie os tickets que você consegue especificar agora** como issues-filhas do mapa — e então conecte as blocking edges numa **segunda passada** (issues precisam de ids antes de poderem referenciar umas às outras). Conectar as edges as separa entre a frontier e as bloqueadas; tudo que você ainda não consegue especificar fica na névoa — a seção **Not yet specified**.
5. Pare — traçar o mapa é o trabalho de uma sessão; não resolva tickets também.

### Trabalhar o mapa

O usuário invoca com um mapa (URL ou número). Um ticket é **opcional** — sem ele, quem escolhe a próxima decisão é você, não o usuário.

1. Carregue o **mapa** — a visão em baixa resolução, não o corpo de cada ticket.
2. Escolha o ticket. Se o usuário nomeou um, use-o. Caso contrário, pegue o primeiro ticket da frontier em ordem. **Reivindique-o**: atribua-o a você antes de qualquer trabalho.
3. Resolva-o — **dê zoom conforme necessário**: busque o corpo completo de qualquer ticket relacionado ou fechado sob demanda; invoque as skills que o bloco `## Notes` nomear. Na dúvida, use `/grilling` e `/domain-modeling`.
4. Registre a resolução: poste a resposta como um **comentário de resolução**, **feche** a issue, e **acrescente um ponteiro de contexto** ao Decisions-so-far do mapa.
5. Adicione os tickets recém-revelados (crie-depois-conecte); gradue qualquer névoa que a resposta tenha tornado especificável, limpando cada mancha graduada de **Not yet specified**, para que ela viva apenas como seu novo ticket. Se a resposta revelar que um ticket — este ou outro — está além do destino, **declare-o out of scope** em vez de resolvê-lo na rota. Se a decisão invalidar outras partes do mapa, atualize ou apague esses tickets.

O usuário pode rodar tickets desbloqueados em paralelo, então espere que outras sessões estejam editando o tracker concorrentemente.
