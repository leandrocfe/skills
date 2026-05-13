# Linguagem

**Issue tracker**:
A ferramenta que hospeda as issues do repo — GitHub Issues, Linear, uma convenção local em markdown sob `.scratch/`, ou similar. Skills como `to-issues`, `to-prd`, `triage` e `qa` leem e escrevem nele.
_Evite_: gerenciador de backlog, backend de backlog, host de issues

**Issue**:
Uma única unidade de trabalho rastreada dentro de um **Issue tracker** — um bug, task, PRD ou slice produzido por `to-issues`.
_Evite_: ticket (use só ao citar sistemas externos que chamam de tickets)

**Triage role**:
Um label canônico de máquina-de-estado aplicado a uma **Issue** durante a triagem (ex.: `needs-triage`, `ready-for-afk`). Cada role mapeia para uma string de label real no **Issue tracker** via `docs/agents/triage-labels.md`.

## Relações

- Um **Issue tracker** contém várias **Issues**
- Uma **Issue** carrega uma **Triage role** por vez

## Ambiguidades sinalizadas

- "backlog" era usado antes para significar tanto a *ferramenta* que hospeda issues quanto o *corpo de trabalho* dentro dela — resolvido: a ferramenta é o **Issue tracker**; "backlog" não é mais usado como termo de domínio.
- "backend de backlog" / "gerenciador de backlog" — resolvido: colapsados em **Issue tracker**.
