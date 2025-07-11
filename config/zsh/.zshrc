#!/usr/bin/env zsh

case "$TERM" in
	tramp)
		# TRAMP is really picky so just disable zsh and bail out
		unsetopt zle
		unsetopt prompt_cr
		unsetopt prompt_subst

		if whence -w precmd >/dev/null; then
			unfunction precmd
		fi

		if whence -w preexec >/dev/null; then
			unfunction preexec
		fi
		PS1='$ '

		return
		;;

	xterm*)
		for term in xterm-256color xterm-color xterm; do
			if infocmp "$term" >/dev/null 2>&1; then
				export TERM="$term"
				break
			fi
		done
		;;
esac

### Initialize user xdg vars

if [ -s "$XDG_CONFIG_HOME"/user-dirs.dirs ]; then
	source "$XDG_CONFIG_HOME"/user-dirs.dirs

	export \
		XDG_DESKTOP_DIR \
		XDG_DOCUMENTS_DIR \
		XDG_DOWNLOAD_DIR \
		XDG_MUSIC_DIR \
		XDG_PICTURES_DIR \
		XDG_VIDEOS_DIR \
		XDG_PROJECTS_DIR
fi

### Set ZSH Options

## 16.2.1 Changing Directories

setopt \
	AUTO_CD \
	AUTO_PUSHD \
	PUSHD_IGNORE_DUPS \
	PUSHD_TO_HOME

## 16.2.2 Completion

setopt \
	ALWAYS_TO_END \
	AUTO_NAME_DIRS \
	COMPLETE_ALIASES \
	COMPLETE_IN_WORD \
	GLOB_COMPLETE

## 16.2.3 Expansion and Globbing

setopt \
	BAD_PATTERN \
	CASE_GLOB \
	CASE_MATCH \
	EXTENDED_GLOB \
	GLOB_STAR_SHORT \
	MARK_DIRS \
	MULTIBYTE \
	NOMATCH \
	NUMERIC_GLOB_SORT

## 16.2.4 History

setopt \
	APPEND_HISTORY \
	BANG_HIST \
	EXTENDED_HISTORY \
	HIST_EXPIRE_DUPS_FIRST \
	HIST_FCNTL_LOCK \
	HIST_FIND_NO_DUPS \
	HIST_IGNORE_ALL_DUPS \
	HIST_IGNORE_DUPS \
	HIST_IGNORE_SPACE \
	HIST_NO_FUNCTIONS \
	HIST_NO_STORE \
	HIST_REDUCE_BLANKS \
	HIST_SAVE_BY_COPY \
	HIST_SAVE_NO_DUPS \
	HIST_VERIFY \
	SHARE_HISTORY

## 16.2.6 Input/Output

setopt \
	ALIASES \
	NO_CLOBBER \
	CLOBBER_EMPTY \
	INTERACTIVE_COMMENTS \
	HASH_EXECUTABLES_ONLY \
	PRINT_EXIT_VALUE \
	RC_QUOTES \
	RM_STAR_WAIT \
	SHORT_LOOPS \
	SHORT_REPEAT

## 16.2.7 Job Control

setopt \
	AUTO_CONTINUE \
	CHECK_JOBS \
	CHECK_RUNNING_JOBS \
	HUP \
	LONG_LIST_JOBS \
	NOTIFY

## 16.2.8 Prompting

setopt \
	PROMPT_BANG \
	PROMPT_SUBST \
	TRANSIENT_RPROMPT

## 16.2.9 Scripts and Functions

setopt \
	C_BASES \
	C_PRECEDENCES \
	LOCAL_LOOPS \
	LOCAL_OPTIONS \
	LOCAL_PATTERNS \
	LOCAL_TRAPS \
	PIPE_FAIL

## 16.2.10 Shell Emulation

setopt \
	APPEND_CREATE \
	BSD_ECHO \
	POSIX_BUILTINS

## 16.2.12 Zle

setopt \
	NO_BEEP \
	COMBINING_CHARS \
	EMACS \
	NO_VI

### Setup Bindkey

bindkey '\ew' kill-region
bindkey -s '\el' "ls\n"
bindkey -s '\e.' "..\n"
bindkey '^r' history-incremental-search-backward
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history

