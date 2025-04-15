#!/bin/bash

ROJO='\033[1;31m'
AZUL='\033[1;34m'
RESET='\033[0m'

#################################################################### RAM
# Comando para obtener información de la memoria
info_memoria=$(free -m | grep Mem)
# Separar los valores de total, usada y libre
mem_total=$(echo $info_memoria | awk '{print $2}')
mem_utilizada=$(echo $info_memoria | awk '{print $3}')
mem_disponible=$(echo $info_memoria | awk '{print $4}')

########################################################### Arquitectura
# Comando para obtener la arquitectura del sistema
arq=$(uname -p)

##################################################################### OS
# Comando para obtener el nombre del sistema operativo
os_name=$(lsb_release -d | cut -f2)
# Comando para obtener la distribución madre
basado_en=$(grep "^ID_LIKE=" /etc/os-release | cut -d= -f2 | tr -d '"')
# Comando para obtener la versión del kernel
kernel=$(uname -r)

########################################################################

echo -e "${ROJO}-----------------------------------------------${RESET}
${AZUL} I N F O R M A C I O N   D E L   S I S T E M A${RESET}
${ROJO}-----------------------------------------------${RESET}"
echo -e "${ROJO}M e m o r i a   R A M${RESET}"
echo -e "${AZUL}Total:${RESET} $mem_total MB"
echo -e "${AZUL}Utilizada:${RESET} $mem_utilizada MB"
echo -e "${AZUL}Disponible:${RESET} $mem_disponible MB"
echo -e "${ROJO}-----------------------------------------------${RESET}
${ROJO}A r q u i t e c t u r a${RESET}"
echo -e "${AZUL}$arq${RESET}"
echo -e "${ROJO}-----------------------------------------------${RESET}
${ROJO}S i s t e m a   O p e r a t i v o${RESET}"
echo -e "${AZUL}Distribución:${RESET} $os_name"
echo -e "${AZUL}Basado en:${RESET} $basado_en"
echo -e "${AZUL}Kernel${RESET} $kernel"
echo -e "${ROJO}-----------------------------------------------${RESET}"