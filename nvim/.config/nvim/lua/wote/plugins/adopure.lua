return {
	"Willem-J-an/adopure.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-lua/telescope.nvim",
	},
	keys = {
		{ "<leader>alc", "<cmd>Adopure load context<CR>", desc = "Load context" },
		{ "<leader>alt", "<cmd>Adopure load threads<CR>", desc = "Load threads" },
		{ "<leader>aoq", "<cmd>AdoPure open quickfix<CR>", desc = "Open quickfix" },
		{ "<leader>aot", "<cmd>AdoPure open thread_picker<CR>", desc = "Thread picker" },
		{ "<leader>aon", "<cmd>AdoPure open new_thread<CR>", desc = "Open new thread" },
		{ "<leader>aoe", "<cmd>AdoPure open existing_thread<CR>", desc = "Open existing thread" },
		{ "<leader>asc", "<cmd>AdoPure submit comment<CR>", desc = "Submit comment" },
		{ "<leader>asv", "<cmd>AdoPure submit vote<CR>", desc = "Submit vote" },
		{ "<leader>ast", "<cmd>AdoPure submit thread_status<CR>", desc = "Submit thread status" },
		{ "<leader>asd", "<cmd>AdoPure submit delete_comment<CR>", desc = "Submit delete comment" },
		{ "<leader>ase", "<cmd>AdoPure submit edit_comment<CR>", desc = "Submit edit comment" },
	},
}
