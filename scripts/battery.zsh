prompt_zsh_battery_level() {
    local no_battery=''
    local low_battery=''
    local half_battery=''
    local high_battery=''
    local charged_battery=''
    local battery_icon=''
    local color='09'
    local background_color="%K{230}"
    local text_color="%F{black}"
    local symbol=$no_battery
    local separation_suffix="%F{black} ⎮"
    local percentage=''

    percentage=`pmset -g batt | egrep "([0-9]+\%).*" -o --colour=auto | cut -f1 -d';' | grep -oe '\([0-9.]*\)'`
    if [[ $(bc <<< "scale=2 ; $percentage<25") == '1' ]]
    then
        symbol=$low_battery
        color='red'
    fi

    if ([[ $(bc <<< "scale=2 ; $percentage>=25") == '1' ]] && [[ $(bc <<< "scale=2 ; $percentage<50") == '1' ]])
    then
        symbol=$low_battery 
        color='red'
    fi

    if ([[ $(bc <<< "scale=2 ; $percentage>=50") == '1' ]] && [[ $(bc <<< "scale=2 ; $percentage<75") == '1' ]])
    then
        symbol=$half_battery
        color='yellow'
    fi

    if ([[ $(bc <<< "scale=2 ; $percentage>76") = '1' ]] && [[ $(bc <<< "scale=2 ; $percentage<99") = '1' ]])
    then 
        symbol=$high_battery
        color='blue'
    fi

    if [[ $(bc <<< "scale=2 ; $percentage>100") == '1' ]]
    then
        symbol=$charged_battery
        color='green'
    fi

    pmset -g batt | grep "discharging" >& /dev/null
    if [ $? -eq 0 ]; then
        color='119';
        true ;
    else ;
        color='green' ;
    fi
    current_color="%F{$color}"

    echo -n "$background_color$current_color$battery_icon$current_color $symbol $text_color$percentage "
}
