#!/bin/bash

# note CLI - Gestor de notas simple

# Función para sanitizar títulos
sanitize_title() {
    local title="$1"
    echo "$title" | tr '[:upper:]' '[:lower:]' | tr -cs '[:alnum:]-' '-' | sed 's/-\+/-/g; s/^-//; s/-$//'
}

# Función para obtener ruta de archivo de nota
get_note_path() {
    local title="$1"
    local sanitized=$(sanitize_title "$title")
    echo "$NOTE_DIR/$sanitized.md"
}

# Función para verificar si una nota está pineada
is_pinned() {
    local note_name="$1"
    if [ -f "$NOTE_DIR/.pinned" ]; then
        grep -q "^$note_name$" "$NOTE_DIR/.pinned"
    else
        return 1
    fi
}

# Función para pin/unpin una nota
toggle_pin() {
    local note_name="$1"
    local pinned_file="$NOTE_DIR/.pinned"
    
    # Crear archivo si no existe
    [ ! -f "$pinned_file" ] && touch "$pinned_file"
    
    if is_pinned "$note_name"; then
        # Quitar pin
        grep -v "^$note_name$" "$pinned_file" > "$pinned_file.tmp" && mv "$pinned_file.tmp" "$pinned_file"
        echo "📌 Unpinned: $note_name"
    else
        # Agregar pin
        echo "$note_name" >> "$pinned_file"
        echo "📍 Pinned: $note_name"
    fi
}

# Comando: note new <título>
note_new() {
    local title="$1"
    
    if [ -z "$title" ]; then
        echo "❌ Error: Se requiere un título"
        echo "Uso: note new <título>"
        return 1
    fi
    
    local note_path=$(get_note_path "$title")
    local note_name=$(basename "$note_path" .md)
    
    # Verificar si ya existe
    if [ -f "$note_path" ]; then
        read -p "⚠️  La nota '$title' ya existe. ¿Editar? (s/N): " confirm
        if [[ "$confirm" == "s" || "$confirm" == "S" ]]; then
            nvim "$note_path"
            return 0
        else
            echo "Operación cancelada"
            return 1
        fi
    fi
    
    # Crear y abrir en nvim
    echo "📝 Creando nueva nota: $title"
    nvim "$note_path"
    
    # Si el archivo quedó vacío, eliminarlo
    if [ -f "$note_path" ] && [ ! -s "$note_path" ]; then
        rm "$note_path"
        echo "🗑️  Nota eliminada (estaba vacía)"
    elif [ -f "$note_path" ]; then
        echo "✅ Nota guardada: $note_name"
    fi
}

# Comando: note ls
note_ls() {
    # Obtener notas pineadas
    local pinned_notes=()
    if [ -f "$NOTE_DIR/.pinned" ]; then
        mapfile -t pinned_notes < <(cat "$NOTE_DIR/.pinned")
    fi
    
    # Mostrar notas pineadas
    local has_pinned=false
    for note_name in "${pinned_notes[@]}"; do
        if [ -f "$NOTE_DIR/$note_name.md" ]; then
            echo "📍 $note_name"
            has_pinned=true
        fi
    done
    
    # Separador si hay notas pineadas
    if [ "$has_pinned" = true ] && [ -n "$(find "$NOTE_DIR" -maxdepth 1 -name "*.md" -not -name ".*" -print -quit)" ]; then
        echo "─────────────────────"
    fi
    
    # Mostrar resto de notas ordenadas por fecha de modificación
    local unpinned_notes=()
    while IFS= read -r -d '' file; do
        local note_name=$(basename "$file" .md)
        # Solo agregar si no está en pinned
        if ! is_pinned "$note_name"; then
            unpinned_notes+=("$note_name")
        fi
    done < <(find "$NOTE_DIR" -maxdepth 1 -name "*.md" -not -name ".*" -print0 | sort -z)
    
    for note_name in "${unpinned_notes[@]}"; do
        echo "📄 $note_name"
    done
}

# Comando: note show <título>
note_show() {
    local title="$1"
    
    if [ -z "$title" ]; then
        echo "❌ Error: Se requiere un título"
        echo "Uso: note show <título>"
        return 1
    fi
    
    local note_path=$(get_note_path "$title")
    
    if [ ! -f "$note_path" ]; then
        echo "❌ Nota no encontrada: $title"
        return 1
    fi
    
    echo "📄 $title"
    echo "─────────────────────"
    cat "$note_path"
}

# Comando: note edit <título>
note_edit() {
    local title="$1"
    
    if [ -z "$title" ]; then
        echo "❌ Error: Se requiere un título"
        echo "Uso: note edit <título>"
        return 1
    fi
    
    local note_path=$(get_note_path "$title")
    
    if [ ! -f "$note_path" ]; then
        echo "❌ Nota no encontrada: $title"
        return 1
    fi
    
    nvim "$note_path"
}

# Comando: note rm <título>
note_rm() {
    local title="$1"
    
    if [ -z "$title" ]; then
        echo "❌ Error: Se requiere un título"
        echo "Uso: note rm <título>"
        return 1
    fi
    
    local note_path=$(get_note_path "$title")
    
    if [ ! -f "$note_path" ]; then
        echo "❌ Nota no encontrada: $title"
        return 1
    fi
    
    read -p "⚠️  ¿Eliminar '$title'? (s/N): " confirm
    if [[ "$confirm" == "s" || "$confirm" == "S" ]]; then
        rm "$note_path"
        
        # También quitar de pinned si estaba ahí
        local note_name=$(basename "$note_path" .md)
        if is_pinned "$note_name"; then
            toggle_pin "$note_name"
        fi
        
        echo "🗑️  Nota eliminada: $title"
    else
        echo "Operación cancelada"
    fi
}

# Comando: note pin <título>
note_pin() {
    local title="$1"
    
    if [ -z "$title" ]; then
        echo "❌ Error: Se requiere un título"
        echo "Uso: note pin <título>"
        return 1
    fi
    
    local note_path=$(get_note_path "$title")
    local note_name=$(basename "$note_path" .md)
    
    if [ ! -f "$note_path" ]; then
        echo "❌ Nota no encontrada: $title"
        return 1
    fi
    
    toggle_pin "$note_name"
}

# Comando: note help
note_help() {
    echo "📘 note CLI - Gestor de notas"
    echo ""
    echo "Comandos:"
    echo "  note new <título>     Crear/editar nueva nota"
    echo "  note ls               Listar notas (pineadas primero)"
    echo "  note show <título>    Mostrar contenido de nota"
    echo "  note edit <título>    Editar nota existente"
    echo "  note rm <título>      Eliminar nota con confirmación"
    echo "  note pin <título>     Toggle pin/unpin de nota"
    echo "  note help             Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  note new \"Mi Idea\""
    echo "  note ls"
    echo "  note show \"mi-idea\""
}

# Función principal
note() {
    local cmd="$1"
    
    case "$cmd" in
        new) shift; note_new "$@" ;;
        ls) note_ls ;;
        show) shift; note_show "$@" ;;
        edit) shift; note_edit "$@" ;;
        rm) shift; note_rm "$@" ;;
        pin) shift; note_pin "$@" ;;
        help|"") note_help ;;
        *) 
            echo "❌ Comando desconocido: $cmd"
            echo "Usa 'note help' para ver los comandos disponibles"
            return 1
            ;;
    esac
}