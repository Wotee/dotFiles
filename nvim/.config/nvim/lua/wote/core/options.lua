vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

vim.filetype.add({
	extension = {
		fs = "fsharp",
		fsx = "fsharp",
		fsi = "fsharp",
		bicep = "bicep",
		bru = "bru",
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

local function open_azure_workitem_in_adoboards()
	local word = vim.fn.expand("<cWORD>")
	local id = word:match("#(%d+)")

	if id then
		vim.cmd("Adoboards " .. id)
	else
		vim.notify("No workitem ID found under cursor", vim.log.levels.WARN)
	end
end

local function call_ado_pr_lsp_command(command, arguments)
	local bufnr = vim.api.nvim_get_current_buf()
	local client = vim.lsp.get_clients({ bufnr = bufnr, name = "ado-pr-lsp" })[1]

	if not client then
		vim.notify("ado-pr-lsp is not attached to this buffer", vim.log.levels.WARN)
		return
	end

	local command_request = { command = command }

	if arguments ~= nil then
		command_request.arguments = { arguments }
	end

	client:exec_cmd(command_request, { bufnr = bufnr })
end

local function request_ado_pr_lsp_command(command, arguments, callback)
	local bufnr = vim.api.nvim_get_current_buf()
	local client = vim.lsp.get_clients({ bufnr = bufnr, name = "ado-pr-lsp" })[1]

	if not client then
		vim.notify("ado-pr-lsp is not attached to this buffer", vim.log.levels.WARN)
		return
	end

	local params = { command = command }

	if arguments ~= nil then
		params.arguments = { arguments }
	end

	client:request("workspace/executeCommand", params, function(err, result)
		if err then
			local message = err.message or vim.inspect(err)
			vim.notify("ado-pr-lsp request failed: " .. message, vim.log.levels.ERROR)
			return
		end

		if callback then
			callback(result)
		end
	end, bufnr)
end

local function get_ado_thread_id_from_cursor()
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local current_line = cursor[1] - 1
	local diagnostics = vim.diagnostic.get(bufnr, { lnum = current_line })

	for _, diagnostic in ipairs(diagnostics) do
		if diagnostic.source == "ado-pr-lsp" then
			local lsp_data = diagnostic.user_data and diagnostic.user_data.lsp and diagnostic.user_data.lsp.data

			if type(lsp_data) == "table" then
				local thread_id = tonumber(lsp_data.threadId)

				if thread_id then
					return thread_id
				end
			end
		end
	end

	return nil
end

local function resolve_ado_thread()
	local thread_id = get_ado_thread_id_from_cursor()

	if not thread_id then
		vim.notify(
			"Put cursor on an ado-pr-lsp diagnostic line before calling :AdoResolveThread",
			vim.log.levels.WARN
		)
		return
	end

	call_ado_pr_lsp_command("ado-pr-lsp.resolveThread", {
		threadId = thread_id,
		documentPath = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()),
	})
end

local function create_ado_thread(message)
	local bufnr = vim.api.nvim_get_current_buf()
	local document_path = vim.api.nvim_buf_get_name(bufnr)

	if document_path == "" then
		vim.notify("Current buffer has no file path", vim.log.levels.WARN)
		return
	end

	if not message or vim.trim(message) == "" then
		vim.notify("Thread message cannot be empty", vim.log.levels.WARN)
		return
	end

	local line = vim.api.nvim_win_get_cursor(0)[1] - 1

	call_ado_pr_lsp_command("ado-pr-lsp.createThread", {
		filePath = document_path,
		line = line,
		message = message,
	})
end

local function prompt_create_ado_thread()
	vim.ui.input({ prompt = "ADO thread message: " }, function(input)
		if input == nil then
			return
		end

		create_ado_thread(input)
	end)
end

local function reply_ado_thread(message)
	local thread_id = get_ado_thread_id_from_cursor()

	if not thread_id then
		vim.notify(
			"Put cursor on an ado-pr-lsp diagnostic line before calling :AdoReplyThread",
			vim.log.levels.WARN
		)
		return
	end

	local document_path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())

	if document_path == "" then
		vim.notify("Current buffer has no file path", vim.log.levels.WARN)
		return
	end

	if not message or vim.trim(message) == "" then
		vim.notify("Reply message cannot be empty", vim.log.levels.WARN)
		return
	end

	call_ado_pr_lsp_command("ado-pr-lsp.replyThread", {
		threadId = thread_id,
		documentPath = document_path,
		message = message,
	})
end

local function prompt_reply_ado_thread()
	vim.ui.input({ prompt = "ADO reply message: " }, function(input)
		if input == nil then
			return
		end

		reply_ado_thread(input)
	end)
end

local function refresh_ado_comments()
	call_ado_pr_lsp_command("ado-pr-lsp.refreshComments")
end

local function open_ado_comment_files()
	request_ado_pr_lsp_command("ado-pr-lsp.listCommentFiles", nil, function(result)
		if type(result) ~= "table" or vim.tbl_isempty(result) then
			vim.notify("No ADO comment files found", vim.log.levels.INFO)
			return
		end

		local items = {}

		for _, path in ipairs(result) do
			if type(path) == "string" and path ~= "" then
				table.insert(items, {
					filename = path,
					lnum = 1,
					col = 1,
					text = "ADO comment thread",
				})
			end
		end

		if vim.tbl_isempty(items) then
			vim.notify("No ADO comment files found", vim.log.levels.INFO)
			return
		end

		vim.fn.setqflist({}, " ", { title = "ADO Comment Files", items = items })
		vim.cmd("cfirst")
		vim.cmd("copen")
	end)
end

vim.keymap.set("n", "gw", open_azure_workitem, { desc = "Go to Azure Workitem" })
vim.keymap.set("n", "aw", open_azure_workitem_in_adoboards, { desc = "Open workitem in Adoboards" })
vim.api.nvim_create_user_command("AdoResolveThread", resolve_ado_thread, {
	desc = "Resolve ADO thread at cursor diagnostic",
})
vim.api.nvim_create_user_command("AdoCreateThread", function(opts)
	if opts.args and opts.args ~= "" then
		create_ado_thread(opts.args)
	else
		prompt_create_ado_thread()
	end
end, {
	nargs = "?",
	desc = "Create ADO thread at cursor line",
})
vim.api.nvim_create_user_command("AdoReplyThread", function(opts)
	if opts.args and opts.args ~= "" then
		reply_ado_thread(opts.args)
	else
		prompt_reply_ado_thread()
	end
end, {
	nargs = "?",
	desc = "Reply to ADO thread at cursor diagnostic",
})
vim.api.nvim_create_user_command("AdoRefreshComments", refresh_ado_comments, {
	nargs = 0,
	desc = "Refresh ADO PR comments from server",
})
vim.api.nvim_create_user_command("AdoOpenCommentFiles", open_ado_comment_files, {
	nargs = 0,
	desc = "Open files that have ADO comments",
})
