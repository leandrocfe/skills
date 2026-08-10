---
name: wizard
description: Gera um wizard bash interativo que conduz um humano por passos que só ele pode executar. Use ao provisionar infraestrutura, configurar credenciais ou secrets de CI, percorrer um dashboard de terceiros desconhecido, ou rodar uma migração/cutover pontual. Não invoque para passos que o próprio agente consegue executar.
---

# Wizard

Um **wizard** é um script bash que conduz um humano, passo a passo, por um procedimento manual que é tedioso de fazer na mão e tedioso de reexplicar para uma IA toda vez. Ele abre cada URL, diz exatamente o que clicar e copiar, captura os valores, escreve-os onde devem ficar (`.env`, secrets do GitHub), confirma a cada etapa e mostra quantos estágios faltam. Pode configurar serviços de terceiros, rodar uma migração pontual, ou mover o projeto de um estado para outro.

A UX refinada já está resolvida pelo [template.sh](template.sh) — progresso estágio a estágio, portões de confirmação, abertura de URL cross-platform (incluindo WSL), entrada oculta de secrets, upserts idempotentes no `.env`, escrita via `gh secret`/`gh variable` e um resumo final. **Seu trabalho é apenas escopar o procedimento e escrever os estágios dele.** A biblioteca acima do marcador `STAGES` é idêntica em todo wizard; essa consistência é o ponto — nunca a edite à mão.

Um wizard é efêmero por padrão — feito para uma execução, salvo num caminho de scratch ou em `scripts/`, apagado quando o trabalho termina. Faça commit dele apenas quando o usuário quiser um caminho de setup repetível que deva viver no repo.

## Processo

### 1. Escope o procedimento

Levante todo passo manual que o humano precisa dar e todo valor capturado pelo caminho. Leia o repo primeiro — não pergunte no vácuo:

- Para setup: `.env`, `.env.example`, `.env.*`, `README`, `docker-compose*`, config do framework e `.github/workflows/*` (cada referência `secrets.*` / `vars.*` é um valor que o wizard precisa produzir).
- Para uma migração ou transição: o estado atual, o estado alvo e as ações irreversíveis entre eles.

Então mostre ao usuário a lista ordenada de estágios e os valores que cada um produz, e confirme — ele pode adicionar, remover ou reordenar.

**Pronto quando:** todo estágio está nomeado em ordem, e para cada valor capturado você sabe (a) onde o humano o obtém, (b) onde ele é escrito (`.env`, um secret do GitHub, ambos, ou lugar nenhum — alguns estágios são ações puras) e (c) se é secreto (entrada oculta) ou público.

### 2. Mapeie a jornada de cada estágio

Para cada estágio, escreva o caminho preciso que um humano percorre: qual URL abrir, o que fazer lá, onde o valor aparece, qual variável ele preenche — ex.: "Dashboard → Developers → API keys → Reveal test key → copiar". Onde você não souber de fato a UI atual ou o comando exato, diga isso e pergunte ao usuário ou consulte a documentação — nunca invente passos que podem não existir.

**Pronto quando:** todo estágio se traduz em instruções concretas que um estranho conseguiria seguir.

### 3. Escreva o wizard

Copie o `template.sh` para o caminho alvo. Substitua o estágio de exemplo por um `stage` por passo, em ordem de dependência. Use os helpers da biblioteca — `stage`, `say`/`step`, `open_url`, `ask`/`ask_secret`, `write_env`, `set_secret`/`set_var`, `pause`/`confirm` — e defina `TOTAL_STAGES` com o número de estágios que você escreveu.

Mantenha o nível que o template estabelece: abra a URL antes de pedir o valor dela, use `ask_secret` para tudo que for secreto, use `write_env` em todo valor persistido, use `set_secret` só nos valores que o CI realmente precisa, e use `confirm` antes de qualquer ação irreversível. Cada `stage` limpa a tela para que só o passo atual esteja visível — mantenha um estágio numa única tarefa focada, para que nada de que o humano precisa role para fora da tela. Não toque na biblioteca acima do marcador.

### 4. Verifique e entregue

- `bash -n <script>`; rode `shellcheck` se disponível.
- `chmod +x <script>`.
- Não rode o script de ponta a ponta você mesmo — ele abre navegadores e bloqueia esperando input humano. Em vez disso, trace-o estaticamente: todo valor do passo 1 é capturado e vai parar onde o passo 1 disse, e todo nome em `set_secret` bate exatamente com uma referência `secrets.*` no CI.
- Diga ao usuário como rodá-lo. Se for um caminho de setup repetível, faça commit e linke-o do README, para que a próxima pessoa rode o script em vez de perguntar a uma IA.
