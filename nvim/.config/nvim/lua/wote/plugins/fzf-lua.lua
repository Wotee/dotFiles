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
		{ "<leader>fc", "<cmd>FzfLua resume<cr>", desc = "Resume work where you left off" },
	},
	---@module "fzf-lua"
	---@type fzf-lua.Config|{}
	---@diagnostic disable: missing-fields
	opts = function(_, opts)
		local fzf = require("fzf-lua")
		local actions = fzf.actions
		return {
			fzf_colors = true,
			fzf_opts = {
				["--no-scrollbar"] = true,
			},
			defaults = {
				formatter = "path.dirname_first",
			},
			files = {
				cwd_prompt = false,
				actions = {
					["alt-i"] = { actions.toggle_ignore },
					["alt-h"] = { actions.toggle_hidden },
				},
			},
			grep = {
				actions = {
					["alt-i"] = { actions.toggle_ignore },
					["alt-h"] = { actions.toggle_hidden },
				},
			},
		}
	end,
}
