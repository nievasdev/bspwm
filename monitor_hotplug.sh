#!/bin/bash

# Script mejorado para detectar cambios de monitores y reiniciar bspwm
# Guarda este archivo en ~/.config/bspwm/monitor_hotplug.sh

LOG_FILE="$HOME/.config/bspwm/monitor_hotplug.log"
LOCK_FILE="/tmp/bspwm_hotplug.lock"
STATE_FILE="/tmp/bspwm_monitor_state"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - [HOTPLUG] $1" >> "$LOG_FILE"
}

# Función para limpiar archivos temporales
cleanup() {
    rm -f "$LOCK_FILE" "$STATE_FILE"
    log "Proceso de hotplug terminado"
    exit 0
}

# Capturar señales para limpieza
trap cleanup EXIT INT TERM

# Verificar si ya hay una instancia ejecutándose
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        log "Ya hay una instancia ejecutándose (PID: $PID). Saliendo."
        exit 1
    else
        log "Archivo de bloqueo obsoleto encontrado. Eliminando."
        rm -f "$LOCK_FILE"
    fi
fi

# Crear archivo de bloqueo
echo $$ > "$LOCK_FILE"

get_connected_monitors() {
    # Usar timeout para evitar cuelgues de xrandr
    timeout 5 xrandr --query 2>/dev/null | grep " connected" | awk '{print $1}' | sort | tr '\n' ' '
}

get_monitor_details() {
    # Obtener detalles completos de monitores (resolución, posición)
    timeout 5 xrandr --query 2>/dev/null | grep " connected" | \
    awk '{
        name=$1
        if ($3 == "primary") {
            res=$4
            primary="[PRIMARY]"
        } else {
            res=$3
            primary=""
        }
        print name " " res " " primary
    }' | sort
}

# Función mejorada para reiniciar bspwm
restart_bspwm() {
    log "Iniciando reinicio de bspwm debido a cambio de monitores"
    
    # Verificar que bspwm está ejecutándose
    if ! pgrep -x bspwm > /dev/null; then
        log "ERROR: bspwm no está ejecutándose"
        return 1
    fi
    
    # Crear backup del estado actual
    local backup_file="/tmp/bspwm_state_$(date +%s).tmp"
    if bspc wm -d > "$backup_file" 2>/dev/null; then
        log "Estado de bspwm guardado en $backup_file"
    else
        log "WARNING: No se pudo guardar el estado de bspwm"
    fi
    
    # Pequeña pausa para estabilizar el sistema
    sleep 0.5
    
    # Reiniciar bspwm
    if bspc wm -r; then
        log "bspwm reiniciado exitosamente"
        
        # Actualizar polybar si está disponible
        if command -v polybar > /dev/null && [ -f "$HOME/.config/polybar/config/launch.sh" ]; then
            log "Reiniciando polybar..."
            "$HOME/.config/polybar/config/launch.sh" &
        fi
        
        return 0
    else
        log "ERROR: Fallo al reiniciar bspwm"
        return 1
    fi
}

# Función para detectar cambios significativos
monitors_changed() {
    local old_state="$1"
    local new_state="$2"
    
    # Comparar número de monitores
    local old_count=$(echo "$old_state" | wc -w)
    local new_count=$(echo "$new_state" | wc -w)
    
    if [ "$old_count" != "$new_count" ]; then
        return 0  # Cambio detectado
    fi
    
    # Comparar nombres de monitores
    if [ "$old_state" != "$new_state" ]; then
        return 0  # Cambio detectado
    fi
    
    return 1  # No hay cambios
}

# Inicialización
log "=== Iniciando monitor de hotplug para bspwm ==="
log "PID del proceso: $$"

# Esperar a que el entorno esté listo
sleep 2

# Obtener estado inicial
CURRENT_MONITORS=$(get_connected_monitors)
if [ -z "$CURRENT_MONITORS" ]; then
    log "WARNING: No se pudieron detectar monitores inicialmente"
    CURRENT_MONITORS=""
fi

echo "$CURRENT_MONITORS" > "$STATE_FILE"
log "Monitores iniciales: $CURRENT_MONITORS"

# Monitorear cambios usando múltiples métodos
{
    # Método 1: udevadm para eventos de hardware
    udevadm monitor --udev --subsystem-match=drm 2>/dev/null | while read -r line; do
        if echo "$line" | grep -q "HOTPLUG=1"; then
            echo "HOTPLUG_EVENT"
        fi
    done &
    
    # Método 2: Polling periódico como respaldo
    while true; do
        sleep 5
        echo "POLL_CHECK"
    done &
    
    # Procesar eventos
    while read -r event; do
        case "$event" in
            "HOTPLUG_EVENT"|"POLL_CHECK")
                # Esperar a que el sistema se estabilice
                sleep 1
                
                NEW_MONITORS=$(get_connected_monitors)
                
                # Verificar si hubo cambios significativos
                if monitors_changed "$CURRENT_MONITORS" "$NEW_MONITORS"; then
                    log "Cambio de monitores detectado:"
                    log "  Antes: [$CURRENT_MONITORS]"
                    log "  Después: [$NEW_MONITORS]"
                    
                    # Actualizar detalles de monitores
                    MONITOR_DETAILS=$(get_monitor_details)
                    log "  Detalles: $MONITOR_DETAILS"
                    
                    # Actualizar estado
                    CURRENT_MONITORS="$NEW_MONITORS"
                    echo "$CURRENT_MONITORS" > "$STATE_FILE"
                    
                    # Reiniciar bspwm
                    if restart_bspwm; then
                        log "Reinicio completado exitosamente"
                    else
                        log "ERROR: Fallo en el reinicio"
                    fi
                elif [ "$event" = "POLL_CHECK" ]; then
                    # Log silencioso cada cierto tiempo para confirmar que está funcionando
                    if [ $(($(date +%s) % 300)) -eq 0 ]; then  # Cada 5 minutos
                        log "Monitor funcionando. Monitores actuales: $CURRENT_MONITORS"
                    fi
                fi
                ;;
        esac
    done
}