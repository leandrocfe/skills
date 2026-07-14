---
name: code-review
description: Revisa as mudanças desde um ponto fixo (commit, branch, tag ou merge-base) em dois eixos — Standards (o código segue os padrões de codificação documentados deste repo?) e Spec (o código faz o que a issue/spec de origem pediu?). Roda as duas revisões em sub-agents paralelos e reporta lado a lado. Use quando o usuário quiser revisar um branch, um PR, mudanças em andamento, ou pedir para "revisar desde X".
---

Revisão em dois eixos do diff entre `HEAD` e um ponto fixo fornecido pelo usuário:

- **Standards** — o código está de acordo com os padrões de codificação documentados deste repo?
- **Spec** — o código implementa fielmente a issue / spec / PRD de origem?

Os dois eixos rodam como **sub-agents paralelos**, para que não poluam o contexto um do outro, e então esta skill agrega os achados.

O issue tracker deve ter sido fornecido a você — rode `/setup-leandrocfe-skills` se `docs/agents/issue-tracker.md` estiver faltando.

## Processo

### 1. Fixe o ponto de referência

O ponto fixo é o que o usuário disser — um SHA de commit, nome de branch, tag, `main`, `HEAD~5`, etc. Se ele não especificar, pergunte.

Capture o comando de diff uma vez: `git diff <ponto-fixo>...HEAD` (three-dot, para que a comparação seja contra o merge-base). Anote também a lista de commits via `git log <ponto-fixo>..HEAD --oneline`.

Antes de seguir, confirme que o ponto fixo resolve (`git rev-parse <ponto-fixo>`) e que o diff não está vazio. Uma ref inválida ou um diff vazio devem falhar aqui — não dentro de dois sub-agents paralelos.

### 2. Identifique a fonte da spec

Procure a spec de origem, nesta ordem:

1. Referências a issues nas mensagens de commit (`#123`, `Closes #45`, `!67` no GitLab, etc.) — busque via o workflow em `docs/agents/issue-tracker.md`.
2. Um caminho que o usuário passou como argumento.
3. Um arquivo de spec/PRD sob `docs/`, `specs/` ou `.scratch/` que bata com o nome do branch ou da feature.
4. Se nada for encontrado, pergunte ao usuário onde está a spec. Se ele disser que não existe, o sub-agent de **Spec** é pulado e reporta "nenhuma spec disponível".

### 3. Identifique as fontes de standards

Qualquer coisa no repo que documente como o código deve ser escrito, como `CODING_STANDARDS.md` ou `CONTRIBUTING.md`.

Além do que o repo documenta, o eixo Standards sempre carrega a **smell baseline** abaixo — um conjunto fixo de code smells do Fowler (_Refactoring_, cap. 3) que se aplica mesmo quando o repo não documenta nada. Duas regras a governam:

- **O repo tem precedência.** Um padrão documentado do repo sempre vence; onde ele endossar algo que a baseline sinalizaria, suprima o smell.
- **Sempre um judgement call.** Cada smell é uma heurística rotulada ("possível Feature Envy"), nunca uma violação dura — e, como qualquer standard aqui, pule o que a tooling já garante.

Cada smell se lê como *o que é* → *como corrigir*; confronte-os com o diff:

- **Mysterious Name** — uma função, variável ou tipo cujo nome não revela o que faz ou guarda. → renomeie; se nenhum nome honesto aparecer, o design está turvo.
- **Duplicated Code** — o mesmo formato de lógica aparece em mais de um hunk ou arquivo da mudança. → extraia o formato compartilhado e chame-o dos dois lados.
- **Feature Envy** — um método que acessa os dados de outro objeto mais do que os seus próprios. → mova o método para junto dos dados que ele inveja.
- **Data Clumps** — os mesmos poucos campos ou parâmetros andam sempre juntos (um tipo querendo nascer). → junte-os num tipo só e passe esse tipo.
- **Primitive Obsession** — um primitivo ou string fazendo as vezes de um conceito de domínio que merece o próprio tipo. → dê ao conceito seu próprio tipo pequeno.
- **Repeated Switches** — o mesmo `switch`/cascata de `if` sobre o mesmo tipo se repete pela mudança. → substitua por polimorfismo, ou por um mapa único compartilhado pelos dois sites.
- **Shotgun Surgery** — uma única mudança lógica força edições espalhadas por muitos arquivos do diff. → reúna o que muda junto num módulo só.
- **Divergent Change** — um arquivo ou módulo é editado por várias razões não relacionadas. → separe, para que cada módulo mude por uma razão só.
- **Speculative Generality** — abstração, parâmetros ou hooks adicionados para necessidades que a spec não tem. → apague; faça inline de volta até que uma necessidade real apareça.
- **Message Chains** — navegação longa `a.b().c().d()` da qual o caller não deveria depender. → esconda o percurso atrás de um método no primeiro objeto.
- **Middle Man** — uma classe ou função que basicamente só delega adiante. → corte-a, chame o alvo real direto.
- **Refused Bequest** — uma subclasse ou implementador que ignora ou sobrescreve a maior parte do que herda. → largue a herança, use composição.

### 4. Suba os dois sub-agents em paralelo

Envie uma única mensagem com duas chamadas da tool `Agent`. Use o subagent `general-purpose` para ambos.

**Prompt do sub-agent de Standards** — inclua:

- O comando de diff completo e a lista de commits.
- A lista de arquivos-fonte de standards que você achou no passo 3, **mais a smell baseline do passo 3** colada por inteiro — o sub-agent não tem outro acesso a ela.
- O briefing: "Reporte — por arquivo/hunk quando relevante — (a) todo lugar em que o diff viola um standard documentado: cite o standard (arquivo + a regra); e (b) qualquer smell da baseline que você identificar: nomeie-o e cite o hunk. Distinga violações duras de judgement calls — quebras de standard documentado podem ser duras, mas smells da baseline são sempre judgement calls, e um standard documentado do repo tem precedência sobre a baseline. Pule o que a tooling já garante. Menos de 400 palavras."

**Prompt do sub-agent de Spec** — inclua:

- O comando de diff e a lista de commits.
- O caminho ou o conteúdo já buscado da spec.
- O briefing: "Reporte: (a) requisitos que a spec pediu e estão faltando ou parciais; (b) comportamento no diff que não foi pedido (scope creep); (c) requisitos que parecem implementados mas cuja implementação parece errada. Cite a linha da spec para cada achado. Menos de 400 palavras."

Se a spec estiver faltando, pule o sub-agent de Spec e registre isso no relatório final.

### 5. Agregue

Apresente os dois relatórios sob os títulos `## Standards` e `## Spec`, na íntegra ou levemente limpos. **Não** funda nem reordene os achados — os dois eixos são deliberadamente separados (veja _Por que dois eixos_).

Termine com um resumo de uma linha: total de achados por eixo, e o pior problema _dentro de cada eixo_ (se houver). Não eleja um vencedor único entre os eixos — essa é exatamente a reordenação que a separação existe para impedir.

## Por que dois eixos

Uma mudança pode passar em um eixo e falhar no outro:

- Código que segue todos os standards mas implementa a coisa errada → **Standards passa, Spec falha.**
- Código que faz exatamente o que a issue pediu mas quebra as convenções do projeto → **Spec passa, Standards falha.**

Reportá-los separadamente impede que um eixo mascare o outro.
