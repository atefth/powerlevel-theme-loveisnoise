POWERLEVEL9K_CUSTOM_WIFI_SIGNAL_BACKGROUND="119"
POWERLEVEL9K_CUSTOM_WIFI_SIGNAL_FOREGROUND="black"

zsh_wifi_signal(){
    local perfect_signal="%F{230}"
    local good_signal="%F{230}"
    local average_signal="%F{230}"
    local poor_signal="%F{230}"
    local no_signal="%F{230}"
    local ethernet_connection="%F{230}"
    local separation_suffix="%F{black} ⎮"
    local signal=$(airport -I | grep agrCtlRSSI | awk '{print $2}' | sed 's/-//g')
    local noise=$(airport -I | grep agrCtlNoise | awk '{print $2}' | sed 's/-//g')
    local SNR=$(bc <<<"scale=2; $signal / $noise")

    local net=$(curl -D- -o /dev/null -s http://www.google.com | grep HTTP/1.1 | awk '{print $2}')
    local color="%F{215}"
    local symbol="$poor_signal"

    if [[ ! -z "${signal// }" ]] && [[ $SNR -gt .40 ]] ;
    then color="%F{black}" ; symbol="$perfect_signal" ;
    fi

    if [[ ! -z "${signal// }" ]] && [[ ! $SNR -gt .40 ]] && [[ $SNR -gt .25 ]] ;
    then color="%F{red}" ; symbol="$good_signal" ;
    fi

    if [[ ! -z "${signal// }" ]] && [[ ! $SNR -gt .25 ]] && [[ $SNR -gt .15 ]] ;
    then color="%F{white}" ; symbol="$average_signal" ;
    fi

    if [[ ! -z "${signal// }" ]] && [[ ! $SNR -gt .15 ]] && [[ $SNR -gt .10 ]] ;
    then color="%F{red}" ; symbol="$poor_signal" ;
    fi

    if [[ ! -z "${signal// }" ]] && [[ ! $SNR -gt .10 ]] ;
    then color="%F{09}" ; symbol="$no_signal";
    fi

    if [[ -z "${signal// }" ]] && [[ "$net" -ne 200 ]] ;
    then color="%F{09}" ; symbol="$no_signal" ;
    fi

    if [[ -z "${signal// }" ]] && [[ "$net" -eq 200 ]] ;
    then color="%F{blue}" ; symbol="$ethernet_connection" ;
    fi
    echo -n "%{$color%}$symbol$separation_suffix%K{230}"
}

POWERLEVEL9K_CUSTOM_WIFI_SIGNAL="zsh_wifi_signal"
