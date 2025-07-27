-- Base configs
vim.opt.number = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.tabstop = 2       -- A tab character is 2 spaces wide
vim.opt.shiftwidth = 2    -- Indent amount when using >>, <<, ==
vim.opt.softtabstop = 2   -- How many spaces a <Tab> feels like when editing
vim.opt.expandtab = true 

-- Auto-install packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

ensure_packer()

-- Packer startup function
require('packer').startup(function(use)
  -- Let Packer manage itself
  use 'wbthomason/packer.nvim'

  -- Plugins
	-- defaults
	use 'nvim-telescope/telescope.nvim'
  use 'nvim-lua/plenary.nvim'
	use 'neovim/nvim-lspconfig'
  use 'akinsho/toggleterm.nvim'
  use 'glepnir/dashboard-nvim'
	use 'numToStr/Comment.nvim'
	
	--use 'hrsh7th/nvim-cmp'
  --use 'L3MON4D3/LuaSnip'

	use 'folke/which-key.nvim'
  use 'echasnovski/mini.icons'
	use 'nvim-tree/nvim-web-devicons'
				


  -- Colorscheme
  use 'catppuccin/nvim'
  use 'morhetz/gruvbox'
  use 'uZer/pywal16.nvim'
end)

-- Config
require('config.keymaps')
require('config.theme')

-- Plugins
require('plugins.lspconfig')
require('toggleterm').setup{}
require('plugins.dashboard')


