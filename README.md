Markdown
# Juanca's Neovim Config (Go & Backend Edition)

Configuración optimizada para desarrollo backend con Go, PostgreSQL y Neovim 0.11+.

## 📋 Requisitos del Sistema (Ubuntu/Debian)

Antes de clonar, instala las dependencias base:

```bash
# Base
sudo apt update && sudo apt install -git curl unzip build-essential python3-pip

# Neovim (Versión 0.11 o superior recomendada)
# Recomiendo instalar vía PPA o descargar el .appimage
```
## 🛠️ Herramientas de Lenguaje (LSP & Formatter)
Para que el Dashboard y el formateo funcionen, instala:

Go: ```go install mvdan.cc/gofumpt@latest```

Lua: ```sudo apt install stylua``` o via npm.

Node/NPM: (Para Prettier y SQL-formatter)

```bash
sudo apt install nodejs npm
sudo npm install -g sql-formatter @johnnymorganz/stylua-bin
Python Provider:
```
```bash
python3 -m pip install --upgrade pynvim --break-system-packages
```
## 🚀 Instalación Rápida
Clonar en ~/.config/nvim:

```Bash
git clone <tu-repo-ssh> ~/.config/nvim
```
Abrir Neovim y esperar a que Lazy.nvim instale los plugins.

Ejecutar :MasonInstallAll (si usas un comando similar) o dejar que Mason instale los LSPs.

Ejecutar :TSInstall http go lua html css para los colores.

⌨️ Atajos Clave
,w : Guardar.

gf / ga : Saltar entre funciones.

,hr : Ejecutar petición HTTP (Kulala).


---
