-- 1. RENDIMIENTO
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500

-- 2. INTERFAZ
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8" -- Simplificado a utf-8 nativo
vim.opt.helplang = "es,en"

-- 3. INDENTACIÓN (2 ESPACIOS)
-- Cambiado a una forma más eficiente sin autocomandos pesados
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- 4. PORTAPAPELES (Optimizado para WSL)
-- Si tienes win32yank.exe en tu path de Windows, esto funcionará perfecto
vim.g.clipboard = {
	name = "win32yank-wsl",
	copy = { ["+"] = "win32yank.exe -i --crlf", ["*"] = "win32yank.exe -i --crlf" },
	paste = { ["+"] = "win32yank.exe -o --lf", ["*"] = "win32yank.exe -o --lf" },
	cache_enabled = 0,
}
vim.opt.clipboard = "unnamedplus"

-- 5. DIAGNÓSTICOS (Configuración unificada y moderna)
local icons = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }

vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 4 },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.Error,
			[vim.diagnostic.severity.WARN] = icons.Warn,
			[vim.diagnostic.severity.HINT] = icons.Hint,
			[vim.diagnostic.severity.INFO] = icons.Info,
		},
	},
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "if_many", -- Esto quita el error de Type Mismatch
	},
})

-- 6. INTERFAZ LSP (Ventanas redondeadas - Estilo Moderno)

-- Configuramos el borde para los dos handlers principales sin redefinir funciones
vim.lsp.handlers["textDocument/hover"] = vim.diagnostic.config({ float = { border = "rounded" } })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.diagnostic.config({ float = { border = "rounded" } })

-- Forzar que los archivos .md siempre se carguen como markdown puro
vim.filetype.add({
	extension = {
		md = "markdown",
	},
})
