#!/usr/bin/env bash
# ~/.config/waybar/tuned.sh
# Mostra e alterna o perfil de energia do TuneD.
#
#   tuned.sh status   -> imprime JSON para a waybar
#   tuned.sh next     -> avança para o próximo perfil
#   tuned.sh prev     -> volta para o anterior

# Ordem do ciclo: economia -> equilíbrio -> desempenho
PERFIS=(powersave balanced throughput-performance)
CURTO=(eco bal max)

atual() {
    tuned-adm active 2>/dev/null | sed 's/.*: //'
}

indice() {
    local a; a=$(atual)
    for i in "${!PERFIS[@]}"; do
        [[ "${PERFIS[$i]}" == "$a" ]] && { echo "$i"; return; }
    done
    echo -1
}

troca() {
    local i n
    i=$(indice)
    if [[ $i -lt 0 ]]; then
        n=1                                  # perfil desconhecido -> balanced
    elif [[ "$1" == "prev" ]]; then
        n=$(( (i - 1 + ${#PERFIS[@]}) % ${#PERFIS[@]} ))
    else
        n=$(( (i + 1) % ${#PERFIS[@]} ))
    fi
    sudo -n tuned-adm profile "${PERFIS[$n]}" 2>/dev/null \
        || tuned-adm profile "${PERFIS[$n]}" 2>/dev/null
    pkill -RTMIN+8 waybar                    # atualiza a barra na hora
}

status() {
    local a i rot cls
    a=$(atual)
    i=$(indice)
    if [[ $i -ge 0 ]]; then
        rot="${CURTO[$i]}"
        cls="${PERFIS[$i]}"
    else
        rot="${a:-?}"
        cls="outro"
    fi
    printf '{"text":"pwr: %s","tooltip":"Perfil TuneD: %s\\nClique alterna","class":"%s"}\n' \
        "$rot" "${a:-desconhecido}" "$cls"
}

case "${1:-status}" in
    next)   troca next ;;
    prev)   troca prev ;;
    *)      status ;;
esac
