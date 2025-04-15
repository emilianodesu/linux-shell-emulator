#!/bin/bash

ROJO='\033[1;31m'
AZUL='\033[1;34m'
RESET='\033[0m'

tablero=(" " " " " " " " " " " " " " " " " ")

imprime_tablero() {
    echo ""
    for i in {0..8}; do
        simbolo="${tablero[$i]}"
        if [[ $simbolo == "X" ]]; then
            printf " ${ROJO}X${RESET} "
        elif [[ $simbolo == "O" ]]; then
            printf " ${AZUL}O${RESET} "
        else
            printf "   "
        fi

        if [[ $(( (i + 1) % 3 )) -eq 0 ]]; then
            echo ""
            [[ $i -ne 8 ]] && echo "---+---+---"
        else
            printf "|"
        fi
    done
    echo ""
}

es_ganador() {
    local simbolo=$1
    local ganadoras=(
        "0 1 2" "3 4 5" "6 7 8"
        "0 3 6" "1 4 7" "2 5 8"
        "0 4 8" "2 4 6"
    )
    for linea in "${ganadoras[@]}"; do
        set -- $linea
        if [[ ${tablero[$1]} == "$simbolo" && ${tablero[$2]} == "$simbolo" && ${tablero[$3]} == "$simbolo" ]]; then
            return 0
        fi
    done
    return 1
}

es_empate() {
    for celda in "${tablero[@]}"; do
        if [[ $celda == " " ]]; then
            return 1
        fi
    done
    return 0
}

coords_a_indice() {
    local fila=$1
    local col=$2
    echo $((fila * 3 + col))
}

reiniciar_tablero() {
    for i in {0..8}; do
        tablero[$i]=" "
    done
}

jugar() {
    local jugador="X"

    while true; do
        imprime_tablero

        if [[ $jugador == "X" ]]; then
            simbolo_coloreado="${ROJO}X${RESET}"
        else
            simbolo_coloreado="${AZUL}O${RESET}"
        fi

        echo -e "Turno del jugador ${simbolo_coloreado}. Ingresa fila y columna (0-2), separados por espacio:"
        read -r fila col

        if ! [[ "$fila" =~ ^[0-2]$ && "$col" =~ ^[0-2]$ ]]; then
            echo "Entrada invalida. :( Usa numeros del 0 al 2 para fila y columna."
            continue
        fi

        indice=$(coords_a_indice "$fila" "$col")
        if [[ ${tablero[$indice]} != " " ]]; then
            echo "Esa casilla ya está ocupada. Intenta otra diferente ;)"
            continue
        fi

        tablero[$indice]=$jugador

        if es_ganador "$jugador"; then
            imprime_tablero
            echo "¡El jugador ${jugador} ha ganado! =D"
            break
        elif es_empate; then
            imprime_tablero
            echo ":0 ¡Es un empate!"
            break
        fi

        jugador=$([[ $jugador == "X" ]] && echo "O" || echo "X")
    done
}

while true; do
    jugar
    echo -n "¿Quieres jugar otra vez? (s/n): "
    read -r respuesta
    if [[ $respuesta == "s" || $respuesta == "S" ]]; then
        reiniciar_tablero
        echo "¡Va de nuez!"
    else
        echo "Hasta la proximaa =)"
        break
    fi
done
