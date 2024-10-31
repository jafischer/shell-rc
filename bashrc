#!/bin/bash
# Note: the hash-bang above was only added so that my IDE knows this is a bash script. But this script must be
# sourced, not executed from the command line.

bashrc_main() {
  bashrc_set_path
  bashrc_shell_settings
  bashrc_color_variables
  bashrc_setup_history
  bashrc_setup_prompt
  bashrc_set_variables
  bashrc_finish_up
}

# I don't want to source `functions` at the top (I forget why), so I've placed
# the is_mac/is_linux/is_wsl functions in a separate file.
source "$(dirname ${BASH_SOURCE[0]})/os"

bashrc_set_path() {
  # Because this file might get sourced repeatedly, we don't want to keep appending PATH to itself over and over.
  # So the first time this file is sourced, we'll store the path in $ORIG_PATH.
  if [[ -z $ORIG_PATH ]]; then
    #echo "Original path is: $PATH"
    ORIG_PATH="$PATH"
  else
    export PATH="$ORIG_PATH"
  fi

  # Add components to path one at a time, just for readability.
  local my_path="$HOME/bin/binaries"
  my_path="$my_path:$HOME/bin"
  my_path="$my_path:$HOME/src/safety-scripts"
  my_path="$my_path:$HOME/src/garbo-cpp/cmake-build-release"
  # Many of my repos have a scripts directory, and I'm tired of typing "./scripts/xxx"
  my_path="$my_path:./scripts"

  if is_mac; then
    my_path="$my_path:/usr/local/mysql/bin"
    my_path="$my_path:/opt/homebrew/bin"
    my_path="$my_path:/Library/Java/JavaVirtualMachines/current/Contents/Home/bin"
    my_path="$my_path:/usr/local/MacGPG2/bin"
    my_path="$my_path:/Library/Apple/usr/bin"
    my_path="$my_path:$HOME/go/go1.21.5/bin"
    my_path="$my_path:$HOME/go/bin"
    my_path="$my_path::/Users/jafischer/Library/Application Support/JetBrains/Toolbox/scripts"
  elif is_wsl; then
    my_path="$my_path:/opt/apache-maven-3.6.3/bin"
  fi

  # Combine the paths above with ":" as separator:
  export PATH="$ORIG_PATH:$my_path"

  # Paths for the cd command to search
  # shellcheck disable=SC2088
  CDPATH="$HOME/src:$HOME/mysrc:$HOME/3rdparty:$HOME/OneDrive/Documents:$HOME"
}

bashrc_shell_settings() {
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
}

bashrc_color_variables() {
  # Define some variables containing ANSI escape sequences we can use with "echo -e" to get colorful output:
  black='\x1b[0;30m'; red='\x1b[0;31m'; green='\x1b[0;32m'; yellow='\x1b[0;33m'; blue='\x1b[0;34m'; pink='\x1b[0;35m'; cyan='\x1b[0;36m'; grey='\x1b[0;37m';
  BLACK='\x1b[1;30m'; RED='\x1b[1;31m'; GREEN='\x1b[1;32m'; YELLOW='\x1b[1;33m'; BLUE='\x1b[1;34m'; PINK='\x1b[1;35m'; CYAN='\x1b[1;36m'; WHITE='\x1b[1;37m'
  NC='\x1b[0m' # No Color
}

bashrc_setup_history(){
  #-------------------------------------------------------------
  # History config:
  #-------------------------------------------------------------

  # cmdhist: Save all lines of a multiple-line command in the same history entry.  This allows easy re-editing of multi-line commands.
  # histappend: History is appended to history file, not overwritten.
  # histreedit: user is given the opportunity to re-edit a failed history substitution
  # histverify: the results of history substitution are not immediately executed; user must press enter.
  shopt -s cmdhist histappend histreedit histverify
  # Exporting HISTFILE so my history-cleanup utility knows where it is.
  export HISTFILE="$(dirname ${BASH_SOURCE[0]})/history-$(my_os)"
  HISTTIMEFORMAT="%F %T "
  # ignorespace: preceding a command with a space will omit it from the history.
  # ignoredups: causes lines which match the previous history entry to not be saved
  # erasedups: causes all previous lines matching the current line to be removed from the history list before that line is saved
  HISTCONTROL=ignorespace:ignoredups:erasedups
  # Patterns of commands to omit from history:
  HISTIGNORE="?:??:hgrep*:h50:lrt:gst"
  HISTSIZE=50000
  HISTFILESIZE=50000
  # "history -a" causes all commands to be immediately appended to .bash_history, instead of only when the shell exits.
  # (useful for when using multiple terminal windows).
  if [[ "$PROMPT_COMMAND" != *"history -a"* ]]; then
    PROMPT_COMMAND="${PROMPT_COMMAND}; history -a"
  fi
}

