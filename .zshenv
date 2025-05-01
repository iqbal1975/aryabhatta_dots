# ███████╗███████╗██╗  ██╗
# ╚══███╔╝██╔════╝██║  ██║
#   ███╔╝ ███████╗███████║
#  ███╔╝  ╚════██║██╔══██║
# ███████╗███████║██║  ██║
# ╚══════╝╚══════╝╚═╝  ╚═╝
##########################

#!/usr/bin/env zsh
# Environment variables

# export BROWSER='brave'
# export BROWSER='firefox'
# export BROWSER='floorp'
export BROWSER='vivaldi'
# export BROWSER='zen-browser'
export CLIPCOPY='wl-copy'
export CLIPPASTE='wl-paste'
export CM_LAUNCHER='rofi'
export EDITOR='vi'
export PAGER='less'
export LESSHISTFILE=-
export SHELL=/usr/bin/zsh
export TERMINAL='kitty'
export TERMINAL_COMMAND=kitty
export EDITOR_TERM="$TERMINAL_COMMAND -e $EDITOR"

export DIFFPROG='meld'
export DIFFSEARCHPATH="/boot /etc /usr"
export MERGEPROG="git merge-file -p"

# >>> Miscellaneous >>>
export CARGO_HOME="$HOME/.config/.cargo"
export GOPATH="$HOME/.config/go"
export GOBIN="$GOPATH/bin"
export GTK_USE_PORTAL="1"
export PASSWORD_STORE_DIR="$HOME/.config/.password-store"
# <<< Miscellaneous <<<

# >>> AGS Initialize >>>
export ILLOGICAL_IMPULSE_VIRTUAL_ENV="$XDG_STATE_HOME/ags/.venv"
# <<< AGS Initialize <<<

# >>> asdf Initialize >>>
export ASDF_DATA_DIR=/home/iqbal/.asdf
export PATH="$ASDF_DATA_DIR/shims:$PATH"
# <<< asdf Initialize <<<

# >>> Anthropic Initialize >>>
export ANTHROPIC_API_KEY="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"
# <<< Anthropic Initialize <<<

# >>> ChatGPT Initialize >>>
export OPENAI_API_KEY="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"
# <<< ChatGPT Initialize <<<

# >>> Codestral Initialize >>>
export MISTRAL_API_KEY="ln7IftafUnTF7jFKVqSM9kuFPQw3tH56"
# <<< Codestrak Initialize <<<

# >>> Gemini Initialize >>>
export GEMINI_API_KEY="AIzaSyCDQZVpBdQOH9Y7bcxgr5cTynRR_pkZ0iM"
# <<< Gemini Initialize <<<

# >>> xAI Initialize >>>
export XAI_API_KEY="xai-UHKXabLaTugeL8myyt3pgbHfP6K05qSw0hdMdB8uTNK5DexK8jGoyBOmIWFaWguogj6PvX0T9cD6MzOU"
# <<< xAI Initialize <<<

# >>> Docker Host >>>
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
# <<< Docker Host <<<

# >>> Doom Emacs >>>
export DOOMDIR="$HOME/.config/doom"
export PATH=$PATH:$HOME/.emacs.d/bin
# <<< Doom Emacs <<<

# FZF
export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude=.git --exclude=node_modules'
export FZF_COMPLETION_TRIGGER=','
export FZF_DEFAULT_OPTS="
--layout=reverse --info=inline --height=80% --multi --cycle --margin=1 --border=rounded
--preview '([[ -f {} ]] && (bat --style=numbers --color=always --line-range=:500 {} || cat {})) || ([[ -d {} ]] \
&& (eza -Tl --group-directories-first --icons -L 2 --no-user {} | less)) || echo {} 2> /dev/null | head -200'
--prompt=' ' --pointer=' ' --marker=' '
--color='hl:148,hl+:154,prompt:blue,pointer:032,marker:010,bg+:000,gutter:000'
--preview-window=right:65%
--bind '?:toggle-preview'
--bind 'ctrl-a:select-all'
--bind 'ctrl-y:execute-silent(echo {+} | $CLIPCOPY)'
--bind 'ctrl-e:execute($TERMINAL $EDITOR {+})+reload(fzf)'"

export FZF_CTRL_T_COMMAND='fd -t f -HF -E=.git -E=node_modules'

# >>> Julia Threads Initialize >>>
export JULIA_NUM_THREADS=auto
# <<< Julia Threads Initialize <<<

# >>> Locale Initialize >>>
export LC_ALL="en_US.UTF-8"
# <<< Locale Initialize <<<

# >>> NPM Initialize >>>
# export NPM_CONFIG_PREFIX="/home/iqbal/.npm-global"
# export PATH="$PATH:$NPM_CONFIG_PREFIX/bin"
# <<< NPM Initialize <<<
# unset NPM_CONFIG_PREFIX

# >>> Steam Initialize >>>
export STEAM_ROOT="/steam/Steam"
# <<< Steam Initialize <<<

# >>> t-smart-tmux-session-manager Initialize >>>
export PATH="$PATH:$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin"
export T_SESSION_USE_GIT_ROOT="true"
export T_SESSION_NAME_INCLUDE_PARENT="true"
export FZF_TMUX_OPTS="-p 55%,60%"
export T_FZF_BORDER_LABEL=' Manage tmux Session '
# <<< t-smart-tmux-session-manager Initialize <<<

# >>> tmuxifier Initialize >>>
export PATH="$HOME/.config/tmux/plugins/tmuxifier/bin:$PATH"
# <<< tmuxifier Initialize <<<

# >>> Ruby Initialize >>>
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin"
# <<< Ruby Initialize <<

# >>> Rust initialize >>>
. "$HOME/.config/.cargo/env"
# <<< Rust initialize <<<

# >>> SUDO Initialize >>>
export SUDO_PROMPT="$(tput setab 1 setaf 7 bold)[sudo]$(tput sgr0) $(tput setaf 6)password for$(tput sgr0) $(tput setaf 5)%p$(tput sgr0): "
# <<< SUDO Initialize <<<

# >>> XDG Variables >>>
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
export XDG_STATE_HOME=${XDG_STATE_HOME:="$HOME/.local/state"}
# <<< XDG Variables <<<
