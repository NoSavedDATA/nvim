return {
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		dependecies = { 'nvim-lua/plenary.nvim',
				  {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'}
				},
		config = function()
				vim.keymap.set("n", "<C-p>", function()
				  require("telescope.builtin").find_files({
					find_command = {
					  "fd",
					  "--type", "f",
					  "--no-ignore",
					  "--hidden",
					  "--follow",
					  "--ignore-file", ".vimignore",
					},
				  })
				end)

				vim.keymap.set("n", "<C-n>", function()
				  require("telescope.builtin").find_files({
					find_command = {
					  "fd",
					  "--type", "f",
					  "--no-ignore",
					  "--hidden",
					  "--follow",
					  "--ignore-file", ".vimignore",
					  "--glob", "*.nv"
					},
				  })
				end)


				vim.keymap.set("n", "<space>e", function()
				  require('telescope.builtin').find_files({
					find_command = {
					  "rg",
					  "--files",
					  "--hidden",
					  "--no-ignore",
					},
					file_ignore_patterns = {
							"%.d",
							"%.o"
					}
				  })
				end)

				vim.keymap.set("n", "<space>i", function()
						require('telescope.builtin').find_files {
								cwd = vim.fn.expand("~/.config/nvim")
						}
				end)







				local builtin = require("telescope.builtin")
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")

				local last_query = ""

				vim.keymap.set("n", "<C-l>", function()
					builtin.live_grep({
						default_text = last_query,

						attach_mappings = function(prompt_bufnr, map)
							local function save()
								last_query = action_state.get_current_line()
							end

							actions.select_default:enhance({ post = save })
							actions.close:enhance({ pre = save })

							return true
						end,

						layout_strategy = "vertical",
						layout_config = {
							preview_cutoff = 0,
							preview_height = 0.6,
							prompt_position = "top",
						},
					})
				end)



vim.keymap.set("v", "<C-l>", function()
	local text = table.concat(vim.fn.getregion(
		vim.fn.getpos("v"),
		vim.fn.getpos(".")
	), "\n")

	require("telescope.builtin").grep_string({
		search = text,
		layout_strategy = "vertical",
		layout_config = {
			preview_cutoff = 0,
			preview_height = 0.6,
			prompt_position = "top",
		},
	})
end, { desc = "Grep selection" })






				local function open_float_file(file, lnum)
					local buf = vim.fn.bufadd(file)
					vim.fn.bufload(buf)

					local height = math.floor(vim.o.lines * 0.8)
					local width = vim.o.columns

					local win = vim.api.nvim_open_win(buf, true, {
						relative = "editor",
						row = 8,
						col = 0,
						width = width,
						height = height,
						border = "rounded",
					})


					vim.wo[win].number = true
					vim.wo[win].relativenumber = true
					vim.wo[win].cursorline = true
					vim.api.nvim_win_set_cursor(win, { lnum, 0 })
				    vim.api.nvim_win_set_option(win, "scrolloff", 0)
				    vim.fn.win_execute(win, ("call winrestview({'topline': %d})"):format(math.max(1, lnum - 3))) 
				    vim.fn.win_execute(win, "normal! 3j")
				end


				vim.keymap.set("n", "<C-3>", function()
						local fn = vim.fn.expand("<cword>")
						local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

						local cmd = string.format(
							[[rg -P --glob '*.cpp' --glob '*.py' --glob '*.nv' -n '\b%s\s*\(' %s]],
							fn,
							vim.fn.shellescape(root)
						)

						local result = vim.fn.systemlist(cmd)

						for _, match in ipairs(result) do
							local file, line, text = match:match("^([^:]+):(%d+):(.*)$")

							if file:match("%.cpp$") then
								-- Function definition
								if text:match("%b()") and not text:match(";%s*$") then
									open_float_file(file, tonumber(line))
									return
								end


							elseif file:match("%.py$") then
								if text:match("^%s*def%s+" .. fn .. "%s*%(") or
								   text:match("^%s*class%s+" .. fn .. "%f[%W]") then
									open_float_file(file, tonumber(line))
									return
								end

							elseif file:match("%.neve$") then
								if text:match("^%s*def%s+.+%s+" .. fn .. "%s*%(") or
								   text:match("^%s*class%s+" .. fn .. "%f[%W]") then
									open_float_file(file, tonumber(line))
									return
								end
							end
						end

						if #result == 0 then
								vim.notify("No definition found.")
								return
						end

						local file, line = result[1]:match("^([^:]+):(%d+):")
						open_float_file(file, tonumber(line))
				end)


				vim.keymap.set("n", "<C-4>", function()
	local symbol = vim.fn.expand("<cword>")
	local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

	local cmd = string.format(
		[[rg -n --glob '*.h' --glob '*.hpp' '%s' %s]],
		symbol,
		vim.fn.shellescape(root)
	)

	local result = vim.fn.systemlist(cmd)

	for _, match in ipairs(result) do
		local file, line, text = match:match("^([^:]+):(%d+):(.*)$")

		if text:match("^%s*class%s+" .. symbol .. "%f[%W]") or
		   text:match("^%s*struct%s+" .. symbol .. "%f[%W]") or
		   text:match(symbol .. "%s*%b()%s*;") then
			open_float_file(file, tonumber(line))
			return
		end
	end

	if #result == 0 then
		vim.notify("No declaration found.")
		return
	end

	-- Fallback: open the first occurrence.
	local file, line = result[1]:match("^([^:]+):(%d+):")
	open_float_file(file, tonumber(line))
end)

		end
}
