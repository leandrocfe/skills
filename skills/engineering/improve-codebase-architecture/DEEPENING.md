# Deepening

Como aprofundar um cluster de shallow modules com segurança, dadas suas dependências. Assume o vocabulário em [LANGUAGE.md](LANGUAGE.md) — **module**, **interface**, **seam**, **adapter**.

## Categorias de dependência

Ao avaliar um candidato para deepening, classifique suas dependências. A categoria determina como o módulo aprofundado é testado pelo seu seam.

### 1. In-process

Computação pura, estado em memória, sem I/O. Sempre deepenable — funda os módulos e teste pela nova interface direto. Sem adapter necessário.

### 2. Local-substitutable

Dependências que têm stand-ins de teste locais (PGLite para Postgres, in-memory filesystem). Deepenable se o stand-in existe. O módulo aprofundado é testado com o stand-in rodando na test suite. O seam é interno; sem port na interface externa do módulo.

### 3. Remote but owned (Ports & Adapters)

Seus próprios services cruzando network boundary (microservices, internal APIs). Defina um **port** (interface) no seam. O deep module possui a lógica; o transport é injetado como **adapter**. Testes usam in-memory adapter. Produção usa HTTP/gRPC/queue adapter.

Shape da recomendação: *"Defina um port no seam, implemente um HTTP adapter para produção e um in-memory adapter para teste, para a lógica ficar num único deep module mesmo deployado por uma rede."*

### 4. True external (Mock)

Third-party services (Stripe, Twilio, etc.) que você não controla. O módulo aprofundado pega a dependência externa como port injetado; testes fornecem mock adapter.

## Disciplina de seam

- **Um adapter é seam hipotético. Dois adapters é seam real.** Não introduza um port a menos que ao menos dois adapters sejam justificados (tipicamente produção + teste). Um seam single-adapter é só indireção.
- **Seams internos vs seams externos.** Um deep module pode ter seams internos (privados à sua implementação, usados pelos seus próprios testes) tanto quanto o seam externo na interface. Não exponha seams internos pela interface só porque testes usam.

## Estratégia de teste: substituir, não empilhar

- Unit tests velhos em shallow modules viram lixo quando testes na interface do módulo aprofundado existem — delete.
- Escreva testes novos na interface do módulo aprofundado. A **interface é a test surface**.
- Testes assertam sobre observable outcomes pela interface, não sobre estado interno.
- Testes devem sobreviver a refactors internos — descrevem comportamento, não implementação. Se um teste precisa mudar quando a implementação muda, está testando além da interface.
