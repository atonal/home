# Kill all running containers.
alias dkillall='docker kill $(docker ps -q)'

# Delete all stopped containers.
alias dcleanc='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'

# Delete all untagged images.
alias dcleani='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'

# Delete all stopped containers and untagged images.
alias dclean='dcleanc || true && dcleani'

# ctop
alias ctop='docker run --rm -ti --name=ctop -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorlab/ctop:latest'

# print current git branch name
alias bn='git rev-parse --abbrev-ref HEAD'

alias watchgit='watch -c -n 0,5 git -c color.ui=always lga'

alias g='git'

# dive
alias dive='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest'

# git
alias gtop='cd $(git rev-parse --show-toplevel)'
alias xb='git branch --show-current | xclip -r -i'

# vimbash
alias öq='exit'

# systemctl
alias sc='systemctl'

alias k='kubectl'
alias kns='kubens'
alias kctx='kubectx'
alias kcx='kubectx'
alias kx='kubectx'

# Autocomplete for aliases - MUST be the last line
complete -F _complete_alias "${!BASH_ALIASES[@]}"
