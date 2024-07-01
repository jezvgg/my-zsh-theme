function venv_info {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "%{$fg[green]%}‹${VIRTUAL_ENV:t}›%{$reset_color%}"
    fi
}

function conda_info {
    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        echo "%{$fg_bold[green]%}conda:(%{$fg_bold[red]%}${CONDA_DEFAULT_ENV}%{$fg_bold[green]%})%{$reset_color%}"
    fi
}

function docker_info {
    if [[ -n "$(docker ps -l -q)" ]]; then
        echo "$(docker ps -l -q)"
    fi
}

ami_sudo () {
    local prompt
    prompt=$(sudo -nv 2>&1)
    if [ $? -eq 0 ]; then
     # exit code of sudo-command is 0
        echo '[⚡]'
    elif echo $prompt | grep -q '^sudo:'; then
	echo ''
    else
        echo ''
    fi
}

docker_info () {
    local prompt
    prompt=$(sudo -nv 2>&1)
    if [ $? -eq 0 ]; then
        local prompt2
        prompt2=$(sudo docker ps -l --filter "status=running" --format '{{.Image}}:{{.ID}}' 2>&1)
        if [ -n "${prompt2}" ]; then
            echo " %{$fg_bold[cyan]%}docker:(%{$fg_bold[red]%}${prompt2}%{$fg_bold[cyan]%})%{$reset_color%}"
        else
            echo ''
        fi
    elif echo $prompt | grep -q '^sudo:'; then
	echo ''
    else
        echo ''
    fi
}

current_time() {

   echo "%*"
}

as_root() {

   echo "%#"
}

local venv='$(venv_info)'
local conda='$(conda_info)'
local sudos='$(ami_sudo)'
local docker='$(docker_info)'
local git='$(git_prompt_info)'

PROMPT="╭─${sudos} %{$fg[cyan]%}%c%{$reset_color%} ${conda}${docker} ${git}
╰↦ "
RPROMPT='$(current_time) %(?.%{$fg[green]%}✔%f.%{$fg[red]%}✘%f)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
