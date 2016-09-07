# Dotfiles
export DOTFILES="${HOME}/.dotfiles"

# Load zgen framework
ZGEN_DIR="${DOTFILES}/.zgen"

# show dots for completion
COMPLETION_WAITING_DOTS="true"

# highlighting options
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern root line)

# disable auto activate virtualenv
DISABLE_VENV_CD=1

# global variables
export EDITOR="vim"
export VISUAL="vim"
export WORKON_HOME="${HOME}/.virtualenvs"

source "${DOTFILES}/zgen/zgen.zsh"

# plugins
if ! zgen saved; then
	echo "Creating a zgen save"
	
	zgen oh-my-zsh

	zgen oh-my-zsh plugins/colored-man-pages
	zgen oh-my-zsh plugins/common-aliases
	zgen oh-my-zsh plugins/git
	zgen oh-my-zsh plugins/osx
	zgen oh-my-zsh plugins/rsync
	zgen oh-my-zsh plugins/tmux
	zgen oh-my-zsh plugins/virtualenv
	zgen oh-my-zsh plugins/virtualenvwrapper

	zgen load zsh-users/zsh-syntax-highlighting
	zgen load zsh-users/zsh-history-substring-search
	zgen load mafredri/zsh-async
	zgen load psprint/zsh-navigation-tools

	zgen load "$DOTFILES/colorful-theme-zsh"

	zgen save
fi

[ -f ~/.zshrc_local ] && source ~/.zshrc_local

# bind UP and DOWN arrow keys for substring search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind INS for overwrite mode
bindkey "$terminfo[kich1]" overwrite-mode

# Inserts 'sudo ' at the beginning of the line.
function prepend-sudo {
	if [[ "$BUFFER" != su(do|)\ * ]]; then
		BUFFER="sudo $BUFFER"
		(( CURSOR += 5 ))
		zle redisplay
	fi
}
zle -N prepend-sudo
bindkey "^s" prepend-sudo

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

