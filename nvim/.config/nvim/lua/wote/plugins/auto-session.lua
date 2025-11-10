return {
	"rmagatti/auto-session",
	opts = {
		auto_restore_enabled = false,
		auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
	},
	keys = {
		{ "<leader>wr", "<cmd>AutoSession restore<CR>", desc = "Restore session for cwd" }, -- restore last workspace session for current directory
		{ "<leader>ws", "<cmd>AutoSession save<CR>", desc = "Save session for auto session root dir" }, -- save workspace session for current working directory
	},
}
