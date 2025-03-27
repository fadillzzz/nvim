if vim.fn.has "macunix" == 0 then
  vim.opt.shell = "pwsh"
end
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
require("nvim-tree").setup {
  live_filter = {
    always_show_folders = false,
  },
  git = {
    ignore = false,
  },
  filters = {
    custom = {
      "^.git$",
    },
  },
  view = {
    width = {
      min = 30,
      max = 60,
    },
  },
}
vim.api.nvim_create_user_command("Vh", "vert help <args>", { nargs = "*" })
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
require("render-markdown").setup {
  completions = { lsp = { enabled = true } },
}
require("treesitter-context").setup()

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
end)

require("ibl").setup { scope = { highlight = { "RainbowRed" } } }
require("auto-session").setup {
  auto_restore_last_session = vim.loop.cwd() == vim.loop.os_homedir(),
  post_restore_cmds = {
    function()
      local nvim_tree = require "nvim-tree.api"
      nvim_tree.tree.open()
      nvim_tree.tree.change_root(vim.fn.getcwd())
      nvim_tree.tree.reload()
    end,
  },
}
