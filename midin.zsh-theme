# Machine name.
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

# Directory info.
function get_current_dir {
	current_dir=${PWD/#${HOME}/'~'}
	echo $current_dir
}

# Git info.
grey='\e[0;90m'
ZSH_THEME_GIT_PROMPT_PREFIX="%{$grey%}(git:%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$grey%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}x"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}o"
# SVN
ZSH_THEME_SVN_PROMPT_PREFIX="%{$grey%}(svn:%{$fg[cyan]%}"
ZSH_THEME_SVN_PROMPT_SUFFIX="%{$grey%})%{$reset_color%}"
# SVN
# %{$reset_color%}\
# %{$fg[cyan]%}%n\
# %{$fg[white]%}@\
# %{$fg[green]%}$(box_name)\
# %{$terminfo[bold]$fg[red]%} ➤%{$reset_color%} '

# Prompt
function mid_prompt {
	my_git_info=$(git_prompt_info)
	my_space="-"
	my_box="$(whoami)@$(box_name)"

	(( spare_len = ${COLUMNS}  / 2 - 30 ))
	box_name_len=${#${my_box}}
	my_git_info_len=${#${my_git_info}}
	if [ ${my_git_info_len} -ge 49 ]; then
		(( my_git_info_len -= 49 ))
	fi
	# user_machine_len=${#${(%):-%n@%m-}}

	(( spare_len = ${spare_len} - ${my_git_info_len} - ${box_name_len} ))

	myprompt=""
	while [ ${#myprompt} -lt $spare_len ]; do
		myprompt="$my_space$myprompt"
	done

	myprompt="%{$reset_color%} %{$terminfo[bold]$fg[yellow]%}$myprompt➜ %{$fg[cyan]%}%n%{$fg[white]%}@%{$fg[green]%}$(box_name) ${my_git_info}"

	echo $myprompt
}

setopt prompt_subst

if [ ${EMACS} ]; then
chpwd() { print -P "\033AnSiTc %d" }
print -P "\033AnSiTu %n"
print -P "\033AnSiTc %d"
fi
PROMPT='
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%{$terminfo[bold]$fg[magenta]%}$(get_current_dir)
$(mid_prompt)\
%{$terminfo[bold]$fg[red]%}➤%{$reset_color%} '
