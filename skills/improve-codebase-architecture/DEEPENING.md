# Aprofundamento

Como aprofundar um cluster de módulos rasos com segurança, dadas suas dependências. Assume o vocabulário em [LANGUAGE.md](LANGUAGE.md) — **módulo**, **interface**, **seam**, **adapter**.

## Categorias de dependência

Ao avaliar um candidato pra aprofundamento, classifique suas dependências. A categoria determina como o módulo aprofundado é testado através do seu seam.

### 1. In-process

Computação pura, estado em memória, sem I/O. **Sempre** aprofundável — funda os módulos e teste através da interface nova diretamente. Não precisa adapter.

**Exemplo:** três validadores puros que tomam input e retornam resultado.

### 2. Local-substituível

Dependências com stand-ins de teste locais (PGLite pro Postgres, filesystem em memória). Aprofundável **se o stand-in existe**. Módulo aprofundado é testado com stand-in rodando na suite de teste. Seam é interno; sem porta na interface externa do módulo.

**Exemplo:** módulo que persiste pedidos no Postgres — testado com PGLite, sem precisar de port externo.

### 3. Remote mas próprio (Ports & Adapters)

Seus próprios serviços através de fronteira de rede (microserviços, APIs internas). Defina **porta** (interface) no seam. Módulo profundo é dono da lógica; transporte é injetado como **adapter**. Testes usam adapter em memória. Produção usa adapter HTTP/gRPC/fila.

**Forma da recomendação:** _"Defina uma porta no seam, implemente adapter HTTP para produção e adapter em memória para teste, pra a lógica ficar em **um** módulo profundo mesmo deployada cruzando rede."_

### 4. Externo verdadeiro (Mock)

Serviços de terceiros (Stripe, Twilio, etc.) que você não controla. Módulo aprofundado recebe a dependência externa como porta injetada; testes provêm adapter mock.

**Exemplo:** módulo de checkout que chama Stripe — interface aceita `paymentGateway`; produção injeta cliente Stripe; teste injeta mock.

## Disciplina de seam

- **Um adapter = seam hipotético. Dois adapters = seam real.** Não introduza porta a menos que pelo menos dois adapters sejam justificados (tipicamente produção + teste). Seam com um adapter é só indireção.
- **Seams internos vs externos.** Módulo profundo pode ter seams internos (privados à sua implementação, usados pelos seus próprios testes) e o seam externo na sua interface. Não exponha seams internos pela interface só porque testes usam.

## Estratégia de teste: substituir, não empilhar

- Testes unitários antigos em módulos rasos viram desperdício quando testes na interface do módulo aprofundado existem — **delete-os**.
- Escreva testes novos na interface do módulo aprofundado. **Interface é a superfície de teste.**
- Testes assertam em resultados observáveis através da interface, não em estado interno.
- Testes devem sobreviver a refators internos — descrevem **comportamento**, não **implementação**. Se um teste tem que mudar quando a implementação muda, está testando além da interface.

## Cuidados

### Não aprofundar prematuramente

Aprofundamento exige **alavancagem real**. Sinais de "aprofundamento prematuro":

- Só 1 caller → não há localidade pra ganhar
- Comportamento ainda evoluindo rápido → interface vai mudar muito
- Time não concorda sobre o que o módulo deve fazer → ainda em descoberta

Espera-se que o código exista um tempo antes de aprofundar.

### Aprofundamento em camadas

Camadas (UI / API / DB) geralmente **não** são candidatos diretos a aprofundamento — são fronteiras de transporte, não fronteiras de domínio. Aprofunde **dentro** de cada camada (em módulos de domínio), não pela camada.

### Quando aprofundamento cruza categorias

Caso real: módulo que combina computação pura (categoria 1) + persistência (categoria 2) + chamada externa (categoria 4). Aprofunde normalmente; trate dependências externas como portas injetadas. A "computação pura" fica como helpers privados.
