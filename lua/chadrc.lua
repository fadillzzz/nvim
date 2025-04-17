-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

local sep_style = "default"
local utils = require "nvchad.stl.utils"

local sep_icons = utils.separators
local separators = (type(sep_style) == "table" and sep_style) or sep_icons[sep_style]

local sep_r = separators["right"]

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "tokyonight",
  transparency = true,

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

M.ui = {
  statusline = {
    modules = {
      file = function()
        local x = utils.file()

        if x[2] ~= "Empty" then
          x[2] = vim.fn.expand "%:p"
        end

        local name = " " .. x[2] .. (sep_style == "default" and " " or "")
        return "%#St_file# " .. x[1] .. name .. "%#St_file_sep#" .. sep_r
      end,
    },
  },
}

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
--}

return M
