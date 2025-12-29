return {
	"saghen/blink.cmp",
	dependencies = {
		"olimorris/codecompanion.nvim", -- For enabling code companion completion sources
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	},
	version = "1.*",
	opts = {
		keymap = { preset = "default" },
		appearance = { nerd_font_variant = "mono" },
		completion = { documentation = { auto_show = false } },
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "codecompanion" },
			per_filetype = {
				sql = { "dadbod", "buffer" },
			},
			providers = {
				dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
			},
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
		cmdline = {
			enabled = false, -- testing if this causes the freezing
		},
	},
	opts_extend = { "sources.default" },
}
