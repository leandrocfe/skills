# Candidatos a Refactor

Depois do ciclo TDD, procure por:

- **Duplicação** → Extrair função/classe
- **Métodos longos** → Quebrar em helpers privados (mantenha testes na interface pública)
- **Shallow modules** → Combinar ou aprofundar
- **Feature envy** → Mover lógica para onde os dados vivem
- **Primitive obsession** → Introduzir value objects
- **Código existente** que o código novo revela como problemático
