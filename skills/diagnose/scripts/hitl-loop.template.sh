#!/usr/bin/env bash
# Loop de reprodução human-in-the-loop.
# Copie este arquivo, edite os passos abaixo, rode.
# Agente roda o script; usuário segue prompts no terminal.
#
# Uso:
#   bash hitl-loop.template.sh
#
# Dois helpers:
#   step "<instrução>"           → mostra instrução, espera Enter
#   capture VAR "<pergunta>"     → mostra pergunta, lê resposta em VAR
#
# Ao fim, valores capturados são impressos como KEY=VALUE pra agente parsear.

set -euo pipefail

step() {
  printf '\n>>> %s\n' "$1"
  read -r -p "    [Enter quando terminar] " _
}

capture() {
  local var="$1" question="$2" answer
  printf '\n>>> %s\n' "$question"
  read -r -p "    > " answer
  printf -v "$var" '%s' "$answer"
}

# --- editar abaixo -------------------------------------------------------

step "Abra a app em http://localhost:3000 e faça login."

capture DEU_ERRO "Clique no botão 'Exportar'. Deu erro? (s/n)"

capture MSG_ERRO "Cole a mensagem de erro (ou 'nenhum'):"

# --- editar acima --------------------------------------------------------

printf '\n--- Capturado ---\n'
printf 'DEU_ERRO=%s\n' "$DEU_ERRO"
printf 'MSG_ERRO=%s\n' "$MSG_ERRO"