# make search up and down work, so partially type and hit up/down to find relevant stuff
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[[F"  end-of-line
bindkey "^[[4~" end-of-line
bindkey "^[OF" end-of-line
bindkey ' ' magic-space	# also do history expansion on space

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

bindkey '^[[Z' reverse-menu-complete

# Make the delete key (or Fn + Delete on the Mac) work instead of outputting a ~
bindkey '^?' backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char
bindkey "\e[3~" delete-char

### Initialize PATH generation

typeset -Ua \
	path_append \
	path_prepend \
	path_system \
	path_user

path_append=()
path_prepend=("$XDG_BIN_HOME")
path_system=(/usr/local/bin /usr/local/sbin /usr/bin /usr/sbin /bin /sbin)
path_user=()

### Handle Mac OSX silliness

if [[ "$OSTYPE" = 'darwin'* ]]; then
	path_system=(
		"${(ps/:/)"$(env - /usr/libexec/path_helper -c | cut -d'"' -f2)"}"
	)

	typeset -gx XDG_RUNTIME_DIR="$XDG_CACHE_HOME"/run

	if [ ! -d "$XDG_RUNTIME_DIR" ]; then
		mkdir "$XDG_RUNTIME_DIR"
		chmod 0700 "$XDG_RUNTIME_DIR"
	fi

	typeset -gx XDG_DESKTOP_DIR="$HOME"/Desktop
	typeset -gx XDG_DOCUMENTS_DIR="$HOME"/Documents
	typeset -gx XDG_DOWNLOAD_DIR="$HOME"/Downloads
	typeset -gx XDG_MUSIC_DIR="$HOME"/Music
	typeset -gx XDG_PICTURES_DIR="$HOME"/Pictures
	typeset -gx XDG_VIDEOS_DIR="$HOME"/Videos
	typeset -gx XDG_PROJECTS_DIR="$HOME"/Projects
fi

### Setup homebrew

HOMEBREW_DIR=''
case "$MACHINE-$OSTYPE"; in
	arm*-darwin*)
        HOMEBREW_DIR=/opt/homebrew
		;;

	*)
        HOMEBREW_DIR=/usr/local
		;;
esac

