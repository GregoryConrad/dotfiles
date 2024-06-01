# Up/down arrow key prefix completions
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Homebrew command completions
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

# Prompt colors: https://unix.stackexchange.com/a/124409
function precmd() {
  PROMPT="%F{189}$(_print_time)$(_print_directory)$(_print_vcs)%k%f "
}

function _powerline_section() {
  echo "%K{$2}%F{000} $1 %F{$2}"
}

function _print_time() {
  _powerline_section '%T' '189'
}

function _print_vcs() {
  branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
  if [[ $branch == "" ]];
  then
    :
  else
    _powerline_section " %B$branch%b" '177'
  fi
}

function _print_directory() {
  if git_root=$(git rev-parse --show-toplevel 2> /dev/null)
  then
    _powerline_section " ${PWD/$(dirname $git_root)\//}" '081'
  else
    _powerline_section '%~' '111'
  fi
}
