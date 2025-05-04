return {
	"olimorris/codecompanion.nvim",
	opts = {
		display = {
			diff = {
				provider = "mini_diff",
			},
		},
	},
	keys = {
		{ "<leader>ct", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle CodeCompanion Chat" },
	},
	dependencies = {
		{ "nvim-lua/plenary.nvim", branch = "master" },
		"nvim-treesitter/nvim-treesitter",
	},
}
