return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		{ "github/copilot.vim" },
		{ "nvim-lua/plenary.nvim", branch = "master" },
	},
	-- build = "make tiktoken",
	opts = {},
	keys = {
		{ "<leader>co", "<cmd>CopilotChatOpen<cr>", desc = "Open Copilot Chat" },
		{ "<leader>cx", "<cmd>CopilotChatClose<cr>", desc = "Close Copilot Chat" },
	},
}
