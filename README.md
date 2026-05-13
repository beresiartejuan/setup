# Setup Personal

Colección de mis configuraciones personalizadas para el entorno de desarrollo en bash.

## 📦 Contenido

Este repositorio contiene mis configuraciones personales que uso para mejorar mi flujo de trabajo en sistemas Unix/Linux. Incluye:

- Aliases útiles para comandos comunes
- Funciones personalizadas de shell
- Configuraciones de exportación de variables de entorno

## 🔧 Características

### CLIs Disponibles

#### `gi` - Generador de .gitignore
CLI para generar archivos .gitignore usando plantillas de [gitignore.io](https://gitignore.io)

```bash
gi node,macos,vscode
```

#### `note` - Gestor de notas personal
CLI para crear, listar, editar y eliminar notas en Markdown

```bash
note new "Mi Idea"
note ls
note show "mi-idea"
note edit "mi-idea"
note rm "mi-idea"
note pin "mi-idea"
```

#### `spnpm` - PNPM sandboxeado
Comando `pnpm` con protección systemd-run para mayor seguridad

```bash
spnpm install
spnpm run dev
```

### Otros wrappers

- `rm` - Wrapper seguro para el comando `rm` que previene borrado accidental del directorio raíz

### Alias

- `npm` redirige automáticamente a `pnpm` para mejorar el rendimiento

## 🚀 Instalación

```bash
git clone https://github.com/tu-usuario/setup.git ~/setup
cd ~/setup
./install
```

El instalador:
1. Agrega las configuraciones a tu `~/.bashrc`
2. Crea enlaces simbólicos necesarios
3. No modifica ningún archivo existente sin pedir confirmación

## 🔄 Actualización

Para actualizar las configuraciones simplemente haz:

```bash
cd ~/setup
git pull
```

Las nuevas funciones y aliases se cargarán automáticamente en tu próxima sesión.

## 🛡️ Seguridad

Las funciones incluyen medidas de seguridad como:
- Protección contra borrado del directorio raíz
- Sandboxing para comandos de paquetes con systemd
- Restricciones de privilegios y directorios temporales privados
