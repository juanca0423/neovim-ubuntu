return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- Tu favorito
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
      term_colors = true,
      transparent_background = false,
      custom_highlights = function(colors)
        return {
          CursorLineNr = { fg = colors.peach, bold = true },
          LineNr = { fg = colors.yellow },
          FoldColumn = { fg = colors.blue, bold = true },
          SignColumn = { bg = "none" },

          -- ✅ Estética para el Dashboard de Snacks
          SnacksDashboardKey = { fg = colors.red, bold = true },
          SnacksDashboardDesc = { fg = colors.subtext1 },
          SnacksDashboardHeader = { fg = colors.blue },
          SnacksDashboardFooter = { fg = colors.yellow },

          -- Colores personalizados para tus botones de desarrollo
          DashboardC = { fg = colors.sky },
          DashboardG = { fg = colors.green },
          DashboardY = { fg = colors.yellow },
          DashboardP = { fg = colors.mauve },
          DashboardO = { fg = colors.peach },
          DashboardB = { fg = colors.blue },
          DashboardR = { fg = colors.red },
        }
      end,
      integrations = {
        snacks = true,
        bufferline = true,
        nvimtree = true,
        treesitter = true,
        telescope = { enabled = true },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        render_markdown = true,
      },
    })

    vim.cmd.colorscheme("catppuccin")
  end,
}
