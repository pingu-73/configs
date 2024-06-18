# integrating fzf for zsh https://github.com/junegunn/fzf
source <(fzf --zsh)
# $(brew --prefix)/opt/fzf/install   # https://p.ip.fi/B7mZ
# To use fzf in Vim, add the following line to your .vimrc:
# set rtp+=/opt/homebrew/opt/fzf

# activate the autosuggestions https://github.com/zsh-users/zsh-autosuggestions 
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# setup zsh-autocomplete to path https://github.com/marlonrichert/zsh-autocomplete
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# setup pure on shell
fpath+=("$(brew --prefix)/share/zsh/site-functions")

# Activating pure prompt
autoload -U promptinit; promptinit
zmodload zsh/nearcolor
# zstyle :prompt:pure:path color white
# zstyle ':prompt:pure:prompt:*' color cyan
zstyle :prompt:pure:git:stash show yes
prompt pure

# setup zoxide on shell
eval "$(zoxide init zsh)"


# arm64 -> x86_64 
alias arm="env /usr/bin/arch -arm64 /bin/zsh --login"
# alias intel="env /usr/bin/arch -x86_64 /bin/zsh --login"
alias x86_64="arch -x86_64 zsh"

export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

alias ll="exa -lah"
alias l="exa --classify"
alias lb="exa -lah --inode --blocks"
etre() {
  local level=${1:-1}
  exa --tree --level=$level
}
alias python='python3'
alias pip='pip3'
alias hd='xxd' # for hex-dump

# pkg-config
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:/usr/lib/pkgconfig"

# gpg
export GPG_TTY=$(tty)


if [ "$(arch)" = "arm64" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi


# To use gnu commands with their normal names, you can add a "gnubin" directory to your PATH with:
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
