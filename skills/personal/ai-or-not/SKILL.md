---
name: ai-or-not
description: Julga se uma referência foi feita por IA. Use quando o usuário colar um texto, artigo, imagem, vídeo, áudio ou link e perguntar se aquilo é IA, se é real, se foi feito por humano, ou pedir para checar de onde veio o material.
---

Dê um veredito que se sustente em prova, não em impressão. Prova aqui é o sinal que continua de pé depois que você mesmo tentou derrubá-lo.

**1. Enquadre.** Diga em uma frase que material é esse e qual das três perguntas o veredito responde:

- **Feito por IA**: a IA produziu tudo do zero.
- **Feito com ajuda de IA**: a pessoa fez, e a IA revisou, traduziu, dublou ou retocou.
- **Adulterado**: material real alterado para enganar.

Se o pedido não deixar claro qual delas importa, pergunte ao usuário.

**2. Descubra de onde veio.** Saber a origem resolve o caso que os sinais de estilo só sugerem. Passe pelos quatro caminhos e anote em cada um o que achou, ou por que não deu para checar:

- **Dados do arquivo**: C2PA, EXIF, XMP, dados do vídeo ou do áudio, marca d'água de gerador como a SynthID.
- **Onde foi publicado**: link, site, veículo e data. Os modelos daquela data conseguiam fazer isso?
- **Quem assina**: trabalhos anteriores, portfólio, arquivos de trabalho, rascunhos, histórico do git.
- **Por onde circulou**: busca reversa da imagem ou de um quadro do vídeo, busca por trechos exatos do texto.

Use o que a sessão tiver: WebSearch, WebFetch, `exiftool`, `ffprobe`, leitura direta do arquivo. O que você não conseguiu checar entra no laudo como não checado, e nunca vira suposição.

**3. Colha os sinais.** Leia `SIGNALS.md` e rode só a parte da modalidade que você tem em mãos. Material misto, como artigo com fotos ou vídeo com narração, roda uma parte por pedaço. Marque cada sinal como presente, ausente ou duvidoso, e todo sinal presente vem com o ponto exato: a frase copiada, o minuto do vídeo, o pedaço da imagem.

**4. Defenda o material.** Agora finja que o material é humano e defenda-o. Para cada sinal presente, escreva a explicação humana mais provável. Ritmo sempre igual pode ser gente acostumada a escrever texto de empresa. Pele lisa demais pode ser filtro de celular. Sinal que aguenta a melhor defesa vira prova. Sinal que a defesa explica sai do laudo, mesmo que você gostasse dele.

**5. Dê o veredito.** Nesta ordem: a resposta na escala (`Feito por IA`, `Provavelmente IA`, `Não dá para dizer`, `Provavelmente humano`, `Humano`, e o rótulo de ajuda de IA quando couber); o quanto você confia nisso e por quê; as provas que sobraram, cada uma com seu ponto exato; e o que faria você mudar de ideia. `Não dá para dizer` é resposta válida, e vale mais que um chute com cara de laudo. Se a confiança está alta sem prova, ou baixa com prova de sobra, um dos dois está errado.

## Para consultar

**Detector automático não é prova.** GPTZero, Originality.ai e parecidos entram como um sinal fraco no meio dos outros. Eles acusam à toa texto de quem escreve em outra língua, texto técnico e texto formal. Diga o resultado sempre com o nome da ferramenta junto, nunca como conclusão.

**Não achar sinal não prova que é humano.** Texto feito por IA e depois editado não deixa rastro de estilo. Sem sinal, o máximo que dá para dizer é `Provavelmente humano`, e só quando a origem ajuda.

**O contexto ajusta a confiança, mas não substitui a prova.** Newsletter de marketing em 2026 quase sempre passou por IA. Bilhete escrito à mão e fotografado, quase nunca.

**Diga qual erro você prefere evitar.** Acusar uma pessoa de usar IA e engolir material falso como verdadeiro pesam diferente dependendo do uso. Quando o usuário contar para que serve o veredito, deixe claro para que lado você está errando de propósito.
