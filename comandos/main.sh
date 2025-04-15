#!/bin/bash

# desactivar exit
exit() { :; }

# bloquear ctrl+c, ctrl+z, y ctrl+d
trap ' ' SIGINT SIGTSTP SIGTERM

# guardar ruta absoluta del directorio de los scripts
script_dir=$(dirname "$(realpath "$0")")

cd ~

while true; do
    # obtener usuario y directorio actual
    usuario=$USER
    host=$(hostname)

    if [[ "$PWD" == "$HOME"* ]]; then
        dir_actual="~${PWD#$HOME}"
    else
        dir_actual="$PWD"
    fi

    printf "\e[1;35m┌─[\e[1;36m$usuario@$host\e[1;35m]\n"
    printf "└──[\e[1;33m$dir_actual\e[1;35m]$ \e[0m"

    read -r input

    # salir
    if [[ "$input" == "salir" ]]; then
        echo -e "\e[1;32mByeeee\e[0m"
        break
    fi

    # comandos personalizados
    comando=$(echo "$input" | cut -d ' ' -f1)
    script_path="$script_dir/$comando.sh"

    # impedir que se ejecute login.sh o main.sh dentro de la terminal
    if [[ "$comando" == "login" || "$comando" == "main" ]]; then
        echo -e "\e[1;31mNo puedes iniciar otra sesión desde la terminal actual.\e[0m"
        continue
    fi

    # ejecutar script personalizado
    if [[ -f "$script_path" && ! -d "$script_path" ]]; then
        if [[ ! -x "$script_path" ]]; then
            chmod +x "$script_path"
        fi
        source "$script_path"
    else
        eval "$input"
    fi
done

# restablecer el comportamiento de ctrl+c, ctrl+z, y ctrl+d
trap - SIGINT SIGTSTP SIGTERM
