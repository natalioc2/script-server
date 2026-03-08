git-aliases() {
cat <<EOF
#=============================================================================#
#                                                                             #
#     # Git Aliases y Comandos para trabajo en 2 ramas y 2 PCs                #
#                                                                             #
#     gnew <rama>       : git checkout -b <rama>           (crear y cambiar)  #
#     gpushu <rama>     : git push -u origin <rama>        (subir y vincular) #
#     gfetch            : git fetch                        (descargar ramas)  #
#     gco <rama>        : git checkout <rama>              (cambiar rama)     #
#     gpull <rama>      : git pull origin <rama>           (traer cambios)    #
#     gadd              : git add .                        (agregar cambios)  #
#     gcm "mensaje"     : git commit -m "mensaje"          (hacer commit)     #
#     gpush <rama>      : git push origin <rama>           (subir cambios)    #
#     gcomain           : git checkout main                (ir a main)        #
#     gpullmain         : git pull origin main             (actualizar main)  #
#     gmerge <rama>     : git merge <rama>                 (fusionar rama)    #
#     gpushmain         : git push origin main             (subir main)       #
#     grmd <rama>       : git branch -d <rama>             (borrar local)     #
#     grmremote <rama>  : git push origin --delete <rama>  (borrar remota)    #
#                                                                             #
#=============================================================================#
EOF
}

alias gnew='f() { git checkout -b "$1"; }; f'
alias gpushu='f() { git push -u origin "$1"; }; f'
alias gfetch='git fetch'
alias gco='f() { git checkout "$1"; }; f'
alias gpull='f() { git pull origin "$1"; }; f'
alias gadd='git add .'
alias gcm='f() { git commit -m "$1"; }; f'
alias gpush='f() { git push origin "$1"; }; f'
alias gcomain='git checkout main'
alias gpullmain='git pull origin main'
alias gmerge='f() { git merge "$1"; }; f'
alias gpushmain='git push origin main'
alias grmd='f() { git branch -d "$1"; }; f'
alias grmremote='f() { git push origin --delete "$1"; }; f'
