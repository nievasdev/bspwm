#!/bin/bash

# Utilidades para gestionar el sistema de monitores de bspwm

BSPWM_DIR="$HOME/.config/bspwm"
SETUP_LOG="$BSPWM_DIR/setup.log"
HOTPLUG_LOG="$BSPWM_DIR/monitor_hotplug.log"
MANAGER_LOG="$BSPWM_DIR/hotplug_manager.log"

case "$1" in
    "status")
        echo "=== Estado del Sistema de Monitores ==="
        echo
        echo "Monitores conectados:"
        xrandr --query | grep " connected" | while read line; do
            echo "  $line"
        done
        echo
        echo "Escritorios de bspwm:"
        for monitor in $(bspc query -M --names); do
            echo "  Monitor $monitor:"
            bspc query -D -m "$monitor" --names | sed 's/^/    Escritorio /'
        done
        echo
        echo "Procesos de hotplug:"
        pgrep -f "monitor_hotplug.sh" > /dev/null && echo "  ✓ Sistema de hotplug activo" || echo "  ✗ Sistema de hotplug inactivo"
        ;;
        
    "logs")
        echo "=== Logs del Sistema ==="
        echo
        if [ -f "$SETUP_LOG" ]; then
            echo "--- Últimas 5 líneas del log de configuración ---"
            tail -5 "$SETUP_LOG"
            echo
        fi
        
        if [ -f "$HOTPLUG_LOG" ]; then
            echo "--- Últimas 10 líneas del log de hotplug ---"
            tail -10 "$HOTPLUG_LOG"
            echo
        fi
        
        if [ -f "$MANAGER_LOG" ]; then
            echo "--- Últimas 5 líneas del log del manager ---"
            tail -5 "$MANAGER_LOG"
        fi
        ;;
        
    "restart")
        echo "Reiniciando sistema de monitores..."
        
        # Matar procesos de hotplug existentes
        pkill -f "monitor_hotplug.sh" 2>/dev/null
        sleep 1
        
        # Reiniciar bspwm
        bspc wm -r
        echo "Sistema reiniciado"
        ;;
        
    "test")
        echo "=== Prueba de Configuración ==="
        echo
        echo "Ejecutando setup_monitors manualmente..."
        
        # Extraer y ejecutar la función setup_monitors
        source "$BSPWM_DIR/bspwmrc"
        setup_monitors
        
        echo "Configuración aplicada. Estado actual:"
        $0 status
        ;;
        
    "monitor")
        echo "Monitoreando logs en tiempo real..."
        echo "Presiona Ctrl+C para salir"
        echo
        
        # Crear los archivos de log si no existen
        touch "$SETUP_LOG" "$HOTPLUG_LOG" "$MANAGER_LOG"
        
        # Monitorear todos los logs
        tail -f "$SETUP_LOG" "$HOTPLUG_LOG" "$MANAGER_LOG" | \
        sed -e 's/^/[LOG] /' -e 's/==> .* <==/\n&\n/'
        ;;
        
    "clean")
        echo "Limpiando logs antiguos..."
        
        # Mantener solo las últimas 100 líneas de cada log
        for log_file in "$SETUP_LOG" "$HOTPLUG_LOG" "$MANAGER_LOG"; do
            if [ -f "$log_file" ]; then
                tail -100 "$log_file" > "${log_file}.tmp"
                mv "${log_file}.tmp" "$log_file"
                echo "  Limpiado: $(basename $log_file)"
            fi
        done
        
        # Limpiar archivos temporales
        rm -f /tmp/bspwm_*.tmp
        rm -f /tmp/bspwm_hotplug.lock
        rm -f /tmp/bspwm_monitor_state
        echo "Archivos temporales limpiados"
        ;;
        
    *)
        echo "Utilidades para el sistema de monitores de bspwm"
        echo
        echo "Uso: $0 <comando>"
        echo
        echo "Comandos disponibles:"
        echo "  status   - Mostrar estado actual de monitores y escritorios"
        echo "  logs     - Mostrar logs recientes del sistema"
        echo "  restart  - Reiniciar el sistema de monitores"
        echo "  test     - Probar configuración manualmente"
        echo "  monitor  - Monitorear logs en tiempo real"
        echo "  clean    - Limpiar logs y archivos temporales"
        echo
        echo "Ejemplos:"
        echo "  $0 status    # Ver estado actual"
        echo "  $0 logs      # Ver logs recientes"
        echo "  $0 monitor   # Monitorear en tiempo real"
        ;;
esac