---@diagnostic disable: undefined-global

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    -- En Linux el separador siempre es ":"
    local separator = ":"

    -- Corrección de PATH dinámica para Mason
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
    vim.env.PATH = mason_bin .. separator .. vim.env.PATH

    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "gopls", "lua_ls", "ts_ls", "html", "sqls" },
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.offsetEncoding = { "utf-16" }

    local servers = { "lua_ls", "gopls", "ts_ls", "html", "cssls", "sqls" }

    for _, server in ipairs(servers) do
      local opts = { capabilities = capabilities }

      -- Ajustes de Go (Tu motor principal para EEFF)
      if server == "gopls" then
        opts.settings = {
          gopls = {
            completeUnimported = true,
            gofumpt = true,
            analyses = { unusedparams = true, shadow = true },
            staticcheck = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              parameterNames = true,
            },
            ["ui.completion.usePlaceholders"] = true,
            ["ui.diagnostic.staticcheck"] = true,
          },
        }
      elseif server == "sqls" then
        opts.settings = {
          sqls = {
            connections = {
              {
                driver = "postgresql",
                dataSourceName = string.format(
                  "host=127.0.0.1 port=5432 user=juanca password=%s dbname=eeff",
                  os.getenv("DB_PASS") or ""
                ),
              },
            },
          },
        }
      elseif server == "lua_ls" then
        opts.settings = {
          Lua = {
            diagnostics = {
              globals = { "vim", "Snacks" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
            hint = { enable = true },
          },
        }
      elseif server == "cssls" then
        opts.settings = { css = { validate = true, lint = { unknownAtRules = "ignore" } } }
      end

      require("lspconfig")[server].setup(opts)
    end

    -- CONFIGURACIÓN MODERNA DE DIAGNÓSTICOS (Sin warnings)
    local icons = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }

    vim.diagnostic.config({
      virtual_text = { prefix = "●", spacing = 4 },
      -- Definimos los iconos aquí para evitar el error de 'deprecated'
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
        focused = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end,
}
