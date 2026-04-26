# 🛠️ Terminal Setup & Utilities

Este repositorio contiene mis configuraciones personalizadas de terminal, scripts de automatización y herramientas útiles para potenciar el flujo de trabajo en Bash.

## 🚀 Características

- **Modularidad:** Carga automáticamente archivos de `aliases.sh`, `exports.sh` y todas las funciones dentro de `functions/*.sh`.
- **Instalación Limpia:** Script de instalación inteligente que evita duplicados en `.bashrc` y utiliza banderas para detectar instalaciones previas.
- **Deno Ready:** Preparado para ejecutar mini-programas de consola escritos en TypeScript/JavaScript mediante Deno.
- **Utilidades Incluidas:**
  - `gi`: Generador instantáneo de archivos `.gitignore` utilizando la API de Toptal.

## 📦 Instalación

Para instalar estas herramientas en tu entorno local, clona este repositorio en `~/setup` y ejecuta el script de instalación:

```bash
git clone https://github.com/tu-usuario/setup.git ~/setup
cd ~/setup
./install
source ~/.bashrc
```

El instalador se encargará de:
1. Crear las carpetas necesarias (`db`, `files`, `flags`, `tmp`).
2. Configurar tu `.bashrc` para cargar automáticamente los módulos.
3. Verificar e instalar **Deno** si no está presente en el sistema.

## 📂 Estructura del Proyecto

- `aliases.sh`: Definiciones de alias personalizados.
- `exports.sh`: Variables de entorno y configuraciones de PATH.
- `functions/`: Directorio para funciones de Bash reutilizables.
- `modules/`: Programas y scripts más complejos (Deno).
- `files/` & `db/`: Almacenamiento local para herramientas que lo requieran.

---
✨ Mantén tu terminal organizada y productiva.
