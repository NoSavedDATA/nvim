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


-- Keymaps
local map = vim.keymap.set
map('n', '<C-/>', 'gc')
map('n', '<Tab>', ':bnext<CR>')
map('n', '<S-Tab>', ':bprevious<CR>')
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', '[u', '?^\\S<CR>')
map('n', ']u', '/^\\S<CR>')
map('n', '<C-s>', ':wqa<CR>')
map('n', '<C-c>', '"+yy<CR>')
map('v', '<C-c>', '"+y<CR>')
map('v', '<C-c>', '"+y<CR>')
map('n', '<Delete>', '"_dd')
map('n', 'x', '"_x')




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
        vim.cmd('enew')
        vim.cmd('vertical resize 110')
        vim.cmd('wincmd l')
    end
})


vim.o.hlsearch = false

-- Swap upper-case markers --
local function swap_char(cmd)
  local c = vim.fn.nr2char(vim.fn.getchar())
  if c:match("%l") then
    c = c:upper()
  elseif c:match("%u") then
    c = c:lower()
  end
  return cmd .. c
end

local function swap_mark() return swap_char('m') end
local function swap_jump() return swap_char("'") end
local function swap_backtick() return swap_char('`') end

vim.keymap.set('n', 'm', swap_mark, { expr = true, noremap = true })
vim.keymap.set('n', "'", swap_jump, { expr = true, noremap = true })
vim.keymap.set('n', '`', swap_backtick, { expr = true, noremap = true })
--




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



local lsp = require("lspconfig")

lsp.pyright.setup({})