if [ -e "$HOMEBREW_DIR"/bin/brew ]; then
	typeset -gx HOMEBREW_DIR
	typeset -gx HOMEBREW_API_AUTO_UPDATE_SECS=300
	typeset -gx HOMEBREW_AUTO_UPDATE_SECS=43200
	typeset -gx HOMEBREW_CACHE="$XDG_CACHE_HOME"/homebrew/cache
	typeset -gx HOMEBREW_CLEANUP_MAX_AGE_DAYS=30
	typeset -gx HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS=7
	typeset -gx HOMEBREW_LOGS="$XDG_CACHE_HOME"/homebrew/logs
	typeset -gx HOMEBREW_NO_ANALYTICS=1
	typeset -gx HOMEBREW_NO_ENV_HINTS=1

	path_system=("$HOMEBREW_DIR"/bin "$HOMEBREW_DIR"/sbin $path_system)

	fpath=(
		"$HOMEBREW_DIR"/share/zsh/site-functions
		"$HOMEBREW_DIR"/share/zsh/site-functions/***(FN)
		$fpath
	)

	for func ( "$HOMEBREW_DIR"/share/zsh/site-functions/***(-.N) ); do
		autoload "$func:t"
	done

	typeset -a gnubin_packages=(
		'coreutils' 'ed' 'findutils' 'gawk' 'gnu-indent' 'gnu-sed' 'gnu-tar'
		'gnu-time' 'gnu-which' 'gpatch' 'grep' 'libtool' 'make'
	)
	for gnubin_package ( $gnubin_packages ); do
		path_user=(
			$path_user "${HOMEBREW_DIR}/opt/${gnubin_package}/libexec/gnubin"
		)
	done

	typeset -a keg_only_packages=(
		'berkeley-db@5' 'binutils' 'bison' 'curl' 'ed' 'expat' 'gnu-getopt'
		'icu4c@77' 'jpeg' 'libarchive' 'libiconv' 'libomp' 'm4' 'ncurses'
		'openblas' 'openjdk' 'readline' 'sqlite' 'unzip' 'zlib'
	)
	for keg_only_package ( $keg_only_packages ); do
		path_user=($path_user "${HOMEBREW_DIR}/opt/${keg_only_package}/bin")
	done

	typeset -xgUT PKG_CONFIG_PATH pkg_config_path :
	pkg_config_path=(
		$pkg_config_path
		"${HOMEBREW_DIR}/lib/pkgconfig" "${HOMEBREW_DIR}/share/pkgconfig"
	)

	typeset -xgUT CFLAGS cflags ' '
	CLFAGS=($clfags "-I${HOMEBREW_DIR}/include")

	typeset -xgUT CPPFLAGS cflags ' '
	CPPLFAGS=($cpplfags "-I${HOMEBREW_DIR}/include")

	typeset -xgUT LDFLAGS ldflags ' '
	ldflags=($ldflags "-I${HOMEBREW_DIR}/include")

	unset gnubin_packages gnubin_package keg_only_packages keg_only_package
fi

### Program configuraiton

function is_installed
{
	command -v "$1" >/dev/null 2>&1
}

if is_installed 'mise'; then
	eval "$(mise activate zsh)"
	path_prepend=($path_prepend ${(f)"$(mise bin-paths)"})
fi

if is_installed 'atuin'; then
	eval "$(atuin init zsh)"
fi

if is_installed 'aws'; then
	typeset -gx AWS_CLI_FILE_ENCODING='UTF-8'
	typeset -gx AWS_DEFAULT_OUTPUT='json'
	typeset -gx AWS_PAGER='cat'
	typeset -gx AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
	typeset -gx AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
fi

if is_installed 'docker'; then
	typeset -gx DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
	typeset -gx DOCKER_BUILDKIT='1'
	typeset -gx BUILDKIT_PROGRESS='plain'
	typeset -gx COMPOSE_HTTP_TIMEOUT='120'
fi

CARGO_HOME="$HOME"/.local/share/cargo
if [ -d "$CARGO_HOME" ]; then
	path_user=($path_user "$CARGO_HOME")
	typeset -gx CARGO_HOME
fi

if is_installed 'go'; then
    typeset -gx GOPROXY="${GOPROXY:-https://proxy.golang.org,direct}"
fi

if is_installed 'gpg'; then
	typeset -gx GPG_TTY="$(tty)"
	typeset -gx GNUPGHOME="$XDG_DATA_HOME/gnupg"
fi

if is_installed 'grep'; then
    typeset -gx GREP_COLORS='ms=01;32:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
fi

if is_installed 'less'; then
	typeset -gx LESS='-g -i -M -R -S -w -z-4'
	typeset -gx LESSHISTFILE="$XDG_CACHE_HOME/less/history"
	typeset -gx PAGER='less'
fi

if is_installed 'most'; then
	typeset -gx PAGER='most'
fi

if is_installed 'nvim'; then
    alias vim 'nvim'
    alias vi 'nvim'
fi

if is_installed 'poetry'; then
	typeset -gx POETRY_CACHE_DIR="$XDG_CACHE_HOME"/poetry
	typeset -gx POETRY_VIRTUALENVS_PATH="$XDG_DATA_HOME"/virtualenvs
fi

if is_installed 'psql'; then
	typeset -gx PSQL_HISTORY="$XDG_DATA_HOME/psql_history"
fi

if is_installed 'python'; then
	typeset -gx PYTHONPATH='.'
	typeset -gx PYTHONUTF8='1'
	typeset -gx PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"
	typeset -gx PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
	typeset -gx IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
	typeset -gx PYLINTHOME="$XDG_CACHE_HOME/pylint"
fi

if is_installed 'ruby'; then
	typeset -gx GEMRC="$XDG_CONFIG_HOME/gem/gemrc"
	typeset -gx GEM_HOME="$XDG_DATA_HOME/gem"
	typeset -gx GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
	typeset -gx BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
	typeset -gx BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
	typeset -gx BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"
	typeset -gx SOLARGRAPH_CACHE="$XDG_CACHE_HOME/solargraph"
fi

RUSTUP_HOME="$HOME"/.local/share/rustup
if [ -d "$RUSTUP_HOME" ]; then
	path_user=($path_user "$RUSTUP_HOME")
	typeset -gx RUSTUP_HOME
fi

if [ -n "$SSH_AUTH_SOCK" ]; then
	typeset -gx SSH_AUTH_SOCK
fi

if is_installed 'starship'; then
	eval "$(starship init zsh)"
fi

if is_installed 'terraform'; then
	typeset -gx TF_CLI_CONFIG_FILE="$XDG_CONFIG_HOME/terraform/config.tfrc"
	typeset -gx TF_PLUGIN_CACHE_DIR="$XDG_CACHE_HOME/terraform/plugin"

    if [ ! -d "$TF_PLUGIN_CACHE_DIR" ]; then
        mkdir -p "$TF_PLUGIN_CACHE_DIR"
	fi
fi

if is_installed 'tmux'; then
	typeset -gx TMUX_PLUGIN_MANAGER_PATH="$XDG_DATA_HOME/tmux/plugins"
fi

### Build path variable

path=()
for dir (
	$path_prepend
	$path_user
	$path_system
	$path_append
); do
	[ -d "$dir" ] || continue
	path=($path $dir)
done

### Load functions

fpath=(
	"$ZDOTDIR"/functions
	"$ZDOTDIR"/functions/***(FN)
	"$ZDOTDIR"/completions
	"$ZDOTDIR"/completions/***(FN)
	$fpath
)

for func (
		"$ZDOTDIR"/functions/***(.N)
		"$ZDOTDIR"/completions/***(.N)
	); do
	autoload "$func:t"
done

unset func

### Tab complete

zmodload -i zsh/complist

LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'
export LS_COLORS

zstyle ':completion::complete:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

zstyle ':completion:*' verbose yes

zstyle ':completion:*:descriptions' format "%B———— %d ————%b"
zstyle ':completion:*:messages' format '%B%U———— %d ————%u%b'
zstyle ':completion:*:warnings' format "%B$fg[red]%}no match for: $fg[white]%d%b"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command 'ps -U "$USER" -ww -o pid,tty,args'

hostname_regex='(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])'

typeset -U hosts
[ -r /etc/ssh/ssh_known_hosts ] &&
	hosts=(
		$hosts
		$(ssh-keygen -l -f /etc/ssh/ssh_known_hosts 2>/dev/null |
			  awk '{sub(/,/, " ", $3); print $3}' |
			  grep -o -F "$hostname_regex")
	)

[ -r "${HOME}/.ssh/known_hosts" ] &&
	hosts=(
		$hosts
		$(ssh-keygen -l -f "${HOME}/.ssh/known_hosts" |
			  awk '{sub(/,/, " ", $3); print $3}' |
			  grep -o -E "$hostname_regex")
	)

[ -r /etc/hosts ] &&
	hosts=(
		$hosts
		$(awk '!/^(#.*)?$/{print $1" "$2}' /etc/hosts |
			  grep -o -E "$hostname_regex")
	)

hosts=(
	$hosts
	"$HOST"
	localhost
)

zstyle ':completion:*:hosts' hosts $hosts

users=(
	# OSX users
	$(command -v dscl >/dev/null 2>&1 &&
		  dscl . -readall /Users UniqueID |
			  sed -n '/UniqueID: [5-9][[:digit:]]\{2,\}/{x;p;d;};x' |
			  cut -d' ' -f2)

	# Linux Users
	$(test -f '/usr/bin/getent' &&
		  getent passwd | awk -F: '$3 >= 1000{print $1}')

	"$USER"
	root
)

typeset -U users

zstyle ':completion:*:*:*:users' users $users

zstyle '*' single-ignored show

### Compinit

if [ ! -d "$XDG_STATE_HOME"/zsh ]; then
	mkdir -p "$XDG_STATE_HOME"/zsh
fi

autoload -U compinit
compinit -i -d "$XDG_STATE_HOME"/zsh/zshcompdump

autoload -U +X bashcompinit
compinit -i -d "$XDG_STATE_HOME"/zsh/bashcompdump

### .zshrc ends here
