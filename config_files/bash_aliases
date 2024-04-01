## Alias for the fuck
alias fuck='eval $(thefuck $(fc -ln -1)); history -r'

## Alias for git hub copilot
alias ghcs='gh copilot suggest -t shell'
alias ghce='gh copilot explain'

# git aliases - taken from oh-my-zsh's git plugin and translated to bash
#     https://github.com/robbyrussell/oh-my-zsh/wiki/Cheatsheet#helpful-aliases-for-common-git-tasks
#     https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/git/git.plugin.zsh

function git_main_branch_name(){
  echo $( git remote show origin | sed -n '/HEAD branch/s/.*: //p' )
}

function git_current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

function git_current_repository() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo $(git remote -v | cut -d':' -f 2)
}

alias ga='git add'
alias gaa='git add --all'

alias gb='git branch'
alias gbD='git branch -D'

alias gcb='git checkout -b'
alias gcd='git checkout develop'
alias gcm='git checkout "$(git_main_branch_name)"'
alias gco='git checkout'
alias gcq='git checkout quality'
alias gcmsg='git commit -m'

alias gl='git pull'
alias gp='git push'
alias ggpull='git pull origin "$(git_current_branch)"'
alias ggpush='git push origin "$(git_current_branch)"'
alias gst='git status'
