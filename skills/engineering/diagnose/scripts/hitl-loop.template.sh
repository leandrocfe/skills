#!/usr/bin/env bash
# Loop de reprodução human-in-the-loop.
# Copie este arquivo, edite os passos abaixo e rode.
# O agente roda o script; o usuário segue os prompts no terminal dele.
#
# Uso:
#   bash hitl-loop.template.sh
#
# Dois helpers:
#   step "<instrução>"            → mostra instrução, espera Enter
#   capture VAR "<pergunta>"      → mostra pergunta, lê resposta para VAR
#
# No fim, valores capturados são impressos como KEY=VALUE para o agente parsear.

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

# --- edite abaixo -------------------------------------------------------

step "Abra o app em http://localhost:3000 e faça sign in."

capture ERRORED "Clique no botão 'Export'. Lançou erro? (y/n)"

capture ERROR_MSG "Cole a mensagem de erro (ou 'none'):"

# --- edite acima --------------------------------------------------------

printf '\n--- Capturado ---\n'
printf 'ERRORED=%s\n' "$ERRORED"
printf 'ERROR_MSG=%s\n' "$ERROR_MSG"
