return {
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		dependecies = { 'nvim-lua/plenary.nvim',
				  {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'}
				},
		config = function()
				vim.keymap.set("n", "<C-p>", function()
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

		end
}
