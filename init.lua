-- Silenciar avisos de funciones obsoletas
--  vim.g.deprecation_warnings = false

vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.loaded_perl_provider = 0

-- Fix para el runtimepath de Treesitter en Linux/WSL
-- FIX DEFINITIVO RUNTIMEPATH
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")
local ok_opts, _ = pcall(require, "opciones")
if not ok_opts then
	print("⚠️ No se encontró lua/opciones.lua")
end
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- 7. CONFIGURACIÓN DE LAZY
require("lazy").setup("plugins", {
	change_detection = { notify = false },
	checker = { enabled = true },
	performance = {
		cache = { enabled = true },

		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	ui = {
		icons = {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
	rocks = { enabled = false },
})

pcall(require, "mapas")
pcall(require, "config.autocomandos")

pcall(function()
	require("config.generate_cheatsheet").setup()
end)
