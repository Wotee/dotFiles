return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		spec = {
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>c", group = "Code" },
			{ "<leader>b", group = "Buffer" },
			{ "<leader>r", group = "Run" },
			{ "<leader>z", group = "Debug" },
			{ "<leader>x", group = "Diagnostics" },
			{ "gs", group = "Surround" },
		},
	},
}
