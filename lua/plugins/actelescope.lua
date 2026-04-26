return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        preview = {
          treesitter = true,
        },
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            preview_width = 0.55,
            prompt_position = "top",
          },
        },
        file_ignore_patterns = {
          "node_modules",
          "vendor",
          "%.exe",
          "%.dll",
          "%.git/",
          "target/",
          "bin/",
          "obj/",
        },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    })

    -- Carga segura de extensiones
    pcall(telescope.load_extension, "fzf")
    -- pcall(telescope.load_extension, "yank_history")
    pcall(telescope.load_extension, "ui-select")
  end,
}
