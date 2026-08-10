#!/usr/bin/env bash
# Human-in-the-loop reproduction loop.
# Copie este arquivo, edite os passos abaixo e rode.
# O agent roda o script; o usuário segue os prompts no terminal.
#
# Uso:
#   bash hitl-loop.template.sh
#
# Dois helpers:
#   step "<instruction>"          → mostra instrução, espera Enter
#   capture VAR "<question>"      → mostra pergunta, lê resposta em VAR
#
# No final, valores capturados são impressos como KEY=VALUE para o agent parsear.
#
# `capture` imprime o valor de volta no terminal, onde o agent o lê — então
# capture observações, e deixe o login para o usuário como um `step`.

set -euo pipefail

step() {
  printf '\n>>> %s\n' "$1"
  read -r -p "    [Enter quando pronto] " _
}

capture() {
  local var="$1" question="$2" answer
  printf '\n>>> %s\n' "$question"
  read -r -p "    > " answer
  printf -v "$var" '%s' "$answer"
}

# --- edite abaixo ---------------------------------------------------------

step "Abra a app em http://localhost:3000 e faça login."

capture ERRORED "Clique no botão 'Export'. Deu erro? (y/n)"

capture ERROR_MSG "Cole a mensagem de erro (ou 'none'):"

# --- edite acima ---------------------------------------------------------

printf '\n--- Capturado ---\n'
printf 'ERRORED=%s\n' "$ERRORED"
printf 'ERROR_MSG=%s\n' "$ERROR_MSG"
