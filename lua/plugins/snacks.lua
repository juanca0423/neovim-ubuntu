return {
	"folke/snacks.nvim",
	event = "VimEnter",
	priority = 1000,
	lazy = false,
	opts = {
		image = { enabled = false },
		indent = { enabled = false },
		input = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = false },
		statuscolumm = { enabled = true },
		words = { enabled = true },
		debug = { enabled = false },
		terminal = { enabled = true },
		toggle = { enabled = true },
		bigfile = { enabled = true },
		dashboard = {
			animate = { enabled = true },
			enabled = true,
			sections = {
				{ section = "header" },
				{ section = "keys" },
				{ section = "startup" },
			},
			preset = {
				header = [[
      ██████╗  ██████╗      ██╗███████╗
     ██╔════╝ ██╔═══██╗     ██║██╔════╝
     ██║  ███╗██║   ██║     ██║███████╗
     ██║   ██║██║   ██║██   ██║╚════██║
     ╚██████╔╝╚██████╔╝╚█████╔╝███████║
      ╚═════╝  ╚═════╝  ╚════╝ ╚══════╝

        DEVELOPER: JUAN CARLOS
      GO • JS • HTML • CSS STACK]],
				keys = {
					{
						icon = " ",
						key = "f",
						desc = "Buscar Archivo",
						action = ":lua Snacks.dashboard.pick('files')",
					},
					{ icon = " ", key = "n", desc = "Nuevo Archivo", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "g",
						desc = "Buscar Texto",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{ icon = "󰉋 ", key = "p", desc = "Mis Proyectos", action = ":lua Snacks.picker.projects()" },
					-- 1. RUTA CORREGIDA PARA BASES DE DATOS (WSL)
					{
						icon = "󰆼 ",
						key = "s",
						desc = "Bases de Datos (SQL)",
						action = function()
							-- En WSL, accedemos a tus archivos de Windows mediante /mnt/c/
							Snacks.picker.files({ cwd = "/mnt/c/Users/Usuario/Documents/Desarrollo/Database" })
						end,
					},
					{ icon = " ", key = "m", desc = "Documentos md", action = ":OpenDocs" },
					{ icon = " ", key = "r", desc = "Recientes", action = ":lua Snacks.dashboard.pick('oldfiles')" },
					{
						icon = " ",
						key = "c",
						desc = "Configuración",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
					{ icon = " ", key = "q", desc = "Salir", action = ":qa" },
					{ title = "Documentación y Enlaces", indent = 4, gap = 0, padding = 1 },
					{
						icon = "󰟓 ",
						key = "G",
						desc = "Go Packages",
						action = function()
							vim.ui.open("https://pkg.go.dev/")
						end,
					},
					{
						icon = " ",
						key = "R",
						desc = "GitHub",
						action = function()
							vim.ui.open("https://github.com/juanca0423/")
						end,
					},
				},
			},
		},
		picker = {
			enabled = true,
			sources = { files = { hidden = true } },
		},
		explorer = { enabled = true, replace_netrw = true },
		winbar = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 2000, -- Tiempo en milisegundos (3 seg). Por defecto son 5.
			width = { min = 40, max = 0.4 }, -- Ancho de la ventana de notificación
			margin = { top = 0, right = 1, bottom = 0 },
			style = "compact", -- Opciones: "compact", "fancy", "flat"
			top_down = true, -- Si prefieres que las nuevas salgan arriba o abajo
			-- Esta es la clave para el "parpadeo":
			level = vim.log.levels.INFO, -- Solo muestra Info, Warn, Error (ignora Debug)
		},
		styles = {
			notification = {
				wo = {
					winblend = 10, -- Transparencia (0 a 100). 10 hace que se vea el fondo sutilmente.
					wrap = true, -- Por si el mensaje de LSP es muy largo
					-- border = "rounded", -- Combina con tu explorador redondeado
					-- zindex = 100,
				},
			},
			explorer = {
				width = 35,
				edge = "left",
				title = function()
					return "   " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":~") .. " "
				end,
				title_pos = "center",
				win = { border = "rounded", wo = { winbar = "" } },
				sections = { { section = "tree" } },
			},
		},
	},
	config = function(_, opts)
		require("snacks").setup(opts)

		-- Autocomando para reabrir dashboard al cerrar todos los buffers
		vim.api.nvim_create_autocmd("BufDelete", {
			callback = function()
				vim.schedule(function()
					local valid_bufs = vim.tbl_filter(function(b)
						return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
					end, vim.api.nvim_list_bufs())

					if #valid_bufs == 0 and vim.bo.filetype ~= "snacks_dashboard" then
						require("snacks").dashboard.open()
					end
				end)
			end,
		})

		-- Mapeos
		vim.keymap.set("n", "<C-t>", function()
			Snacks.explorer()
		end, { desc = "Explorador" })
		vim.keymap.set("n", "<leader>lg", function()
			Snacks.lazygit()
		end, { desc = "Lazygit" })
		vim.keymap.set("n", "<leader>aa", function()
			Snacks.dashboard.open()
		end, { desc = "Dashboard" })
	end,
}
