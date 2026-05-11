# Como escrever Agent Briefs

Um **agent brief** é um comentário estruturado postado na issue quando ela move pra `pronta-pra-agente`. É a **especificação autoritativa** com a qual o agente AFK vai trabalhar. Corpo original da issue e discussão são contexto — o agent brief é o contrato.

## Princípios

### Durabilidade > precisão

A issue pode ficar em `pronta-pra-agente` por dias ou semanas. Codebase vai mudar nesse intervalo. Escreva o brief pra continuar útil mesmo com arquivos renomeados, movidos ou refatorados.

- **Faça:** descreva interfaces, tipos, contratos de comportamento
- **Faça:** nomeie tipos, assinaturas, formatos de config específicos que o agente deve procurar ou modificar
- **NÃO:** referencie paths de arquivo — eles ficam obsoletos
- **NÃO:** referencie números de linha
- **NÃO:** assuma que a estrutura atual da implementação vai permanecer

### Comportamental, não procedural

Descreva **o que** o sistema deve fazer, não **como** implementar. Agente vai explorar o codebase do zero e tomar decisões próprias de implementação.

- **Bom:** "O tipo `SkillConfig` deve aceitar um campo opcional `schedule` do tipo `CronExpression`"
- **Ruim:** "Abre src/types/skill.ts e adiciona um campo schedule na linha 42"
- **Bom:** "Quando usuário roda `/triage` sem argumentos, deve ver resumo de issues que precisam de atenção"
- **Ruim:** "Adicionar um switch statement na função handler principal"

### Critérios de aceitação completos

Agente precisa saber **quando terminou**. Todo agent brief tem critérios concretos e testáveis. Cada critério verificável independentemente.

- **Bom:** "Rodar `gh issue list --label precisa-de-triagem` retorna issues que passaram por classificação inicial"
- **Ruim:** "Triagem deve funcionar corretamente"

### Fronteiras de escopo explícitas

Indique o que está **fora**. Previne agente de fazer gold-plating ou assumir features adjacentes.

## Template

```markdown
> *Gerado por IA durante triagem.*

## Agent Brief

**Categoria:** bug / enhancement
**Resumo:** descrição de 1 linha do que precisa acontecer

**Comportamento atual:**
Descrição do que acontece agora. Para bugs, é o comportamento quebrado.
Para enhancements, é o status quo sobre o qual a feature será construída.

**Comportamento desejado:**
Descrição do que deve acontecer depois do trabalho. Seja específico
sobre casos de borda e condições de erro.

**Interfaces relevantes:**
- `NomeDoTipo` — o que precisa mudar e por quê
- `nomeDaFuncao()` retorno — o que retorna hoje vs o que deve retornar
- Formato de config — novas opções necessárias

**Critérios de aceitação:**
- [ ] Critério 1, específico e testável
- [ ] Critério 2
- [ ] Critério 3

**Fora de escopo:**
- Coisa que NÃO deve ser mudada nesta issue
- Feature adjacente que pode parecer relacionada mas é separada
```

## Exemplos

### Agent brief bom (bug)

```markdown
> *Gerado por IA durante triagem.*

## Agent Brief

**Categoria:** bug
**Resumo:** Truncamento de descrição de skill quebra no meio da palavra

**Comportamento atual:**
Quando uma descrição de skill passa de 1024 caracteres, é truncada em
exatamente 1024 caracteres independente de fronteira de palavra. Isso
produz descrições que terminam no meio da palavra (ex: "Use quando o
usuário quiser confi").

**Comportamento desejado:**
Truncamento deve quebrar na última fronteira de palavra antes de 1024
caracteres e anexar "..." para indicar truncamento.

**Interfaces relevantes:**
- Campo `description` do tipo `SkillMetadata` — sem mudança de tipo, mas
  a lógica de validação/processamento que popula esse campo precisa
  respeitar fronteira de palavra
- Qualquer função que lê frontmatter de SKILL.md e extrai a description

**Critérios de aceitação:**
- [ ] Descrições com menos de 1024 chars permanecem inalteradas
- [ ] Descrições com mais de 1024 chars são truncadas na última fronteira
      de palavra antes de 1024 chars
- [ ] Descrições truncadas terminam com "..."
- [ ] Comprimento total incluindo "..." não excede 1024 chars

**Fora de escopo:**
- Mudar o limite de 1024 chars
- Suporte a descrição multi-linha
```

### Agent brief bom (enhancement)

```markdown
> *Gerado por IA durante triagem.*

## Agent Brief

**Categoria:** enhancement
**Resumo:** Adicionar suporte ao diretório `.out-of-scope/` para rastrear features rejeitadas

**Comportamento atual:**
Quando uma feature request é rejeitada, a issue é fechada com label
`wontfix` e um comentário. Não há registro persistente da decisão ou
raciocínio. Requests similares futuras exigem que o mantenedor lembre
ou pesquise a discussão anterior.

**Comportamento desejado:**
Feature requests rejeitadas devem ser documentadas em arquivos
`.out-of-scope/<conceito>.md` que capturam a decisão, raciocínio e links
para todas as issues que pediram a feature. Durante triagem, esses
arquivos devem ser checados contra issues novas.

**Interfaces relevantes:**
- Formato de markdown em `.out-of-scope/` — cada arquivo deve ter um
  cabeçalho `# Nome do Conceito`, uma linha `**Decisão:**`, uma
  `**Motivo:**`, e lista `**Pedidos prévios:**` com links de issue
- Workflow de triagem deve ler todos os arquivos `.out-of-scope/*.md`
  cedo e cruzar com issues entrantes por similaridade de conceito

**Critérios de aceitação:**
- [ ] Fechar feature como wontfix cria/atualiza arquivo em `.out-of-scope/`
- [ ] Arquivo inclui decisão, motivo e link da issue fechada
- [ ] Se arquivo `.out-of-scope/` correspondente já existe, nova issue é
      anexada à lista "Pedidos prévios" em vez de duplicar
- [ ] Durante triagem, arquivos `.out-of-scope/` existentes são checados
      e mostrados quando issue nova bate com rejeição prévia

**Fora de escopo:**
- Matching automático (humano confirma)
- Reabrir features rejeitadas previamente
- Bug reports (só rejeição de enhancements vai pra `.out-of-scope/`)
```

### Agent brief ruim

```markdown
## Agent Brief

**Resumo:** Corrigir o bug da triagem

**O que fazer:**
A triagem tá quebrada. Olha o arquivo principal e conserta.
A função perto da linha 150 tem o problema.

**Arquivos a mudar:**
- src/triage/handler.ts (linha 150)
- src/types.ts (linha 42)
```

Por que é ruim:
- Sem categoria
- Descrição vaga ("a triagem tá quebrada")
- Referencia paths e números de linha que vão obsoletar
- Sem critérios de aceitação
- Sem fronteiras de escopo
- Sem descrição de comportamento atual vs desejado
