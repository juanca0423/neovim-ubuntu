-- =============================================================================
-- FUNCIONES DE APOYO
-- =============================================================================
local function docker_ui(cmd)
	-- Usamos pcall para evitar que el LSP grite si toggleterm no ha cargado
	local ok, terminal = pcall(require, "toggleterm.terminal")
	if ok then
		terminal.Terminal
			:new({
				cmd = cmd,
				direction = "float",
				close_on_exit = false,
			})
			:toggle()
	else
		print("🚀 Error: ToggleTerm no está instalado")
	end
end

local function toggle_maximize()
	if vim.t.maximized then
		vim.cmd("wincmd =")
		vim.t.maximized = false
		print("📏 Ventanas restauradas")
	else
		vim.cmd("vertical resize | resize")
		vim.t.maximized = true
		print("🔍 Ventana maximizada")
	end
end

-- ASIGNAR AL TECLADO (Esto quita el aviso de "Unused")
vim.keymap.set("n", "<leader>m", toggle_maximize, { desc = "Maximizar/Restaurar ventana" })
-- =============================================================================
-- NAVEGACIÓN Y ARCHIVOS
-- =============================================================================
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Guardar" })
vim.keymap.set("n", "<leader>q", "<cmd>bd<cr>", { desc = "Cerrar Buffer" })

-- Limpieza de Buffers (Optimizado para Linux)
vim.keymap.set("n", "<leader>ba", function()
	local current = vim.api.nvim_get_current_buf()
	local count = 0
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if bufnr ~= current and vim.api.nvim_buf_is_loaded(bufnr) then
			if pcall(vim.api.nvim_buf_delete, bufnr, { force = false }) then
				count = count + 1
			end
		end
	end
	print("🧹 Buffers limpios: " .. count)
end, { desc = "Limpiar otros buffers" })

-- Copiar ruta (En Linux usamos el registro + que conecta con el portapapeles del sistema)
vim.keymap.set("n", "<leader>cp", '<cmd>let @+ = expand("%:p")<cr>', { desc = "Copiar ruta completa" })

-- Abrir Localhost (CORREGIDO PARA LINUX/WSL)
-- WSL necesita usar 'explorer.exe' para abrir el navegador de Windows
vim.keymap.set("n", "<leader>wb", function()
	os.execute("explorer.exe http://localhost:8080")
end, { desc = "Abrir Localhost en Windows" })

-- =============================================================================
-- LSP Y PROGRAMACIÓN
-- =============================================================================
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Ir a Definición" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Ver Referencias" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Info Hover" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Renombrar" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Acciones" })

-- Snippets (Salto con J y K)
vim.keymap.set({ "i", "s" }, "<C-k>", function()
	local ls = require("luasnip")
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end)
vim.keymap.set({ "i", "s" }, "<C-j>", function()
	local ls = require("luasnip")
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end)

-- Diagnósticos
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1 })
end, { desc = "Siguiente Error" })
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1 })
end, { desc = "Error Anterior" })

-- =============================================================================
-- DOCKER Y SQL
-- =============================================================================
vim.keymap.set("n", "<leader>dps", function()
	docker_ui("docker ps")
end, { desc = "Docker Status" })
vim.keymap.set("n", "<leader>dk", function()
	docker_ui("docker restart go_web_app")
end, { desc = "Restart App" })
vim.keymap.set("n", "<leader>gg", "<cmd>term lazygit<CR>", { desc = "Lazygit" })

-- =============================================================================
-- TERMINAL (Fix para Linux)
-- =============================================================================
vim.keymap.set("n", "<leader>te", "<cmd>split | terminal<CR>i", { desc = "Terminal" })
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Escape Terminal" })

-- =============================================================================
-- VENTANAS Y NAVEGACIÓN
-- =============================================================================
vim.keymap.set("n", "<C-Left>", "<C-w>h")
vim.keymap.set("n", "<C-Down>", "<C-w>j")
vim.keymap.set("n", "<C-Up>", "<C-w>k")
vim.keymap.set("n", "<C-Right>", "<C-w>l")

-- =============================================================================
-- TELESCOPE & SNACKS
-- ============================================================================
local tb = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", tb.find_files, { desc = "Buscar Archivos" })
vim.keymap.set("n", "<leader>fg", tb.live_grep, { desc = "Buscar Texto" })

-- Snacks (Uso seguro para evitar errores de LSP)
vim.keymap.set("n", "<leader>fp", function()
	---@diagnostic disable-next-line: undefined-field
	local Snacks = _G.Snacks
	if Snacks and Snacks.picker then
		Snacks.picker.projects()
	end
end, { desc = "Proyectos Recientes" })
-- =============================================================================
-- AYUDA FLOTANTE (REESCRITA PARA LINUX)
-- =============================================================================
local function open_floating_help()
	local word = vim.fn.expand("<cword>")

	if vim.bo.filetype == "go" then
		vim.cmd("split | term go doc " .. word)
	elseif vim.bo.filetype == "sql" then
		print("¿Buscar '" .. word .. "' en la Web? (s/n)")
		if vim.fn.getcharstr() == "s" then
			local url = "https://www.google.com/search?q=postgresql+sql+" .. word
			os.execute("explorer.exe '" .. url .. "'") -- Comando mágico para WSL
		end
	else
		vim.cmd("help " .. word)
	end
end

vim.keymap.set("n", "<leader>he", open_floating_help, { desc = "Ayuda Flotante" })

-- 1. SALTAR BLOQUES {{#...}} o {{/...}} (Ideales para templates)
vim.keymap.set("n", "]]", [[/<%{{[#/].*}}%>?.*<CR>:noh<CR>]], { desc = "Siguiente bloque template", silent = true })
vim.keymap.set("n", "[[", [[?<%{{[#/].*}}%>?.*<CR>:noh<CR>]], { desc = "Bloque template anterior", silent = true })

-- 2. SALTAR A SIGUIENTE FUNCIÓN (Optimizado para Go, JS y TS)
vim.keymap.set(
	"n",
	"gf",
	[[/\v^\s*(func|function|const.* \=\>|async\s+function)<CR>:noh<CR>]],
	{ desc = "Siguiente Función", silent = true }
)

-- 3. SALTAR A FUNCIÓN ANTERIOR
vim.keymap.set(
	"n",
	"ga",
	[[?\v^\s*(func|function|const.* \=\>|async\s+function)<CR>:noh<CR>]],
	{ desc = "Función Anterior", silent = true }
)
