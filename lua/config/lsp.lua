-- In your nvim config (init.lua or lua/config/lsp.lua)
local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT", -- LÖVE uses LuaJIT
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        globals = { "love" }, -- Recognize 'love' as global
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          -- Add LÖVE API definitions
          [vim.fn.stdpath("data") .. "/love2d-api"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
