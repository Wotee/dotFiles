return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Set header
		local neovim = {
			"                                                     ",
			"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			"                Let's fucking go!                    ",
		}
		-- Blue color for the carebear header
		vim.api.nvim_set_hl(0, "MyCustomHeader", { fg = "#61afef", bold = true })

		local carebear = {
			"                       Let's fucking go!",
			"                           /",
			"                          /",
			"         █▓▓█ ██▓▓▓██ █▓▓█",
			"        █▓▒▒▓█▓▓▓▓▓▓▓█▓▒▒▓█",
			"        █▓▒▒▓▓▓▓▓▓▓▓▓▓▓▒▒▓█",
			"         █▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█",
			"          █▓▓▓▓▓▓▓▓▓▓▓▓▓█",
			"          █▓▓█▓▓▓▓▓▓█▓▓▓█",
			"          █▓▓██▓▓▓▓▓██▓▓█",
			"         █▓▓▓▓▒▒█▓█▒▒▓▓▓▓█",
			"        █▓▓▒▒▓▒▒███▒▒▓▒▒▓▓█",
			"        █▓▓▒▒▓▒▒▒█▒▒▒▓▒▒▓▓█",
			"        █▓▓▓▓▓▓▒▒▒▒▒▓▓▓▓▓▓█",
			"         █▓▓▓▓▓▓███▓▓▓▓▓▓█",
			"          █▓▓▓▓▓▓▓▓▓▓▓▓▓█",
			"         █▓▓▓▓▒▒▒▒▒▒▒▓▓▓▓█",
			"        █▓▓▓▓▒▒▒▒▒▒▒▒▒▓▓▓▓█",
			"       █▓▓▓█▓▒▒▒▒▒▒▒▒▒▓█▓▓▓█",
			"     ██▓▓▓█▓▒▒▒██▒██▒▒▒▓█▓▓▓██",
			"    █▓▓▓▓█▓▒▒▒█▓▓█▓▓█▒▒▒▓█▓▓▓▓█",
			"   █▓██▓▓█▓▒▒▒█▒▒▓▒▒█▒▒▒▒▓█▓▓██▓█",
			"   █▓▓▓▓█▓▓▒▒▒█▓▒▒▒▓█▒▒▒▒▓▓█▓▓▓▓█",
			"    █▓▓▓█▓▓▒▒▒▒█▓▒▓█▒▒▒▒▒▓▓█▓▓▓█",
			"     ████▓▓▒▒▒▒▒█▓█▒▒▒▒▒▒▓▓████",
			"        █▓▓▓▒▒▒▒▒█▒▒▒▒▒▓▓▓█",
			"         █▓▓▓▒▒▒▒▒▒▒▒▒▓▓▓█",
			"         █▓▓▓▓▒▒▒▒▒▒▒▓▓▓▓█",
			"          █▓▓▓▓▓█▓█▓▓▓▓▓█",
			"           █▓▓▓▓▓█▓▓▓▓▓█",
			"        ████▓▓▓▓▓█▓▓▓▓▓████",
			"       █▓▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓█",
		}
		dashboard.section.header.val = carebear
		dashboard.section.header.opts.hl = "MyCustomHeader"

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
			dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
			dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
			dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
