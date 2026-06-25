---
name: resolving-merge-conflicts
description: "Use quando precisar resolver um conflito de git merge/rebase em andamento."
---

1. **Veja o estado atual** do merge/rebase. Confira o histórico do git e os arquivos em conflito.

2. **Encontre as fontes primárias** de cada conflito. Entenda profundamente por que cada mudança foi feita e qual era a intenção original. Leia as mensagens de commit, verifique os PRs, verifique issues/tickets originais.

3. **Resolva cada hunk.** Preserve ambas as intenções quando possível. Onde forem incompatíveis, escolha a que bate com o objetivo declarado do merge e note o trade-off. **Não** invente comportamento novo. Sempre resolva; nunca `--abort`.

4. Descubra os **checks automatizados** do projeto e rode — tipicamente typecheck, depois testes, depois format. Corrija qualquer coisa que o merge quebrou.

5. **Finalize o merge/rebase.** Stage tudo e commit. Se estiver em rebase, continue o processo de rebase até todos os commits serem rebaseados.
