-- return {}
return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	-- version = false,
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
	keys = {
		{
			"<C-Space>",
			desc = "Increment Selection",
			mode = "n",
			function()
				require("nvim-treesitter.incremental_selection").init_selection()
			end,
		},
		{ "<bs>", desc = "Decrement Selection", mode = "x" },
	},
	init = function()
		require("nvim-treesitter").install({
			"json",
			"javascript",
			"typescript",
			"tsx",
			"yaml",
			"html",
			"css",
			"prisma",
			"markdown",
			"markdown_inline",
			"svelte",
			"graphql",
			"bash",
			"lua",
			"vim",
			"dockerfile",
			"gitignore",
			"query",
			"vimdoc",
			"c",
			"fsharp",
			"latex",
		})
	end,
	opts = {
		highlight = {
			enable = true,
		},
		-- enable indentation
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-Space>",
				node_incremental = "<C-Space>",
				scope_incremental = false,
				node_decremental = "<bs>",
			},
		},
	},
}
