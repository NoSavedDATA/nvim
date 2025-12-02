-- Basic settings
vim.o.rnu = true
vim.o.tabstop = 4
vim.o.autoindent = true

-- C-like indentation
grp = vim.api.nvim_create_augroup("c_like_indent", { clear = true })
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    group = grp,
    pattern = {"*.c", "*.h", "*.cpp", "*.cu"},
    callback = function()
        vim.bo.cindent = true
    end,
})

require("config.lazy")


-- Plugins (vim-plug equivalent)
-- vim.cmd [[
-- call plug#begin('~/.vim/plugged')

-- Plug 'junegunn/fzf'
-- Plug 'junegunn/fzf.vim'
-- Plug 'ayu-theme/ayu-vim'
-- Plug 'RRethy/vim-illuminate'
-- Plug 'jiangmiao/auto-pairs'
-- Plug 'tpope/vim-commentary'
-- Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
-- Plug 'NoSavedDATA/vim-nsk'
-- Plug 'NoSavedDATA/vim-nsk-dark'

-- call plug#end()
-- ]]


-- Keymaps
local map = vim.keymap.set
map('n', '<C-/>', 'gc')
map('n', '<C-p>', ':Telescope find_files<CR>')
-- map('n', '<C-o>', ':Files ../<CR>')
map('n', '<Tab>', ':bnext<CR>')
map('n', '<S-Tab>', ':bprevious<CR>')
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', '[u', '?^\\S<CR>')
map('n', ']u', '/^\\S<CR>')
map('n', '<C-s>', ':wqa<CR>')

-- Insert mode: auto braces
vim.cmd [[inoremap { {<CR>}<up><end><CR>]]

-- Session on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function() vim.cmd('mksession! ~/.vim_session') end
})

-- Startup layout
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.cmd('vs')
        vim.cmd('vertical resize 110')
        vim.cmd('wincmd l')
    end
})


-- Session options
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,options,tabpages,winsize'

-- Colorscheme
vim.cmd('colorscheme ghdark')

-- Transparency toggle
vim.g.t_is_transparent = 0
function Toggle_transparent()
    if vim.g.t_is_transparent == 0 then
        vim.cmd('hi Normal guibg=NONE ctermbg=NONE')
        vim.g.t_is_transparent = 1
    else
        vim.cmd('set background=dark')
        vim.g.t_is_transparent = 0
    end
end
map('n', '<C-t>', Toggle_transparent)

-- Transparent by default
grp2 = vim.api.nvim_create_augroup("TransparentBG", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
    group = grp2,
    callback = function()
        vim.cmd('hi Normal guibg=NONE ctermbg=NONE')
    end,
})


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


