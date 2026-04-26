gi() {
    # 1. Verificar si el archivo ya existe
    if [ -f .gitignore ]; then
        echo "⚠️  Ya existe un archivo .gitignore en este directorio. Operación cancelada."
        return 1
    fi

    # 2. Verificar si el usuario pasó argumentos
    if [ -z "$1" ]; then
        echo "❌ Error: Debes especificar qué lenguajes o herramientas quieres."
        echo "   Uso: gi node,macos,vscode"
        return 1
    fi

    # 3. Descargar y guardar
    echo "📥 Generando .gitignore para: $1..."
    curl -L -s "https://www.toptal.com/developers/gitignore/api/$1" > .gitignore

    # 4. Verificar si la descarga fue exitosa
    if [ -f .gitignore ]; then
        echo "✅ Archivo .gitignore creado con éxito."
    else
        echo "❌ Hubo un error al descargar la plantilla."
    fi
}