---
name: to-questionnaire
description: Turn a decision you can't fully answer into a questionnaire for someone else to fill in.
disable-model-invocation: true
---

Transforme algo que o usuário não consegue responder sozinho num **questionário** — um documento Markdown que ele entrega a uma pessoa para preencher async, ou preenche junto numa reunião. Quem recebe detém o conhecimento que falta ao usuário; o questionário extrai isso dela.

**Grille o envio, não o assunto.** Entreviste o usuário só sobre o _envio_, que ele sempre consegue responder: para quem vai, e o que precisa de volta. As perguntas do documento então miram o **gap** entre o que quem recebe sabe e o que o usuário precisa.

1. **Para quem vai?** Pergunte, numa troca, o papel de quem recebe, sua expertise e a relação com o usuário. Isso fixa o tom do questionário e quanto contexto ele precisa carregar. Pronto quando você souber quem é o destinatário e o que ele sabe que o usuário não sabe.

2. **O que você precisa de volta?** Pergunte, numa troca, as decisões ou fatos específicos que o usuário não resolve sozinho e precisa dessa pessoa. Pronto quando você tiver uma lista concreta do que o usuário precisa sair capaz de fazer ou decidir.

3. **Escreva o questionário.** Rascunhe perguntas mirando o gap dos passos 1–2, seguindo a Estrutura do documento abaixo. Escreva em `to-questionnaire-<slug>.md` no diretório atual (slug a partir do tópico) e reporte o path. Pronto quando o arquivo existir e todo item que o usuário nomeou no passo 2 estiver coberto por uma pergunta.

## Estrutura do documento

Enquadre o documento como um **questionário de discovery**: o usuário não tem o contexto, quem recebe tem. Ordene as perguntas mais-importante-primeiro — async significa que talvez você só tenha uma passada — e agrupe-as sob headings `##` por tema quando passarem de um punhado. Escreva usando o template abaixo.

<questionnaire-template>

# <Título do questionário>

**Propósito:** por que este questionário existe e a decisão que depende dele.

**De:** <o usuário> — **Para:** <quem recebe> — **Como suas respostas serão usadas:** <para onde vão>

## Contexto

Um parágrafo orientando quem recebe e não estava na cabeça do usuário. O suficiente pra responder bem, não uma página.

## Como responder

Prazo e esforço aproximado. Respostas parciais e "não sei" são úteis — sinalize qualquer coisa de que não tenha certeza em vez de pular.

## <Heading de tema>

Uma seção `##` por tema. Sob cada uma, suas perguntas, mais-importante-primeiro. Toda pergunta é uma ideia — nunca composta — com um stub de resposta logo abaixo, e uma linha _por que isto importa_ só onde a pergunta poderia ser mal lida ou convidar a uma resposta descartável.

<question-example>
### Qual carga o sistema deve suportar no lançamento?

_Por que isto importa: decide se provisionamos para pico de tráfego agora ou adiamos._

>
</question-example>

## Mais alguma coisa?

Um catch-all de fechamento: algo que não perguntamos e que deveríamos saber?

</questionnaire-template>
