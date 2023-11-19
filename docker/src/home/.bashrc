### some examples of custom aliases

alias ll="ls -l"

### clear terminal window
alias cls='printf "\033c"'

### change terminal prompt text
fn_ps1() {
    if [ $# -gt 0 ] ; then
        ### given value in bold green
        PS1="\[\033[01;32m\]$1\[\033[00m\]> "
    else
        ### basename of the current working directory in bold blue
        PS1='\[\033[01;34m\]\W\[\033[00m\]> '
    fi
}
alias ps1='fn_ps1'
