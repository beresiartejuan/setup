update-all() {
    echo "🔄 Actualizando sistema..."
    local updated=false
    
    # Detectar y ejecutar gestores de paquetes disponibles
    if command -v pacman >/dev/null 2>&1; then
        # Arch Linux - ejecutar todos los gestores AUR disponibles + pacman
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
        
        # Si no hay gestores AUR, usar pacman
        if [ "$updated" = false ]; then
            echo "📦 Actualizando con pacman (Arch)"
            sudo pacman -Syu
        fi
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