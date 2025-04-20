return {
	"echasnovski/mini.nvim",
	version = false, -- Use main branch
	config = function()
		require("mini.ai").setup()
		require("mini.jump").setup()
		require("mini.surround").setup()
	end,
}
