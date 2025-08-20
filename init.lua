vim.opt.shell = "bash"
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

vim.o.tabstop = 4
vim.o.softtabstop = -1
vim.o.shiftwidth = 0
vim.o.shiftround = true
vim.o.expandtab = true

require("guess-indent").setup {}

vim.api.nvim_create_user_command("Vh", "vert help <args>", { nargs = "*" })
require("conform").setup {
  formatters_by_ft = {
    c = { "clang-format" },
    cpp = { "clang-format" },
    ts = { "prettierd", "prettier", stop_after_first = true },
    js = { "prettierd", "prettier", stop_after_first = true },
    rust = { "rustfmt" },
  },
  format_after_save = {
    lsp_format = "fallback",
    async = true,
  },
}
require("render-markdown").setup {
  completions = { lsp = { enabled = true } },
}
require("treesitter-context").setup()

require("auto-session").setup {}
