#!/bin/bash

# ========================================
# Reproduce archivos MP3 desde una carpeta definida por el usuario.
# Incluye un menú para seleccionar canciones y muestra algunas instrucciones.
# Para la correcta ejecución, se requiere el reproductor 'mpg123' y
# una carpeta existente con archivos MP3.
# ========================================

# Definición de colores para mejorar la visualización en la terminal
CYAN="\e[36m"     # Azul claro para secciones informativas
YELLOW="\e[33m"   # Amarillo para entradas de usuario
RED="\e[31m"      # Rojo para mensajes de error
GREEN="\e[32m"    # Verde para mensajes de éxito o confirmación
RESET="\e[0m"     # Restablece el color al valor por defecto

# Verificar si el reproductor 'mpg123' está instalado
# Si no está instalado, se ofrece la opción de instalarlo en el moento
if ! command -v mpg123 &> /dev/null; then
    echo -e "${YELLOW}El reproductor 'mpg123' no está instalado.${RESET}"
    read -p "¿Deseas instalarlo ahora? (s/n): " respuesta
    if [[ "$respuesta" == "s" || "$respuesta" == "S" ]]; then
        sudo apt update && sudo apt install -y mpg123   # Instala mpg123 como si se hiciera normalmente desde terminal
    else
        echo -e "${RED}No se puede continuar sin mpg123. Saliendo del reproductor${RESET}"
        exit 1                                          # Termina el script si el usuario no desea instalar
    fi
fi

# Leer configuración de la carpeta de música desde un archivo oculto
# Si no existe el archivo de configuración, se solicita la ruta al usuario y se guarda
CONFIG_FILE="./recursos/.config_musica"

if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${YELLOW}No se encontró configuración de música.${RESET}"
    echo -e "${CYAN}Por favor, ingresa la ruta de tu carpeta de música con el siguiente formato${RESET}"
    echo -e "${YELLOW}Ejemplo: /home/usuario/Música${RESET}"
    read -rp "Ingresa la ruta de tu carpeta de música: " music_dir
    echo "$music_dir" > "$CONFIG_FILE"
else
    music_dir=$(cat "$CONFIG_FILE")  # Lee la ruta guardada
fi

# Verificar que la carpeta de música exista
if [ ! -d "$music_dir" ]; then
    echo -e "${RED}La carpeta '$music_dir' no existe.${RESET}"
    exit 2  # Termina si la carpeta no es válida
fi

# Buscar archivos .mp3 dentro de la carpeta indicada (y las subcarpetas)
mapfile -t songs < <(find "$music_dir" -type f -iname "*.mp3")  # Busca archivos con extensión mp3 y los almacena en un array

# Verificar si se encontraron canciones
if [ ${#songs[@]} -eq 0 ]; then
    echo -e "${RED}No se encontraron archivos MP3 en '$music_dir'.${RESET}"
    exit 3                                                      # Termina si no se encuentran canciones
fi

# Bucle principal con el menú para seleccionar y reproducir canciones
while true; do
    clear
    echo -e "${CYAN}🎵 Lista de canciones disponibles:${RESET}"

    # Muestra cada canción con numeración
    for i in "${!songs[@]}"; do
        echo -e "${YELLOW}$((i+1))${RESET}) $(basename "${songs[$i]}")"
    done

    # Opción para salir del reproductor y volver al menú principal
    echo -e "${YELLOW}q${RESET}) Salir del reproductor"
    echo

    # Solicita al usuario una opción
    read -rp "Selecciona una canción por número o 'q' para salir: " opcion

    # Si el usuario elige 'q', termina el script
    if [[ "$opcion" == "q" ]]; then
        echo -e "${GREEN}Saliendo del reproductor.${RESET}"
        sleep 1
        break
    fi

    # Validación: solo acepta números válidos dentro del rango
    if ! [[ "$opcion" =~ ^[0-9]+$ ]] || (( opcion < 1 || opcion > ${#songs[@]} )); then
        echo -e "${RED}Entrada inválida. Intenta de nuevo.${RESET}"
        sleep 1.5
        continue
    fi

    # Selecciona la canción correspondiente a la opción del usuario
    seleccion="${songs[$((opcion-1))]}"

    # Limpia pantalla y muestra información previa a la reproducción
    clear
    echo -e "${GREEN}▶️ Reproduciendo:${RESET} $(basename "$seleccion")"
    echo -e "${CYAN}Pulsa Ctrl+C para detener la reproducción y volver al menú.${RESET}"
    sleep 1

    # Reproduce el archivo seleccionado usando mpg123
    mpg123 "$seleccion"

    # Pausa para que el usuario regrese manualmente al menú tras detener la canción
    echo
    read -n1 -rsp $'Presiona cualquier tecla para volver al menú.\n'
done



