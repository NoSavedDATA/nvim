-- Basic settings
vim.o.rnu = true
vim.o.tabstop = 4
vim.o.autoindent = true


-- C-like indentation
grp = vim.api.nvim_create_augroup("c_like_indent", { clear = true })
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    group = grp,
    pattern = {"*.c", "*.h", "*.cpp", "*.cu", ".cuh"},
    callback = function()
        vim.bo.cindent = true	
		vim.bo.shiftwidth = 4
		vim.bo.tabstop = 4
		vim.bo.softtabstop = 4
		vim.bo.expandtab = true
    end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.cu", "*.cuh" },
  callback = function()
    vim.bo.filetype = "cpp"
  end,
})



require("config.lazy")


-- Keymaps
local map = vim.keymap.set
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
map("n", "<C-;>", "gcc", { remap = true })
map('n', '<Delete>', '"_dd')
map('n', 'x', '"_x')




-- Insert mode: auto braces
vim.cmd [[inoremap { {<CR>}<up><end><CR>]]

-- Session on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function() vim.cmd('mksession! ~/.vim_session') end
})

vim.o.hlsearch = false



-- Swap upper-case markers --
local mark_file = vim.fn.stdpath("data") .. "/my_global_marks.json"
local MyMarks = {}

local function load_marks()
  local f = io.open(mark_file, "r")
  if not f then return end
  local data = f:read("*a")
  f:close()
  local ok, decoded = pcall(vim.json.decode, data)
  if ok and type(decoded) == "table" then
    MyMarks = decoded
  end
end
load_marks()

local function save_marks()
  local f = io.open(mark_file, "w")
  if not f then return end
  f:write(vim.json.encode(MyMarks))
  f:close()
end


local function set_global_mark()
  local c = vim.fn.nr2char(vim.fn.getchar())
  if not c:match("%a") then return end

  local pos = vim.api.nvim_win_get_cursor(0)

  MyMarks[c] = {
    file = vim.api.nvim_buf_get_name(0),
    lnum = pos[1],
    col  = pos[2],
  }
  save_marks()
end

local function jump_global_mark()
  local c = vim.fn.nr2char(vim.fn.getchar())
  local m = MyMarks[c]
  if not m or m.file == "" then return end

  vim.schedule(function()
    vim.cmd("edit " .. vim.fn.fnameescape(m.file))
    vim.api.nvim_win_set_cursor(0, {m.lnum, m.col})
  end)
end

vim.keymap.set('n', 'm', set_global_mark, { noremap = true })
vim.keymap.set('n', "'", jump_global_mark, { noremap = true })
vim.keymap.set('n', '`', jump_global_mark, { noremap = true })
vim.keymap.set('n', '~', jump_global_mark, { noremap = true })
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



