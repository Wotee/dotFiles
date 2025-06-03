return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"olimorris/codecompanion.nvim", -- For enabling code companion completion sources
	},
	version = "1.*",
	opts = {
		keymap = { preset = "default" },
		appearance = { nerd_font_variant = "mono" },
		completion = { documentation = { auto_show = false } },
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "codecompanion" },
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
		cmdline = {
			enabled = false, -- testing if this causes the freezing
		},
	},
	opts_extend = { "sources.default" },
}
