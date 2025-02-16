return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Fuzzy find files in cwd" },
		{ "<leader>fs", "<cmd>FzfLua live_grep<cr>", desc = "Find string in cwd" },
		{ "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "Find word under cursor" },
		{ "<leader>fW", "<cmd>FzfLua grep_cWORD<cr>", desc = "Find WORD under cursor" },
		{ "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Find buffers" },
		{ "<leader>fr", "<cmd>FzfLua lsp_references<cr>", desc = "Find references" },
		{ "<leader>fp", "<cmd>FzfLua resume<cr>", desc = "Resume work where you left off" },
	},
}
