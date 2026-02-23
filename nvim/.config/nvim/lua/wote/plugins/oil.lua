return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		default_file_explorer = true,
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		view_options = {
			show_hidden = true,
			natural_order = true,
			is_always_hidden = function(name, _)
				return name == ".." or name == ".git"
			end,
		},
		win_options = {
			wrap = true,
		},
	},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	keys = {
		{ "<leader>ee", "<cmd>Oil . --float<CR>", desc = "Toggle file explorer" },
		{
			"<leader>ef",
			function()
				require("oil").open_float(vim.fn.expand("%:p:h"))
			end,
			desc = "Oil in buffer folder",
		},
	},
}
