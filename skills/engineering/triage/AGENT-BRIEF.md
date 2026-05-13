# Escrevendo Agent Briefs

Um agent brief é um comment estruturado postado numa GitHub issue quando ela move para `ready-for-agent`. É a especificação autoritativa com que um AFK agent vai trabalhar. O body da issue original e a discussão são contexto — o agent brief é o contrato.

## Princípios

### Durabilidade sobre precisão

A issue pode ficar em `ready-for-agent` por dias ou semanas. A codebase vai mudar nesse meio-tempo. Escreva o brief para ele continuar útil mesmo com arquivos renomeados, movidos ou refatorados.

- **Faça** descrever interfaces, tipos e contratos de comportamento
- **Faça** nomear tipos específicos, function signatures ou shapes de config que o agente deve procurar ou modificar
- **Não** referencie paths de arquivo — ficam stale
- **Não** referencie números de linha
- **Não** assuma que a estrutura de implementação atual vai continuar a mesma

### Comportamental, não procedimental

Descreva **o que** o sistema deveria fazer, não **como** implementar. O agente vai explorar a codebase fresh e tomar suas próprias decisões de implementação.

- **Bom:** "O tipo `SkillConfig` deve aceitar um campo opcional `schedule` do tipo `CronExpression`"
- **Ruim:** "Abra src/types/skill.ts e adicione um campo schedule na linha 42"
- **Bom:** "Quando um usuário rodar `/triage` sem argumentos, ele deve ver um resumo de issues precisando de atenção"
- **Ruim:** "Adicione um switch statement na função handler principal"

### Acceptance criteria completos

O agente precisa saber quando está pronto. Todo agent brief precisa de acceptance criteria concretos e testáveis. Cada critério deve ser verificável independentemente.

- **Bom:** "Rodar `gh issue list --label needs-triage` retorna issues que passaram por classificação inicial"
- **Ruim:** "Triagem deve funcionar corretamente"

### Fronteiras explícitas de escopo

Declare o que está fora de escopo. Isso impede o agente de fazer gold-plating ou suposições sobre features adjacentes.

## Template

```markdown
## Agent Brief

**Category:** bug / enhancement
**Summary:** descrição de uma linha do que precisa acontecer

**Current behavior:**
Descreva o que acontece agora. Para bugs, este é o comportamento quebrado.
Para enhancements, este é o status quo em que o feature se apoia.

**Desired behavior:**
Descreva o que deve acontecer depois do trabalho do agente estar completo.
Seja específico sobre edge cases e condições de erro.

**Key interfaces:**
- `TypeName` — o que precisa mudar e por quê
- `functionName()` return type — o que retorna atualmente vs o que deve retornar
- Shape de config — quaisquer novas options de configuração necessárias

**Acceptance criteria:**
- [ ] Critério específico e testável 1
- [ ] Critério específico e testável 2
- [ ] Critério específico e testável 3

**Out of scope:**
- Coisa que NÃO deve ser mudada ou endereçada nesta issue
- Feature adjacente que pode parecer relacionada mas é separada
```

## Exemplos

### Bom agent brief (bug)

```markdown
## Agent Brief

**Category:** bug
**Summary:** Truncamento de description de skill corta no meio da palavra, produzindo output quebrado

**Current behavior:**
Quando uma description de skill excede 1024 caracteres, ela é truncada em
exatamente 1024 caracteres independente de fronteiras de palavra. Isso produz
descriptions que terminam no meio da palavra (ex.: "Use when the user wants to confi").

**Desired behavior:**
Truncamento deve quebrar na última fronteira de palavra antes de 1024 caracteres
e anexar "..." para indicar truncamento.

**Key interfaces:**
- O campo `description` do tipo `SkillMetadata` — sem mudança de tipo necessária,
  mas a lógica de validation/processing que o popula precisa respeitar
  fronteiras de palavra
- Qualquer função que lê frontmatter de SKILL.md e extrai a description

**Acceptance criteria:**
- [ ] Descriptions abaixo de 1024 chars não mudam
- [ ] Descriptions acima de 1024 chars são truncadas na última fronteira de
      palavra antes de 1024 chars
- [ ] Descriptions truncadas terminam com "..."
- [ ] O comprimento total incluindo "..." não excede 1024 chars

**Out of scope:**
- Mudar o limite de 1024 chars
- Suporte a description multi-linha
```

### Bom agent brief (enhancement)

```markdown
## Agent Brief

**Category:** enhancement
**Summary:** Adicionar suporte ao diretório `.out-of-scope/` para rastrear feature requests rejeitadas

**Current behavior:**
Quando uma feature request é rejeitada, a issue é fechada com label `wontfix`
e um comment. Não há registro persistente da decisão ou do raciocínio. Requests
similares futuros exigem que o mantenedor lembre ou pesquise a discussão anterior.

**Desired behavior:**
Feature requests rejeitadas devem ser documentadas em arquivos
`.out-of-scope/<concept>.md` que capturam a decisão, o raciocínio e links para
todas as issues que pediram o feature. Ao triagear issues novas, esses arquivos
devem ser checados para matches.

**Key interfaces:**
- Formato de arquivo markdown em `.out-of-scope/` — cada arquivo deve ter um
  heading `# Concept Name`, uma linha `**Decision:**`, uma linha `**Reason:**`
  e uma lista `**Prior requests:**` com links de issues
- O workflow de triagem deve ler todos os arquivos `.out-of-scope/*.md` cedo
  e fazer match de issues recebidas por similaridade de conceito

**Acceptance criteria:**
- [ ] Fechar uma feature como wontfix cria/atualiza um arquivo em `.out-of-scope/`
- [ ] O arquivo inclui a decisão, raciocínio e link à issue fechada
- [ ] Se um arquivo `.out-of-scope/` correspondente já existe, a issue nova é
      anexada à lista "Prior requests" em vez de criar duplicata
- [ ] Durante triagem, arquivos `.out-of-scope/` existentes são checados e
      surfados quando uma issue nova bate com uma rejeição anterior

**Out of scope:**
- Matching automatizado (humano confirma o match)
- Reabrir features previamente rejeitadas
- Bug reports (só rejeições de enhancement vão para `.out-of-scope/`)
```

### Agent brief ruim

```markdown
## Agent Brief

**Summary:** Fix o bug da triagem

**What to do:**
A coisa da triagem está quebrada. Olhe o arquivo principal e conserte.
A função em volta da linha 150 tem o problema.

**Files to change:**
- src/triage/handler.ts (linha 150)
- src/types.ts (linha 42)
```

Isto é ruim porque:
- Sem category
- Descrição vaga ("a coisa da triagem está quebrada")
- Referencia paths de arquivo e números de linha que vão ficar stale
- Sem acceptance criteria
- Sem fronteiras de escopo
- Sem descrição de comportamento current vs desired