bashrc_setup_prompt() {
  #-------------------------------------------------------------
  # Set up a fancy prompt
  #-------------------------------------------------------------

  # The bash shell lets you customize your command prompt via the PS1 variable. You can just set it to a string,
  # like "Hello!" but the real power comes with various special escape sequences.
  # Note: by convention, PS1 tends to end with \$, which will be "$" if you're running normally,
  # but "#" if you're running as root.

  # Complete list of PS1 escapes:
  # \a A bell character. Why in god's name would you want this...
  # \d The date, in "Weekday Month Date" format (e.g., "Tue May 26").
  # \D{format} The format is passed to strftime(3) and the result is inserted into the prompt string; an empty format results in a locale-specific time representation. The braces are required.
  # \e An escape character.
  # \h The hostname, up to the first ‘.’.
  # \H The full hostname.
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

  # Oddly, on MacOS, "echo -e" doesn't accept \e. It requires \x1b instead.
  # BUT... the PS1 prompt understands \e, and not \x1b...
  # So in other words I can't use the color variables I've defined.
  PS1_dir='[\e[1;33mdir: \e[1;34m\w\e[0m] '
  if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
    # shellcheck disable=SC2016
    PS1_branch='[\e[1;33mbranch: \e[1;34m$(git status 2>&1 | sed -e "s|fatal:.*|On branch: N/A|" | grep "On branch" | cut -f 3 -d" ")\e[0m] '
    # shellcheck disable=SC2016
    PS1_ns='[\e[1;33mns: \e[1;34m$(kubectl config view --minify -o jsonpath="{..namespace}")\e[0m]\n'
    # `brew install coreutils` to get gdate
    if command -v gdate >&/dev/null; then
      # shellcheck disable=SC2016
      PS1_timestamp='$(gdate +%H:%M:%S.%3N)'
    else
      # shellcheck disable=SC2016
      PS1_timestamp='$(date +%H:%M:%S)'
    fi
  fi
  PS1=$PS1_dir$PS1_branch$PS1_ns$PS1_timestamp' \$ '
}

bashrc_set_variables() {
  SRC_DIR=~/src
  is_wsl && SRC_DIR=/mnt/c/Users/jafischer/src
  ICLOUD_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
  is_wsl && ICLOUD_DIR=/mnt/c/Users/jafischer/iCloudDrive

  # JavaVirtualMachines/current is a symlink to whatever version of the JDK
  # I'm currently using (see the "jdk" function in ./functions)
  export JAVA_HOME=/Library/Java/JavaVirtualMachines/current/Contents/Home

  export EDITOR=vim
  export EXINIT="source $HOME/.vimrc"

  export AWS_DEFAULT_PROFILE=sie-cloud-kamaji-admin16-zz-jafischer
  export AWS_PROFILE=sie-cloud-kamaji-admin16-zz-jafischer

  export GOROOT=~/go/go1.21.5
}

bashrc_finish_up() {
  # Just in case I ever forget after adding a new file under .ssh or .secrets:
  chmod -R og-rwx ~/.ssh ~/.secrets

  # Cargo: build cmd for Rust
  # shellcheck disable=SC1090
  source ~/.cargo/env
  # Gimme-aws-creds: credentials for AWS (https://github.sie.sony.com/SIE/gimme-aws-creds)
  # shellcheck disable=SC1090
  source ~/.gimme-aws-creds-xaws
  # fzf: Fuzzy finder (https://github.com/junegunn/fzf)
  command -v fzf >& /dev/null && eval "$(fzf --bash)"

  #-------------------------------------------------------------
  # Aliases and functions
  #-------------------------------------------------------------
  source "$(dirname ${BASH_SOURCE[0]})/aliases"
  source "$(dirname ${BASH_SOURCE[0]})/functions"
  source "$(dirname ${BASH_SOURCE[0]})/completion"

  # Convert ~ to $HOME in PATH. Do this at the end to account for paths added by any sourced scripts above.
  export PATH="${PATH//\~/$HOME}"
}

##########################

bashrc_main

# shellcheck disable=SC2046
# Now that we've run bashrc_main, clear it and all the other temporary
# functions that were defined in this file:
unset -f $(
  # List all functions
  declare -F |
  # Choose only the last word of each line, which is the function name.
  awklast |
  # Choose the functions starting with "bashrc_"
  grep '^bashrc_')
