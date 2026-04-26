return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			go = { "gofumpt" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			handlebars = { "prettier" },
			["handlebars.html"] = { "prettier" },
			css = { "prettier" },
			ps1 = { "powershell_editor_services" },
		},
		formatters = {
			prettier = {
				args = {
					"--stdin-filepath",
					"$FILENAME",
					"--parser",
					"html",
					"--print-width",
					"120", -- Cámbialo a 100 o 120 según prefieras
					"--tab-width",
					"2",
				},
			},
		},
		format_on_save = {
			timeout_ms = 1000,
			lsp_format = "fallback",
		},
	},
}
