#!/bin/bash

AZUL='\033[1;34m'
VERDE='\033[1;32m'
ROJO='\033[1;31m'
RESET='\033[0m'

# bloquear ctrl+c, ctrl+z
trap ' ' SIGINT SIGTSTP SIGTERM

intentos=0
max_intentos=3

echo -e "${ROJO}=============================${RESET}"
echo -e "${AZUL}     B I E N V E N I D O     ${RESET}"
echo -e "${ROJO}=============================${RESET}"
echo -e "${AZUL}Inicia sesión para continuar\n${RESET}"

while [[ $intentos -lt $max_intentos ]]; do
    read -p "Usuario: " usuario
    read -s -p "Contraseña: " contrasena
    echo ""

    # autenticacion
    echo "$contrasena" | su - "$usuario" -c "exit" &>/dev/null

    if [[ $? -eq 0 ]]; then
        echo -e "\n${VERDE}¡Hola, $usuario!${RESET}\n"

        # verificar permisos de ejecución para main.sh
        if [[ ! -x ./comandos/main.sh ]]; then
            chmod +x ./comandos/main.sh
        fi
        ./comandos/main.sh
        # restablecer el comportamiento de ctrl+c, ctrl+z
        trap - SIGINT SIGTSTP SIGTERM
        exit 0
    else
        ((intentos++))
        if [[ $intentos -lt $max_intentos ]]; then
            echo -e "\n${ROJO}Usuario o contraseña incorrectos. $((max_intentos - intentos)) intento(s) restante(s).\n${RESET}"
        fi
    fi
done

echo -e "\n${ROJO}No fue posible iniciar sesión con tus credenciales :(${RESET}"
# restablecer el comportamiento de ctrl+c, ctrl+z
trap - SIGINT SIGTSTP SIGTERM
exit 1
