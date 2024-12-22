return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("fzf-lua").setup({})
		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fs", "<cmd>FzfLua live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Find buffers" })
		keymap.set("n", "<leader>fr", "<cmd>FzfLua lsp_references<cr>", { desc = "Find references" })
	end,
}
