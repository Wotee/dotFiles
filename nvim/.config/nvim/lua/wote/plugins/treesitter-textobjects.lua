return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	init = function()
		vim.g.no_plugin_maps = true
	end,
	config = function()
		local select = require("nvim-treesitter-textobjects.select")

		vim.keymap.set({ "x", "o" }, "af", function()
			select.select_textobject("@function.outer", "textobjects")
		end, { desc = "Treesitter around function" })
		vim.keymap.set({ "x", "o" }, "if", function()
			select.select_textobject("@function.inner", "textobjects")
		end, { desc = "Treesitter inside function" })
	end,
}
