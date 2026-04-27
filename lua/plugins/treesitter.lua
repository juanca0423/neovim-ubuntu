return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		-- event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup({
				parser_install_dir = vim.fn.stdpath("data") .. "/site",
				ensure_installed = {
					"go",
					"lua",
					"sql",
					"html",
					"javascript",
					"typescript",
					"markdown",
					"markdown_inline",
					"css",
					"handlebars",
					"powershell",
				},
				highlight = {
					enable = true,
					disable = function(_, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
				},
				indent = { enable = true },
				additional_vim_regex_highlighting = false,
				-- Esto es clave para que no intente usar el tree-sitter-cli de Windows
				sync_install = false,
				auto_install = true,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPost",
		opts = { max_lines = 3 },
	},
}
