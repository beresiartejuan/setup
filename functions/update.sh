update-all() {
    echo "🔄 Actualizando sistema..."
    local updated=false
    
    # Detectar y ejecutar gestores de paquetes disponibles
    if command -v pacman >/dev/null 2>&1; then
        # Arch Linux - ejecutar todos los gestores AUR disponibles
        if command -v yay >/dev/null 2>&1; then
            echo "📦 Actualizando con yay (Arch + AUR)"
            yay -Syu
            updated=true
        fi
        
        if command -v paru >/dev/null 2>&1; then
            echo "📦 Actualizando con paru (Arch + AUR)"
            paru -Syu
            updated=true
        fi
        
        if command -v aura >/dev/null 2>&1; then
            echo "📦 Actualizando con aura (Arch + AUR)"
            aura -Syu
            updated=true
        fi
        
        # Siempre ejecutar pacman para actualizar paquetes base del sistema
        echo "📦 Actualizando con pacman (Arch base packages)"
        sudo pacman -Syu
        updated=true
    elif command -v apt >/dev/null 2>&1; then
        # Debian/Ubuntu
        echo "📦 Actualizando con apt (Debian/Ubuntu)"
        sudo apt update && sudo apt upgrade
        updated=true
    else
        echo "❌ No se encontró un gestor de paquetes compatible"
        return 1
    fi
    
    echo "✅ Actualización completada"
}