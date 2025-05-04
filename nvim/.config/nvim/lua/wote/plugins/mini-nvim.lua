return {
	"echasnovski/mini.nvim",
	version = false, -- Use main branch
	config = function()
		require("mini.ai").setup()
		require("mini.jump").setup({
			delay = {
				highlight = 10000000,
			},
		})
		require("mini.surround").setup()
		require("mini.diff").setup()
	end,
}
