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

vim.o.tabstop = 4
vim.o.softtabstop = -1
vim.o.shiftwidth = 0
vim.o.shiftround = true
vim.o.expandtab = true

require("guess-indent").setup {}

require("transparent").setup {
  extra_groups = {
    -- "NormalFloat",
  },
}
require("transparent").clear_prefix "NvimTree"

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

require("auto-session").setup {
  post_restore_cmds = {
    function()
      local nvim_tree = require "nvim-tree.api"
      nvim_tree.tree.open()
      nvim_tree.tree.change_root(vim.fn.getcwd())
      nvim_tree.tree.reload()
      vim.api.nvim_set_current_buf(2)
    end,
  },
}
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local tree_wins = {}
    local floating_wins = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match "NvimTree_" ~= nil then
        table.insert(tree_wins, w)
      end
      if vim.api.nvim_win_get_config(w).relative ~= "" then
        table.insert(floating_wins, w)
      end
    end
    if 1 == #wins - #floating_wins - #tree_wins then
      -- Should quit, so we close all invalid windows.
      for _, w in ipairs(tree_wins) do
        vim.api.nvim_win_close(w, true)
      end
    end
  end,
})
