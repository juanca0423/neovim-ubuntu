# 🛠️ Entorno de Desarrollo Juanca (Ubuntu/WSL)

![Go](https://img.shields.io/badge/Go-00ADD8?style=for-the-badge&logo=go&logoColor=white)
![Neovim](https://img.shields.io/badge/Neovim-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

## 📋 1. Requisitos del Sistema (Instalación masiva)
En Ubuntu, no usamos Chocolatey. Usamos `apt`. Ejecuta esto para tener todo el "hierro" necesario:

```Bash
sudo apt update && sudo apt install -y \
  build-essential git nvim nodejs npm python3-pip \
  ruby-full julia curl wget unzip zip xclip \
  ripgrep fd-find fzf bat imagemagick
```
Python Provider:
```Bash
python3 -m pip install --upgrade pynvim --break-system-packages
```

## 🐘 2. Base de Datos (PostgreSQL 18)
En lugar de instalarlo nativo, usaremos Docker (como hacías en Windows) para evitar ensuciar el sistema.

## Configuración de Seguridad (Variables de Entorno)
En Linux, no usamos el comando de PowerShell. Añade esto a tu `~/.bash_aliases`:

```Bash
# Credenciales para el Dashboard de EEFF
export DB_PASS_EEFF="tu_clave_aqui"
export DB_USER_EEFF="juanca"
export DB_NAME_EEFF="eeff"
```

## 🐹 3. Entorno Go (Backend EEFF)
Asegúrate de tener instaladas las herramientas de formateo que Neovim usará para tus índices financieros:
```Bash
go install mvdan.cc/gofumpt@latest
go install github.com/segmentio/golines@latest
# El PATH se carga desde tu .bash_aliases 
```

## 🚀 4. Instalación de Neovim
### 1. Clonar tu configuración

```Bash
git clone git@github.com:juanca0423/neovim-ubuntu.git ~/.config/nvim
```

### 2. Instalar Parsers de Treesitter (Cubre todos tus lenguajes)
```Nvim
:TSInstall gomod gowork gotmpl sql python css ecma go graphql html html_tags http javascript json jsx latex lua markdown markdown_inline regex scss svelte tsx typescript typst vue

:MasonInstall
```

## 🐳 5. Docker & Contenedores
Para que tu comando `d-up` funcione igual que en Windows, asegúrate de tener Docker instalado en Ubuntu. 
> **Tip:** En WSL2, lo mejor es instalar **Docker Desktop** en Windows y activar la integración con Ubuntu en la configuración.

Comandos rápidos:
- `docker-compose up -d` (Levantar DB eeff)
- `docker-compose down -v` (Limpiar todo si hay errores de versión)

## ⌨️ 6. Atajos Maestros (Keymaps)
| Atajo | Acción |
| :--- | :--- |
| `,w` | Guardar archivo rápido |
| `gf` | Saltar a siguiente función (Go/JS) |
| `ga` | Saltar a función anterior |
| `,hr` | Ejecutar petición API (Kulala) |
| `lg` | Abrir LazyGit |

## 🛠️ 7. Troubleshooting (Solución de Problemas)

### Error: Iconos no se ven
Asegúrate de que en la **Terminal de Windows** (donde corre Ubuntu) tengas seleccionada `JetBrainsMono Nerd Font`

### Error: "fdfind" no encontrado
Ubuntu llama al comando `fdfind`. En tus alias ya pusimos:
`alias fd='fdfind'` para que Telescope no falle.

### Limpieza de caché (Equivalente a lo que hacías en Windows)
Si Neovim se pone lento:
```Bash
rm -rf ~/.local/share/nvim/shada/*
```
---
