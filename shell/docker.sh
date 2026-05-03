# docker config

docker-aliases() {
cat <<EOF
#=============================================================================#
#                                                                             #
#     # Useful Docker Aliases                                                 #
#                                                                             #
#     dc                : docker compose                                      #
#     dcver             : docker compose version                              #
#     dup               : docker compose up -d                                #
#     ddown             : docker compose down                                 #
#     dex <container>   : execute a bash shell inside the RUNNING <container> #
#     dlog <container>  : docker logs -f <container>                          #
#     drm               : remove all exited containers                        #
#     drmid             : remove all dangling images                          #
#     dstop             : Stop all containers                                 #
#     dclean            : Clean Docker system                                 #
#     dins <container>  : docker inspect <container>                          #
#     dim               : docker images                                       #
#     dip               : IP addresses of all running containers              #
#     dnames            : names of all running containers                     #
#     dver              : docker version                                      #
#     dinfo             : docker info                                         #
#     dreload           : docker reload bash file                             #
#     dps               : docker ps                                           #
#     dpsa              : docker ps -a                                        #
#                                                                             #
#=============================================================================#
EOF
}

function dnames-fn {
	for ID in `docker ps | awk '{print $1}' | grep -v 'CONTAINER'`
	do
    	docker inspect $ID | grep Name | head -1 | awk '{print $2}' | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
	done
}

function dip-fn {
    echo "IP addresses of all named running containers"

    for DOC in `dnames-fn`
    do
        IP=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "$DOC"`
        OUT+=$DOC'\t'$IP'\n'
    done
    echo -e $OUT | column -t
    unset OUT
}

function drmid-fn {
       imgs=$(docker images -q -f dangling=true)
       [ ! -z "$imgs" ] && docker rmi "$imgs" || echo "no dangling images."
}

function drms-fn { docker stop $1;docker rm $1;}
function dins-fn { docker inspect "$1";}
function dlog-fn { docker logs -f "$1";}
function dexec-fn { docker exec -it "$1" bash || docker exec -it "$1" sh; }

alias dc="docker-compose"
alias dcver="docker compose version"
alias dup="docker compose up -d"
alias ddown="docker compose down"
alias dex=dexec-fn
alias dlog=dlog-fn
alias drm='docker rm $(docker ps -aq)'
# alias drm='docker rm $(docker ps --all -q -f status=exited)'
alias drms=drms-fn
# alias drmi='docker rmi $(docker images -q)'
alias drmid=drmid-fn
alias dstop='docker stop $(docker ps -q)'
alias dclean='docker system prune -af'

alias dins=dins-fn
alias dim="docker images"
alias dip=dip-fn
alias dnames=dnames-fn

alias dver="docker --version"
alias dinfo="docker info"
alias dreload="source ~/.bashrc"
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dpsa='docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}"'
alias dpsx='docker ps -s --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Size}}"'
alias dsize='docker system df'
alias dprune='docker system prune -a --volumes'
