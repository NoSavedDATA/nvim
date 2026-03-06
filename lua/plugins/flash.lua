return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    modes = {
      char = {
        enabled = false,  -- disables f/F/t/T overrides
      },
    },
  },
  keys = {
    { "<BS>", mode = { "n", "x" }, function() require("flash").jump() end, desc = "Flash" },
	{
		  "<BS>",
		  mode = { "o" },
		  function()
			require("flash").jump({
			  jump = {
				pos = "start", -- jump to beginning of match
			  },
			})
			-- move back one char to emulate `t`
			vim.cmd("normal! h")
		  end,
		  desc = "Flash (dt-like)",
		},
    { "|", mode = { "n", "x" }, function() require("flash").jump() end, desc = "Flash" },
    { "=", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "zk", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "Zk", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    -- { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    -- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    -- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}
