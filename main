is_mac() {
  [[ $(uname) == "Darwin" ]]
}

is_linux() {
  [[ $(uname) == "Linux" ]]
}

is_wsl() {
  is_linux && [[ -d /mnt/c ]]
}

[[ -z $ORIG_PATH ]] && {
  echo "Original path is: $PATH"
  export ORIG_PATH="$PATH"
}

# Set path in a more readable way, with one path per line:
path_components=`\cat <<EOS
  ~/bin/binaries
  ~/bin
  ~/src/safety-scripts
  ~/src/garbo-cpp/cmake-build-release
EOS`

if is_mac; then
  path_components=`\cat <<EOS
  $path_components
  /usr/local/mysql/bin
  /opt/homebrew/bin
  /Library/Java/JavaVirtualMachines/current/Contents/Home/bin
  /usr/local/MacGPG2/bin
  /Library/Apple/usr/bin
  ~/go/go1.21.5/bin
  ~/go
EOS`
elif is_wsl; then
  path_components=`\cat <<EOS
  $path_components
  /opt/apache-maven-3.6.3/bin
EOS`
fi

# Combine the paths above with ":" as separator:
export PATH="$ORIG_PATH:$(echo $path_components | sed -e "s/  */:/g")"
if is_mac; then
  # Special case for paths containing spaces...
  export PATH="$PATH:/Users/jafischer/Library/Application Support/JetBrains/Toolbox/scripts"
fi
export SHELL=/bin/bash

# Paths for the cd command to search
CDPATH="~/src:~/3rdparty:~/OneDrive/Documents:~"

#-------------------------------------------------------------
# Some settings
#-------------------------------------------------------------

# See https://ioflood.com/blog/set-linux-command/ for list of "set" options.

# Report the status of terminated background jobs immediately, rather than before the next primary prompt
set -o notify
# "Noclobber" off means you can overwrite files when redirecting to them. I find the risk acceptable.
# set -o noclobber
# "Nounset" would cause errors if attempting to use variables that aren't set. E.g. "echo $asdf"
# set -o nounset
# set -o xtrace          # Useful for debuging.

# Case-insensitive tab completion for the win:
bind "set completion-ignore-case on"
# This is so useful to me. Just hit tab and it'll show you all the choices. Don't have to hit double-tab.
bind "set show-all-if-ambiguous on"

# Enable options:
shopt -s cdspell      # Minor errors in directory names will be corrected.
shopt -s checkwinsize # update the values of LINES and COLUMNS if window size is changed.
shopt -s no_empty_cmd_completion
shopt -s extglob        # Necessary for programmable completion.

# Define some colors:
black='\x1b[0;30m'; red='\x1b[0;31m'; green='\x1b[0;32m'; yellow='\x1b[0;33m'; blue='\x1b[0;34m'; pink='\x1b[0;35m'; cyan='\x1b[0;36m'; grey='\x1b[0;37m';
BLACK='\x1b[1;30m'; RED='\x1b[1;31m'; GREEN='\x1b[1;32m'; YELLOW='\x1b[1;33m'; BLUE='\x1b[1;34m'; PINK='\x1b[1;35m'; CYAN='\x1b[1;36m'; WHITE='\x1b[1;37m'
NC='\x1b[0m' # No Color

# Colors used by the ls command (and others?)
#export LSCOLORS=GxFxCxDxBxegedabagaced

#-------------------------------------------------------------
# History config:
#-------------------------------------------------------------

# cmdhist: Save all lines of a multiple-line command in the same history entry.  This allows easy re-editing of multi-line commands.
# histappend: History is appended to history file, not overwritten.
# histreedit: user is given the opportunity to re-edit a failed history substitution
# histverify: the results of history substitution are not immediately executed; user must press enter.
shopt -s cmdhist histappend histreedit histverify
HISTTIMEFORMAT="%F %T "
# Preceding a command with a space will omit it from the history.
HISTCONTROL=ignorespace
# Patterns of commands to omit from history:
HISTIGNORE="ls:h:l:up:hgrep*:h50:virc:vifu:via:la:lt:lrt:pp:sl:e1:spint:mgmt:pqa:p1"
HISTSIZE=20000
HISTFILESIZE=20000
# "history -a" causes all commands to be immediately appended to .bash_history, instead of only when the shell exits.
# (useful for when using multiple terminal windows).
if [[ "$PROMPT_COMMAND" != *"history"* ]]; then
  PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a"
fi

#-------------------------------------------------------------
# Set up a fancy prompt (PS1)
#-------------------------------------------------------------

