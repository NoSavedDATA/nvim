return {
		'voldikss/vim-floaterm',
		config = function()
				local map = vim.keymap.set
				map('n', 'K', function()	
						  local buf = vim.api.nvim_get_current_buf()
  local line = vim.fn.line('.')

  local height = math.floor(vim.o.lines * 0.5)
  local width = vim.o.columns

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = vim.o.lines - height - 2,
    col = 0,
    width = width,
    height = height,
    border = "rounded",
  })

  -- restore cursor
  vim.api.nvim_win_set_cursor(win, { line, 0 })

  -- window-local options
  vim.wo[win].number = true
  vim.wo[win].relativenumber = true
  vim.wo[win].cursorline = true
				end)
		end
}
