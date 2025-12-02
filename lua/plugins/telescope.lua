return {
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		dependecies = { 'nvim-lua/plenary.nvim',
				  {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'}
				},
		config = function()
				vim.keymap.set("n", "<space>u", require('telescope.builtin').find_files)
				vim.keymap.set("n", "<space>i", function()
						require('telescope.builtin').find_files {
								cwd = vim.fn.stdpath("config")
						}
				end)

		end
}
