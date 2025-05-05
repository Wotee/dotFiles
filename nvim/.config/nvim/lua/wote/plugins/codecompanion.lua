return {
	"olimorris/codecompanion.nvim",
	opts = {},
	keys = {
		{ "<leader>ct", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle CodeCompanion Chat" },
	},
	dependencies = {
		{ "nvim-lua/plenary.nvim", branch = "master" },
		"nvim-treesitter/nvim-treesitter",
	},
}
