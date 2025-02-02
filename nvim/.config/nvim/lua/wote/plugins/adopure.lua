return {
	"Willem-J-an/adopure.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-lua/telescope.nvim",
	},
	config = function()
		vim.g.adopure = {}

		local function set_keymap(keymap, command)
			vim.keymap.set({ "n", "v" }, keymap, function()
				vim.cmd(":" .. command)
			end, { desc = command })
		end

		set_keymap("<leader>alc", "Adopure load context")
		set_keymap("<leader>alt", "Adopure load threads")
		set_keymap("<leader>aoq", "AdoPure open quickfix")
		set_keymap("<leader>aot", "AdoPure open thread_picker")
		set_keymap("<leader>aon", "AdoPure open new_thread")
		set_keymap("<leader>aoe", "AdoPure open existing_thread")
		set_keymap("<leader>asc", "AdoPure submit comment")
		set_keymap("<leader>asv", "AdoPure submit vote")
		set_keymap("<leader>ast", "AdoPure submit thread_status")
		set_keymap("<leader>asd", "AdoPure submit delete_comment")
		set_keymap("<leader>ase", "AdoPure submit edit_comment")
	end,
}
