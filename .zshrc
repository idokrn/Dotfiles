# Env
export PATH=/Users/idok/.cargo/bin:$PATH
export PATH=/opt/mybin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH
export AWS_PROFILE=int
export TERRAGRUNT_TFPATH=/opt/homebrew/bin/terraform
export GITLAB_TOKEN="$(cat /Users/idok/.ssh/gitlab/glab_token.txt)"
if type brew &>/dev/null
then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"    
    autoload -Uz compinit
    compinit
fi

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
eval "$(starship init zsh)"
eval "$(rbenv init - zsh)"

source /Users/idok/.config/zsh/.aliases.zsh
source /Users/idok/.config/zsh/.functions.zsh

autoload -U +X bashcompinit && bashcompinit

complete -o nospace -C /opt/homebrew/bin/terraform terraform
complete -o nospace -C /opt/homebrew/bin/terraform terragrunt

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey "^[end" end-of-line
bindkey "^[begin" beginning-of-line
 
