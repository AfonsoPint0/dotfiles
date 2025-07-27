vim.g.mapleader = " "

local wk = require("which-key")
wk.add({
  { "<leader>f", group = "file" },
  { "<leader>t", group = "tabs" },
	{ "<leader>s", group = "scripts" }
})

-- Tabs
vim.keymap.set('n', '<Leader>tn', ':tabnew<CR>',   { silent = true, desc = 'New Tab' })
vim.keymap.set('n', '<Leader>tc', ':tabclose<CR>', { silent = true, desc = 'Close Tab' })
vim.keymap.set('n', '<Leader>to', ':tabonly<CR>',  { silent = true, desc = 'Close Other Tabs' })
vim.keymap.set('n', '<Leader>tl', ':tabnext<CR>',  { silent = true, desc = 'Next Tab' })
vim.keymap.set('n', '<Leader>th', ':tabprev<CR>',  { silent = true, desc = 'Previous Tab' })

-- Theme
local theme = require("config.theme")
vim.keymap.set("n", "<leader>st", theme.toggle_theme, { desc = "Toggle Theme" })
vim.keymap.set("n", "<leader>ss", theme.apply, { desc = "Sync theme" })

-- Telescope
local telescope = require('telescope.builtin')
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Commands" })
vim.keymap.set("n", "<leader>ft", "<cmd>Telescope treesitter<cr>", { desc = "Treesitter Symbols" })
vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })
vim.keymap.set('n', '<leader>fF', function()
  require('telescope.builtin').find_files({ cwd = vim.env.HOME })
end, { desc = "Find Files in Home" })

-- Terminal
vim.keymap.set('n', '<leader>th', ':ToggleTerm<CR>', { desc = "Toggle horizontal terminal" })
vim.api.nvim_set_keymap('n', '<leader>tv', ':ToggleTerm direction=vertical<CR>', { noremap = true, silent = true, desc = "Toggle vertical terminal" })
