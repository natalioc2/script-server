#!/usr/bin/env bash
#
# aliases.sh
# Aliases inspirados en Oh My Zsh

# --- Navegación ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -='cd -'

# --- Listado ---
alias ls='ls --color=auto'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

# --- Utilidades ---
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'

# --- Historial ---
alias h='history'
alias j='jobs -l'

# --- Seguridad ---
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# --- Sistema ---
alias cls='printf "\033c"'
alias reload='source ~/.zshrc'
k
