# vim:ft=zsh ts=4 sw=4 sts=4
#
# Colorful Oh-my-zsh theme
#
# Inspired by agnoster, pure and prezto-sorin-theme
#
# Author: Alex Malyshev <malyshevalex@gmail.com>
#
#

#
# 16 Terminal Colors
# -- ---------------
#  0 black
#  1 red
#  2 green
#  3 yellow
#  4 blue
#  5 magenta
#  6 cyan
#  7 white
#  8 bright black
#  9 bright red
# 10 bright green
# 11 bright yellow
# 12 bright blue
# 13 bright magenta
# 14 bright cyan
# 15 bright white
#

function expand-or-complete-with-dots() {
    # toggle line-wrapping off and back on again
    [[ -n "$terminfo[rmam]" && -n "$terminfo[smam]" ]] && echoti rmam
    print -Pn "%{%B...%b%}"
    [[ -n "$terminfo[rmam]" && -n "$terminfo[smam]" ]] && echoti smam

    zle expand-or-complete
    zle redisplay
}
zle -N expand-or-complete-with-dots

# Enables terminal application mode and updates editor information.
function zle-line-init {
    # The terminal must be in application mode when ZLE is active for $terminfo
    # values to be valid.
    if (( $+terminfo[smkx] )); then
        # Enable terminal application mode.
        echoti smkx
    fi

    # Update editor information.
    zle editor-info
}
zle -N zle-line-init

# Disables terminal application mode and updates editor information.
    function zle-line-finish {
    # The terminal must be in application mode when ZLE is active for $terminfo
    # values to be valid.
    if (( $+terminfo[rmkx] )); then
        # Disable terminal application mode.
        echoti rmkx
    fi

    # Update editor information.
    zle editor-info
}
zle -N zle-line-finish

# Toggles emacs overwrite mode and updates editor information.
function overwrite-mode {
    zle .overwrite-mode
    zle editor-info
}
zle -N overwrite-mode


function editor-info {
    if [[ "$ZLE_STATE" == *overwrite* ]]; then
        _prompt_overwrite='O'
    else
        _prompt_overwrite=''
    fi
    zle reset-prompt
    zle -R
}
zle -N editor-info

function _prompt_async_git_info {
    cd -q "$*"
    local git_info
    if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        local ref mode repo_path repo_status
        repo_path=$(git rev-parse --git-dir 2>/dev/null)
        ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
        ref=${ref/refs\/heads\//$'\ue0a0' }
        if [[ -e "${repo_path}/BISECT_LOG" ]]; then
            mode="bisect"
        elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
            mode="merge"
        elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
            mode="rebase"
        fi
        mode=${mode:+" %F{7}[%F{9}$mode%F{7}]%f"}
        repo_status=$(git_prompt_status)
        git_info=" %F{2}$ref%f$mode$repo_status"
    fi
    echo $git_info
}

function _prompt_async_tasks {
    ((!${_prompt_async_init:-0})) && {
        async_start_worker "colorful_prompt" -u -n
        async_register_callback "colorful_prompt" _prompt_async_callback
        _prompt_async_init=1
    }
    async_flush_jobs "colorful_prompt" _prompt_async_git_info
    async_job "colorful_prompt" _prompt_async_git_info "${PWD}"

}

function _prompt_async_callback {
    local job=$1
    local output=$3

    case "${job}" in
	   _prompt_async_git_info)
	        _prompt_git_info=$output
            zle reset-prompt
	   ;;
    esac
}

function _prompt_precmd {
    unset _prompt_pwd
    unset _prompt_jobs
    unset _prompt_git_info
    unset _prompt_virtualenv
    _prompt_async_tasks

    # Format PWD
    local pwd="${PWD/#$HOME/~}"

    if [[ "$pwd" == (#m)[/~] ]]; then
        _prompt_pwd="$MATCH"
        unset MATCH
    else
        _prompt_pwd="${${${${(@j:/:M)${(@s:/:)pwd}##.#?}:h}%/}//\%/%%}/${${pwd:t}//\%/%%}"
    fi

    # Is there are background jobs?
    [[ $(jobs -l | wc -l) -gt 0 ]] && _prompt_jobs='Y'

    
    local virtualenv_path="$VIRTUAL_ENV"
    if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
        _prompt_virtualenv=" %B%F{11}⚒  `basename $virtualenv_path`%f%b"
    fi
}

function _prompt_setup {
    setopt extendedglob
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd _prompt_precmd

    # define prompts

    PROMPT='${SSH_TTY:+"%F{2}%n%f%F{7}@%f%F{3}%m%f "}%F{4}${_prompt_pwd}%(!. %B%F{1}#%f%b.) %b%F{1}❯%F{3}❯%F{2}❯%f '
    RPROMPT='${_prompt_overwrite:+" %F{3}♺%f"}%(?:: %F{1}⏎ $?%f)${_prompt_jobs:+" %F{6}⚙%f"}${_prompt_virtualenv}${_prompt_git_info}'

    # define oh-my-zsh git styles
    ZSH_THEME_GIT_PROMPT_ADDED=' %F{2}✚%f'
    ZSH_THEME_GIT_PROMPT_AHEAD=' %F{13}⬆%f%'
    ZSH_THEME_GIT_PROMPT_BEHIND=' %F{13}⬇%f'
    ZSH_THEME_GIT_PROMPT_DELETED=' %F{1}✖%f'
    ZSH_THEME_GIT_PROMPT_MODIFIED=' %F{4}✱%f'
    ZSH_THEME_GIT_PROMPT_RENAMED=' %F{5}➜%f'
    ZSH_THEME_GIT_PROMPT_STASHED=' %F{6}✭%f'
    ZSH_THEME_GIT_PROMPT_UNMERGED=' %F{3}═%f'
    ZSH_THEME_GIT_PROMPT_UNTRACKED=' %F{7}◼%f'
}

_prompt_setup

