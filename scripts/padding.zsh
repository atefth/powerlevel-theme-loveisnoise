prompt_zsh_padding_right(){
    local separation_suffix="%F{black}⎮"
    echo -n "$separation_suffix"
}

prompt_zsh_spacing_left(){
    echo -n " %K{119} "
}
