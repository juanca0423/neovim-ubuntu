-- ==========================================================================
-- GRUPOS DE AUTOCOMANDOS
-- ==========================================================================
local function augroup(name)
  return vim.api.nvim_create_augroup("gemini_custom_" .. name, { clear = true })
end

-- 1. ESTÉTICA
vim.cmd("highlight CursorLineNr guifg=#FAB387 gui=bold")
vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#1e1e2e" })

-- 2. COMANDO OpenDocs (Corregido para el sistema de archivos de WSL)
-- En WSL, tu carpeta de Windows está en /mnt/c/...
vim.api.nvim_create_user_command("OpenDocs", function()
  -- Usamos la ruta directa de Linux hacia tu disco C
  local path = "/mnt/c/Users/Usuario/Documents/Desarrollo/DocMd"

  if vim.fn.isdirectory(path) == 0 then
    print("⚠️ Ruta no encontrada en Windows: " .. path)
    return
  end

  require("snacks").picker.files({
    cwd = path,
    title = " 󰈙 Mis Documentos MD ",
    hidden = true,
  })
end, { desc = "Busca tus notas de Windows desde Neovim Linux" })

-- 3. FIX DE SALIDA (EL TRUCO FINAL)
vim.api.nvim_create_autocmd("VimLeave", {
  group = augroup("terminal_exit_fix"),
  callback = function()
    vim.opt.guicursor = "a:ver25"
    -- En Linux NO existe 'cls', se usa 'clear'
    vim.fn.jobstart("clear", { detach = true })
  end,
})

-- 4. HANDLEBARS (HBS) FIX
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("hbs_fix"),
  pattern = "*.hbs",
  callback = function()
    vim.bo.filetype = "handlebars"
    -- Intentamos inyectar el parser de html para tener colores
    pcall(vim.treesitter.start, nil, "html")
  end,
})

-- 5. AUTO-CLOSE NVIM-TREE
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("nvim_tree_close"),
  nested = true,
  callback = function()
    local wins = vim.api.nvim_list_wins()
    if #wins == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
      vim.cmd("quit")
    end
  end,
})

-- 6. LIMPIEZA DE NVIM (ClearNvim)
vim.api.nvim_create_user_command("ClearNvim", function()
  -- Borrar Shada
  local shada_path = vim.fn.stdpath("data") .. "/shada"
  vim.fn.system("rm -rf " .. shada_path .. "/*")

  -- Borrar Logs
  local lsp_log = vim.fn.stdpath("cache") .. "/lsp.log"
  if vim.fn.filereadable(lsp_log) == 1 then
    os.remove(lsp_log)
  end
  print("✨ Neovim Linux Limpio (Shada y Logs)")
end, { desc = "Limpia temporales" })

-- 7. DESARROLLO GO (Organizar Imports al guardar)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("go_magic", { clear = true }),
  pattern = "*.go",
  callback = function(args)
    local bufnr = args.buf

    -- Obtener cliente gopls
    local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "gopls" })
    local client = clients[1]
    if not client then
      return
    end

    -- Parámetros para codeAction
    local params = vim.lsp.util.make_range_params(0, "utf-16")
    ---@diagnostic disable-next-line: inject-field
    params.context = { only = { "source.organizeImports" } }

    -- Petición síncrona MODERNA (client:request_sync reemplaza vim.lsp.buf_request_sync)
    local result, err = client:request_sync("textDocument/codeAction", params, 1000, bufnr)
    if err or not result then
      return
    end

    -- Aplicar acciones (result es el array directo)
    for _, action in ipairs(result) do
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, "utf-16")
      elseif action.command then
        -- API moderna 0.12 para ejecutar comandos
        client:exec_cmd(action.command, { bufnr = bufnr })
      end
    end

    -- Formateo con conform
    require("conform").format({ bufnr = bufnr })
  end,
})

-- 8. INLAY HINTS (v0.11+)
-- Activar Inlay Hints de forma segura
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("lsp_hints"),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.inlayHintProvider then
      pcall(function()
        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
      end)
    end
  end,
})