# Complete list of PS1 escapes:
# \a A bell character.
# \d The date, in "Weekday Month Date" format (e.g., "Tue May 26").
# \D{format} The format is passed to strftime(3) and the result is inserted into the prompt string; an empty format results in a locale-specific time representation. The braces are required.
# \e An escape character.
# \h The hostname, up to the first ‘.’.
# \H The hostname.
# \j The number of jobs currently managed by the shell.
# \l The basename of the shell’s terminal device name.
# \n A newline.
# \r A carriage return.
# \s The name of the shell, the basename of $0 (the portion following the final slash).
# \t The time, in 24-hour HH:MM:SS format.
# \T The time, in 12-hour HH:MM:SS format.
# \@ The time, in 12-hour am/pm format.
# \A The time, in 24-hour HH:MM format.
# \u The username of the current user.
# \v The version of Bash (e.g., 2.00)
# \V The release of Bash, version + patchlevel (e.g., 2.00.0)
# \w The value of the PWD shell variable ($PWD), with $HOME abbreviated with a tilde (uses the $PROMPT_DIRTRIM variable).
# \W The basename of $PWD, with $HOME abbreviated with a tilde.
# \!  The history number of this command.
# \# The command number of this command.
# \$ If the effective uid is 0, #, otherwise $.
# \nnn The character whose ASCII code is the octal value nnn.
# \\ A backslash.
# \[ Begin a sequence of non-printing characters. This could be used to embed a terminal control sequence into the prompt.
# \] End a sequence of non-printing characters.

# OK so on MacOS this is pretty f*cked up. "echo -e" doesn't accept \e. It requires \x1b instead. BUT... the PS1 prompt understands \e, and not \x1b... 

ps1_branch() { 
  # Built-in BSD date doesn't do nanoseconds, so I installed gdate.
  local t1=$(gdate +%s%N)
  echo -n $(git status 2>&1 | sed -e "s|fatal:.*|On branch: N/A|" | grep "On branch" | cut -f 3 -d' ')
  local t2=$(gdate +%s%N)
  [[ -n $DEBUG ]] && echo " ($(((t2 - t1) / 1000000))ms)"
}
ps1_ns() { 
  # Built-in BSD date doesn't do nanoseconds, so I installed gdate.
  local t1=$(gdate +%s%N)
  echo -n $(kubectl config view --minify -o jsonpath="{..namespace}")
  local t2=$(gdate +%s%N)
  [[ -n $DEBUG ]] && echo " ($(((t2 - t1) / 1000000))ms)"
}
PS1_dir='[\e[1;33mdir: \e[1;34m\w\e[0m] '
if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
  PS1_branch='[\e[1;33mbranch: \e[1;34m$(ps1_branch)\e[0m] '
  #PS1_clus='[\e[1;33mclus: \e[1;34m$(skuba cluster | grep yes | cut -f 1 -d\ )\e[0m] '
  #PS1_ns='[ns: \e[1;34m$(kubectl config get-contexts | grep "^\*" | awk "{print \$NF}")\e[0m]\n'
  PS1_ns='[\e[1;33mns: \e[1;34m$(ps1_ns)\e[0m]\n'
  # `brew install coreutils` to get gdate
  PS1_timestamp='$(gdate +%H:%M:%S.%3N)'
fi
PS1=$PS1_dir$PS1_branch$PS1_ns$PS1_timestamp' \$ '

#-------------------------------------------------------------
# Environment variables
#-------------------------------------------------------------

export JAVA_HOME=/Library/Java/JavaVirtualMachines/current/Contents/Home
 
export EDITOR=vim

export AWS_DEFAULT_PROFILE=sie-cloud-kamaji-admin16-zz-jafischer
export AWS_PROFILE=sie-cloud-kamaji-admin16-zz-jafischer

export GOROOT=~/go/go1.21.5

# The new Aloy bastions:
e1_bastion=dev.b.kcloud.playstation.net
p1_bastion=prod.b.kcloud.playstation.net

# Just in case I ever forget after adding a new file under .ssh:
chmod -R og-rwx ~/.ssh ~/.secrets

#-------------------------------------------------------------
# Aliases and functions
#-------------------------------------------------------------
. ~/.aliases
. ~/.functions
. ~/.completion

# Cargo: build cmd for Rust
. ~/.cargo/env
# Gimme-aws-creds: credentials for AWS (https://github.sie.sony.com/SIE/gimme-aws-creds)
[[ -e ~/.gimme-aws-creds-xaws ]] && . ~/.gimme-aws-creds-xaws
# fzf: Fuzzy finder (https://github.com/junegunn/fzf)
command -v fzf >& /dev/null && eval "$(fzf --bash)"

# Convert ~ to $HOME in PATH. Do this at the end to account for paths added by any sourced scripts above.
export PATH=$(echo $PATH | sed -e "s|\~|$HOME|g")
