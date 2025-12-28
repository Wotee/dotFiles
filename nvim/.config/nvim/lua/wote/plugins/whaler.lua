return {
	"SalOrak/whaler",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		directories = {
			{ path = "/home/wote/git", alias = "Personal" },
			{ path = "/home/wote/work", alias = "Work" },
		},
		picker = "fzf_lua",
		file_explorer = "oil",
	},
	keys = {
		{ "<leader>fp", "<cmd>Whaler<cr>", desc = "Switch project" },
	},
	config = function(_, opts)
		local whaler = require("whaler")
		whaler.setup(opts)
		vim.api.nvim_create_autocmd("User", {
			pattern = "WhalerPreSwitch",
			callback = function()
				vim.cmd("%bd!")
				-- Your function logic goes here
			end,
		})
	end,
}
