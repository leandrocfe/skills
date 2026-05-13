---
name: write-a-skill
description: "Cria novas agent skills com estrutura correta, progressive disclosure e recursos empacotados. Use quando o usuário quiser criar, escrever ou construir uma skill nova. Use when user wants to create, write, or build a new skill."
---

# Writing Skills

## Processo

1. **Junte requisitos** — pergunte ao usuário:
   - Que task/domain a skill cobre?
   - Que casos de uso específicos deve tratar?
   - Precisa de scripts executáveis ou só instruções?
   - Algum material de referência para incluir?

2. **Rascunhe a skill** — crie:
   - SKILL.md com instruções concisas
   - Arquivos de referência adicionais se conteúdo exceder 500 linhas
   - Scripts utilitários se operações determinísticas forem necessárias

3. **Revise com o usuário** — apresente o rascunho e pergunte:
   - Isso cobre seus casos de uso?
   - Falta algo ou está confuso?
   - Alguma seção deveria ser mais/menos detalhada?

## Estrutura da Skill

```
skill-name/
├── SKILL.md           # Instruções principais (obrigatório)
├── REFERENCE.md       # Docs detalhados (se necessário)
├── EXAMPLES.md        # Exemplos de uso (se necessário)
└── scripts/           # Scripts utilitários (se necessário)
    └── helper.js
```

## SKILL.md Template

```md
---
name: skill-name
description: "Descrição breve da capacidade. Use quando [triggers específicos]."
---

# Skill Name

## Quick start

[Exemplo mínimo funcional]

## Workflows

[Processos passo-a-passo com checklists para tasks complexas]

## Advanced features

[Link para arquivos separados: Veja [REFERENCE.md](REFERENCE.md)]
```

## Requisitos do Description

O description é **a única coisa que seu agente vê** ao decidir qual skill carregar. É surfada no system prompt junto a todas as outras skills instaladas. Seu agente lê esses descriptions e escolhe a skill relevante baseado no pedido do usuário.

**Objetivo**: Dê ao seu agente exatamente o suficiente para saber:

1. Que capacidade essa skill oferece
2. Quando/por que disparar (keywords específicas, contextos, tipos de arquivo)

**Formato**:

- Máx 1024 chars
- Escreva em terceira pessoa
- Primeira frase: o que faz
- Segunda frase: "Use quando [triggers específicos]"

**Exemplo bom**:

```
Extrai texto e tabelas de arquivos PDF, preenche forms, faz merge de documents. Use quando trabalhar com arquivos PDF ou quando o usuário mencionar PDFs, forms ou extração de documentos.
```

**Exemplo ruim**:

```
Ajuda com documentos.
```

O exemplo ruim não dá ao agente jeito de distinguir isso de outras skills de documento.

## Quando Adicionar Scripts

Adicione scripts utilitários quando:

- A operação é determinística (validation, formatting)
- O mesmo código seria gerado repetidamente
- Erros precisam de tratamento explícito

Scripts economizam tokens e melhoram confiabilidade vs código gerado.

## Quando Quebrar Arquivos

Quebre em arquivos separados quando:

- SKILL.md excede 100 linhas
- Conteúdo tem domínios distintos (schemas de finance vs sales)
- Features avançadas são raramente necessárias

## Checklist de Revisão

Depois do rascunho, verifique:

- [ ] Description inclui triggers ("Use quando...")
- [ ] SKILL.md abaixo de 100 linhas
- [ ] Sem info sensível a tempo
- [ ] Terminologia consistente
- [ ] Exemplos concretos incluídos
- [ ] Referências um nível só de profundidade
