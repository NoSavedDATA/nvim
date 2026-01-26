return {
  "bfrg/vim-c-cpp-modern",
  ft = { "c", "cpp" },
  init = function()
    vim.g.cpp_member_highlight = 1
	vim.g.cpp_builtin_types_as_statement = 1
	vim.g.cpp_simple_highlight = 1
	vim.g.cpp_operator_highlight = 1
  end,
}

