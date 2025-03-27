require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("t", "<ESC>", "<C-\\><C-n>", { noremap = true })
map("n", "<leader>flr", "<cmd>Telescope lsp_references<cr>", { desc = "Telescope Find references" })
map("n", "<leader>fli", "<cmd>Telescope lsp_incoming_calls<cr>", { desc = "Telescope Find incoming calls" })
map("n", "<leader>flo", "<cmd>Telescope lsp_outgoing_calls<cr>", { desc = "Telescope Find outgoing calls" })
map("n", "<leader>flm", "<cmd>Telescope lsp_implementations<cr>", { desc = "Telescope Find implementations" })
map("n", "<leader>fld", "<cmd>Telescope lsp_definitions<cr>", { desc = "Telescope Find definitions" })
map("n", "<leader>tt", "<cmd> Telescope treesitter<cr>", { desc = "Telescope Treesitter" })
map("n", "<leader>td", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble Diagnostics" })
map("n", "<leader><Space>", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "cmp Show function documentation" })

map("n", "<A-b>", function()
  require("nvchad.term").runner {
    pos = "float",
    id = "cmake-build",
    cmd = function()
      local valid_types = { "c", "cpp", "cmake" }

      if valid_types[vim.bo.ft] then
        local dir = vim.fn.getcwd()
        return "cmake --build " .. dir .. "/build --config Release"
      end
    end,
  }
end, { desc = "CMake build" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
