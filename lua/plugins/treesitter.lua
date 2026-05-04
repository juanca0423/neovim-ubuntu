return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
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
				-- "powershell",
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
			sync_install = false,
			auto_install = true,
		},
		config = function(_, opts)
			opts.parser_install_dir = vim.fn.stdpath("data") .. "/site"
			vim.opt.compilers = { "gcc", "g++" }
			vim.opt.runtimepath:append(opts.parser_install_dir)
			local config = require("nvim-treesitter.configs")
			config.setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPost",
		opts = { max_lines = 3 },
	},
}
