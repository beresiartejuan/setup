update-all() {
    echo "🔄 Actualizando sistema..."
    
    # Detectar gestor de paquetes disponible
    if command -v pacman >/dev/null 2>&1; then
        # Si yay está disponible, usarlo (probablemente es Arch con AUR)
        if command -v yay >/dev/null 2>&1; then
            echo "📦 Usando yay (Arch + AUR)"
            yay -Syu
        # Si paru está disponible, usarlo
        elif command -v paru >/dev/null 2>&1; then
            echo "📦 Usando paru (Arch + AUR)"
            paru -Syu
        # Si aura está disponible, usarlo
        elif command -v aura >/dev/null 2>&1; then
            echo "📦 Usando aura (Arch + AUR)"
            aura -Syu
        else
            # Solo pacman
            echo "📦 Usando pacman (Arch)"
            sudo pacman -Syu
        fi
    elif command -v apt >/dev/null 2>&1; then
        # Debian/Ubuntu
        echo "📦 Usando apt (Debian/Ubuntu)"
        sudo apt update && sudo apt upgrade
    else
        echo "❌ No se encontró un gestor de paquetes compatible"
        return 1
    fi
    
    echo "✅ Actualización completada"
}