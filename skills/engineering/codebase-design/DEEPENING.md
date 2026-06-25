# Deepening

Como aprofundar (deepen) um cluster de módulos rasos (shallow) com segurança, considerando suas dependências. Assume o vocabulário de [SKILL.md](SKILL.md) — **module**, **interface**, **seam**, **adapter**.

## Categorias de dependência

Ao avaliar um candidato para deepening, classifique suas dependências. A categoria determina como o módulo aprofundado é testado através do seu seam.

### 1. In-process
Computação pura, estado em memória, sem I/O. Sempre pode ser aprofundado — una os módulos e teste diretamente através da nova interface. Nenhum adapter necessário.

### 2. Local-substitutable
Dependências que possuem stand-ins locais para teste (PGLite para Postgres, filesystem em memória). Pode ser aprofundado se o stand-in existir. O módulo aprofundado é testado com o stand-in rodando na suíte de testes. O seam é interno; não há port na interface externa do módulo.

### 3. Remote but owned (Ports & Adapters)
Seus próprios serviços através de uma fronteira de rede (microsserviços, APIs internas). Defina um **port** (interface) no seam. O módulo profundo é dono da lógica; o transporte é injetado como um **adapter**. Testes usam um adapter em memória. Produção usa um adapter HTTP/gRPC/queue.

Formato de recomendação: *"Defina um port no seam, implemente um adapter HTTP para produção e um adapter em memória para testes, de forma que a lógica fique em um único módulo profundo mesmo estando deployada através da rede."*

### 4. True external (Mock)
Serviços de terceiros (Stripe, Twilio, etc.) que você não controla. O módulo aprofundado recebe a dependência externa como um port injetado; os testes fornecem um adapter de mock.

## Disciplina de Seam

- **Um adapter significa um seam hipotético. Dois adapters significam um seam real.** Não introduza um port a menos que pelo menos dois adapters sejam justificados (tipicamente produção + teste). Um seam de adapter único é apenas indireção.
- **Internal seams vs external seams.** Um módulo profundo pode ter internal seams (privados à sua implementação, usados por seus próprios testes) assim como o external seam na sua interface. Não exponha internal seams através da interface só porque os testes os usam.

## Estratégia de teste: replace, don't layer

- Testes unitários antigos em módulos rasos viram desperdício uma vez que existam testes na interface do módulo aprofundado — delete-os.
- Escreva novos testes na interface do módulo aprofundado. **A interface é a test surface.**
- Os testes afirmam sobre outcomes observáveis através da interface, não sobre estado interno.
- Os testes devem sobreviver a refactors internos — eles descrevem comportamento, não implementação. Se um teste precisa mudar quando a implementação muda, ele está testando além da interface.
