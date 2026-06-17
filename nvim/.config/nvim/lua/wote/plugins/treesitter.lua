-- return {}
return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				-- Enable treesitter highlighting and disable regex syntax
				pcall(vim.treesitter.start)
				-- dont use treesitter-based indentation on fsharp, where ionide provides vim.bo.indentexpr
				if vim.bo.filetype ~= "fsharp" then
					-- Enable treesitter-based indentation
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
	opts = {
		ensure_installed = {
			"json",
			"javascript",
			"typescript",
			"tsx",
			"yaml",
			"html",
			"css",
			"markdown",
			"markdown_inline",
			"bash",
			"lua",
			"vim",
			"dockerfile",
			"gitignore",
			"query",
			"vimdoc",
			"fsharp",
			"c_sharp",
			"latex",
		},
		highlight = {
			enable = true,
		},
		-- enable indentation
		indent = { enable = true },
	},
}
