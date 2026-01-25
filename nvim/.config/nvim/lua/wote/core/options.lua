vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

vim.filetype.add({
	extension = {
		fs = "fsharp",
		fsx = "fsharp",
		fsi = "fsharp",
		bicep = "bicep",
	},
})

opt.title = true
vim.opt.titlestring = "nvim [%{fnamemodify(getcwd(), ':t')}] %t"

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

vim.api.nvim_create_autocmd("FileType", {
	pattern = "fsharp",
	callback = function()
		vim.bo.commentstring = "// %s"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "fsharp",
	command = "compiler dotnet",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "bicep",
	callback = function()
		vim.bo.commentstring = "//%s"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "fsharp_project",
	callback = function()
		vim.bo.commentstring = "<!-- %s -->"
	end,
})

vim.g.dotnet_errors_only = true
vim.g.dotnet_show_project_file = false

vim.keymap.set("t", "zz", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

local function open_azure_workitem()
	local word = vim.fn.expand("<cWORD>")
	local id = word:match("#(%d+)")

	if id then
		local url = "https://dev.azure.com/waypoint-azure/HealthHub/_workitems/edit/" .. id
		vim.ui.open(url)
	else
		vim.notify("No workitem ID found under cursor", vim.log.levels.WARN)
	end
end

vim.keymap.set("n", "gw", open_azure_workitem, { desc = "Go to Azure Workitem" })
