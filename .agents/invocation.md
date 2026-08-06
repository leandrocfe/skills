# Model-invoked vs user-invoked

Toda `SKILL.md` neste repo é uma skill. O único eixo que as separa é a **invocação** — quem consegue alcançá-la:

- **User-invoked** — alcançável **apenas pelo humano digitando o nome dela**. Defina `disable-model-invocation: true` no frontmatter (Claude Code) e `policy.allow_implicit_invocation: false` em `agents/openai.yaml` (Codex). A `description` é **voltada ao humano**: um resumo de uma linha lido por uma pessoa navegando os slash-commands. Remova listas de trigger ("Use quando o usuário disser…").
- **Model-invoked** — alcançável por **model ou usuário**. O default: omita `disable-model-invocation` e o bloco `policy` do `agents/openai.yaml`. A `description` é **voltada ao model** e mantém rich trigger phrasing ("Use quando o usuário quiser…, mencionar…, pedir…") para a auto-invocação disparar. O teste para se uma skill deve seguir model-invoked: _o model poderia alcançá-la autonomamente de forma útil?_ (Reúso é a razão para extrair uma skill, não o teste.)

Cada harness exclui uma skill user-invoked do alcance do model à sua própria maneira, para nada além do humano poder dispará-la — nenhuma outra skill pode. Uma skill user-invoked pode invocar skills model-invoked, mas nunca alcançar outra user-invoked.

Toda skill também carrega um `agents/openai.yaml` ao lado da `SKILL.md`. Ele guarda metadata de UI do Codex — `interface.display_name` e `interface.short_description` para o skill picker — e, para skills user-invoked, o `policy.allow_implicit_invocation: false` que pareia com `disable-model-invocation`. Mantenha os dois em sincronia: uma skill é user-invoked em ambos os harnesses ou em nenhum.

Os `README.md` de bucket e o `README.md` top-level agrupam as entradas em **User-invoked** e **Model-invoked**.

## Dependências entre elas

Dependências são expressas como **invocação em prosa estilo `/skill`** ("Rode a skill `/grilling`"), não como cross-references profundas `../other-skill/FILE.md`. Docs de reference compartilhados vivem dentro da skill que os possui; outras skills alcançam esse material invocando a skill, não linkando entre pastas.

## Trabalho de domínio passivo vs ativo

Meramente _ler_ `CONTEXT.md` por vocabulário é um pointer de prosa de uma linha, não a skill `domain-modeling`. Só a disciplina ativa de construir/afiar (desafiar termos, cenários de edge-case, escrever ADRs, atualizar `CONTEXT.md` inline) é `domain-modeling`.
