require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("t", "<ESC>", "<C-\\><C-n>", { noremap = true })
map("n", "<A-b>", "<cmd> CMakeBuild <cr>", { desc = "CMake Build" })
map("n", "<leader>flr", "<cmd>Telescope builtin.lsp_references<cr>", { desc = "Telescope Find references" })
map("n", "<leader>fli", "<cmd>Telescope builtin.lsp_incoming_calls<cr>", { desc = "Telescope Find incoming calls" })
map("n", "<leader>flo", "<cmd>Telescope builtin.lsp_outgoing_calls<cr>", { desc = "Telescope Find outgoing calls" })
map("n", "<leader>flm", "<cmd>Telescope builtin.lsp_implementations<cr>", { desc = "Telescope Find implementations" })
map("n", "<leader>fld", "<cmd>Telescope builtin.lsp_definitions<cr>", { desc = "Telescope Find definitions" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
