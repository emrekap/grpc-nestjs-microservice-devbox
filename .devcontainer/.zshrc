plugins=(git zsh-syntax-highlighting history-substring-search zsh-autosuggestions zsh-completions k)

source $ZSH/oh-my-zsh.sh

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# setting up fuzzy filter (required by enhancd)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag -g ""';
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# setting up enhancd
source ~/.enhancd/init.sh
export ENHANCD_FILTER=fzy:fzf;
export ENHANCD_HOOK_AFTER_CD='ls -A';

# setting up history-substring-search
source "$ZSH_CUSTOM/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"

# setting up a few application related env vars to disable telemetry
export NEXT_TELEMETRY_DISABLED=1

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
autoload -U compinit && compinit -u

alias k='k -a'

# alias docker commands
alias docker="sudo docker"
alias docker-compose="sudo docker-compose"