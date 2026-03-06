return {
		'voldikss/vim-floaterm',
		config = function()
				local map = vim.keymap.set
				map('n', 'J', function()	
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
				local last_float_buf = nil
				local float_win = nil

				map('n', 'K', function()
				  local current = vim.api.nvim_get_current_buf()

				  local target
				  if last_float_buf
					 and vim.api.nvim_buf_is_valid(last_float_buf)
					 and vim.api.nvim_buf_is_loaded(last_float_buf)
				  then
					target = last_float_buf
				  else
					target = current
				  end

				  local height = math.floor(vim.o.lines * 0.5)
				  local width = vim.o.columns

				  float_win = vim.api.nvim_open_win(target, true, {
					relative = "editor",
					row = vim.o.lines - height - 2,
					col = 0,
					width = width,
					height = height,
					border = "rounded",
				  })

				  -- track buffer changes inside THIS floating window only
				  vim.api.nvim_create_autocmd("BufEnter", {
					callback = function(args)
					  if float_win and vim.api.nvim_win_is_valid(float_win) then
						local win = vim.api.nvim_get_current_win()
						if win == float_win then
						  last_float_buf = args.buf
						end
					  end
					end,
				  })

				  -- initialize
				  last_float_buf = target

				  vim.wo[float_win].number = true
				  vim.wo[float_win].relativenumber = true
				  vim.wo[float_win].cursorline = true
				end)

		end
}
