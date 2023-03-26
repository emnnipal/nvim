vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)


vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = 'unnamedplus'

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Appearance
-- vim.opt.termguicolors = true
-- vim.opt.background = "dark"
-- vim.opt.signcolumn = "yes"

-- tabs & indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true


-- KEY MAPPINGS
vim.keymap.set('v', '<D-c>', 'y')

-- paste over highlighted text without copying the overrided text with cmd + v
vim.keymap.set('v', '<D-v>', 'P')

-- apply escape shortcuts in insert mode and command mode
vim.keymap.set({ 'i', 'c' }, 'jk', '<Esc>')
vim.keymap.set({ 'i', 'c' }, 'kj', '<Esc>')

-- apply highlighting shortcuts in all modes and visual mode
vim.keymap.set({ '', 'v' }, 'J', '10j')
vim.keymap.set({ '', 'v' }, 'K', '10k')
vim.keymap.set({ '', 'v' }, 'H', '^')
vim.keymap.set({ '', 'v' }, 'L', '$')

-- commented since we won't be able to use ctrl + r of vscode with this keymap
-- vim.keymap.set('n', 'U', '<D-r>')

-- commented for now since cmd + v or P is working for pasting without copying
-- prevent from copying the overrided text
-- vim.keymap.set('n', 'p', 'pgvy')
-- vim.keymap.set('v', 'p', '"_dP')

vim.keymap.set('v', 'ii', '<Esc>i')
vim.keymap.set('i', 'vv', '<Esc>lv')
vim.keymap.set({ '', 'i' }, '<D-a>', '<Esc>ggVG')


-- [[ Highlight on yank ]] See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

if vim.g.vscode then
  vim.cmd [[
    nnoremap gr <Cmd>call VSCodeCall('editor.action.rename')<CR>
    nnoremap gR <Cmd>call VSCodeCall('editor.action.goToReferences')<CR>
    nnoremap gD <Cmd>call VSCodeCall('editor.action.goToTypeDefinition')<CR>
    nnoremap gb <Cmd>call VSCodeCall('editor.action.addSelectionToNextFindMatch')<CR>
    ]]

  require('lazy').setup({
    'nvim-lua/plenary.nvim',
    { 'kylechui/nvim-surround', opts = {} },
    { 'windwp/nvim-autopairs',  opts = {} },
    {
      'phaazon/hop.nvim',
      config = function()
        local hop = require('hop')
        hop.setup()
        vim.keymap.set('', 'm', function()
          hop.hint_words()
        end, { remap = true })
      end
    },
    -- other nvim plugins
  })

  return
end

-- non-vscode configurations

vim.keymap.set('n', '<leader>w', ':update<CR>')

require('lazy').setup({
  'nvim-lua/plenary.nvim',
  'mg979/vim-visual-multi',
  {
    'loctvl842/monokai-pro.nvim',
    config = function()
      require("monokai-pro").setup({
        filter = "machine"
      })
      vim.cmd.colorscheme("monokai-pro")
    end
  },
  -- 'AndrewRadev/splitjoin.vim',
  { 'kylechui/nvim-surround', opts = {} },
  { 'windwp/nvim-autopairs',  opts = {} },
  {
    'phaazon/hop.nvim',
    config = function()
      local hop = require('hop')
      hop.setup()
      vim.keymap.set('', 'm', function()
        hop.hint_words()
      end, { remap = true })
    end
  },
  --{
  -- highlight, edit, and navigate code
  --  'nvim-treesitter/nvim-treesitter',
  --  dependencies = {
  --    'nvim-treesitter/nvim-treesitter-textobjects',
  --  }
  --},
  -- other nvim plugins
})
