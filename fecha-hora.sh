#!/bin/bash

ROJO='\033[1;31m'
AZUL='\033[1;34m'
RESET='\033[0m'

fecha=$(grep "rtc_date" /proc/driver/rtc | sed 's/rtc_date[ \t]*:[ \t]*//')
hora=$(grep "rtc_time" /proc/driver/rtc | sed 's/rtc_time[ \t]*:[ \t]*//')

IFS='-' read -r anio mes dia <<< "$fecha"
IFS=':' read -r h m s <<< "$hora"

echo -e "${ROJO}Fecha:${RESET} $dia/$mes/$anio"
echo -e "${ROJO}Hora:${RESET} $h:$m:$s"

echo -e "${AZUL}日付:${RESET} ${anio}年${mes}月${dia}日"
echo -e "${AZUL}時刻:${RESET} ${h}時${m}分${s}秒"
