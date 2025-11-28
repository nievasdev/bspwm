#!/bin/bash

# Script para inicializar el sistema de hotplug de monitores para bspwm
# Este script debe ejecutarse automáticamente al iniciar bspwm

LOG_FILE="$HOME/.config/bspwm/hotplug_manager.log"
HOTPLUG_SCRIPT="$HOME/.config/bspwm/monitor_hotplug.sh"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - [HOTPLUG_MANAGER] $1" >> "$LOG_FILE"
}

# Verificar que el script de hotplug existe y es ejecutable
if [ ! -f "$HOTPLUG_SCRIPT" ]; then
    log "ERROR: Script de hotplug no encontrado en $HOTPLUG_SCRIPT"
    exit 1
fi

if [ ! -x "$HOTPLUG_SCRIPT" ]; then
    log "Haciendo ejecutable el script de hotplug"
    chmod +x "$HOTPLUG_SCRIPT"
fi

# Verificar si ya hay una instancia ejecutándose
if pgrep -f "monitor_hotplug.sh" > /dev/null; then
    log "Ya hay una instancia de monitor_hotplug ejecutándose"
    exit 0
fi

# Esperar a que bspwm esté completamente iniciado
sleep 3

log "Iniciando sistema de hotplug de monitores"

# Iniciar el script de hotplug en segundo plano
nohup "$HOTPLUG_SCRIPT" > /dev/null 2>&1 &
HOTPLUG_PID=$!

log "Sistema de hotplug iniciado con PID: $HOTPLUG_PID"

# Verificar que se inició correctamente
sleep 2
if ps -p "$HOTPLUG_PID" > /dev/null 2>&1; then
    log "Sistema de hotplug funcionando correctamente"
    exit 0
else
    log "ERROR: Fallo al iniciar el sistema de hotplug"
    exit 1
fi