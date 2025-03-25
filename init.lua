vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

require("overseer").setup()
require("cmake-tools").setup {}
require("lspconfig").clangd.setup {
  on_new_config = function(new_config, _)
    local status, cmake = pcall(require, "cmake-tools")
    if status then
      cmake.clangd_on_new_config(new_config)
    end
  end,
}
require("conform").setup {
  formatters_by_ft = {
    c = { "clang-format" },
    cpp = { "clang-format" },
    ts = { "prettierd", "prettier", stop_after_first = true },
    js = { "prettierd", "prettier", stop_after_first = true },
  },
  format_after_save = {
    lsp_format = "fallback",
    async = true,
  },
}
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { noremap = true })
vim.keymap.set("n", "<A-b>", "<cmd> CMakeBuild <cr>", { desc = "Run CMake build" })
