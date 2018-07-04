zsh_environment_prompt(){
    local background_color='230'
    local pyenv=''
    local pyenv_color="%F{blue}"
    local rbenv=''
    local rbenv_color="%F{09}"
    local nvm=''
    local nvm_color="%F{215}"
    local text_color="%F{black}"
    local python_icon=""
    local ruby_icon=""
    local npn_icon=""

    if [[ -f "$(pwd)/$(ls -lah | grep -w 'config.py' | awk '{print $9}' | head -1)" ]]
    then
        version="$(pyenv version | grep @ | awk '{print $1}')"
	    echo -n "%K{$background_color}$pyenv_color $python_icon$text_color $version "
    fi

    if [[ -f "$(pwd)/$(ls -lah | grep -w 'Gemfile' | awk '{print $9}' | head -1)" ]]
    then
        version="$(rbenv version | grep . | awk '{print $1}')"
	    echo -n "%K{$background_color}$rbenv_color $ruby_icon$text_color $version "
    fi

    if [[ -f "$(pwd)/$(ls -lah | grep -w 'package.json' | awk '{print $9}' | head -1)" ]]
    then
        version="$(nvm version)"
	    echo -n "%K{$background_color}$nvm_color $npn_icon$text_color $version "
    fi

    if [[ -d "./$(ls -lah | grep -w '.git' | awk '{print $9}' | head -1)" ]]
    then
        echo -n "%K{230}%F{black}"
    else
	    echo -n "%K{09}"
    fi

}

POWERLEVEL9K_CUSTOM_ENVIRONMENT="zsh_environment_prompt"
