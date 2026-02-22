local M = {}

local unlist_group = vim.api.nvim_create_augroup("TogglerUnlisted", { clear = false })

local function unlist_win_buf(win)
	if not (win and vim.api.nvim_win_is_valid(win)) then
		return
	end
	local buf = vim.api.nvim_win_get_buf(win)
	if buf > 0 and vim.api.nvim_buf_is_valid(buf) then
		vim.bo[buf].buflisted = false
	end
end

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = unlist_group,
	callback = function()
		local win = vim.api.nvim_get_current_win()
		local ok, flag = pcall(vim.api.nvim_win_get_var, win, "toggler_unlisted")
		if ok and flag then
			unlist_win_buf(win)
		end
	end,
})

M.config = {
	cmd = { vim.o.shell },
	winopt = {
		relative = "editor",
		col = math.floor(vim.o.columns * 0.05),
		row = math.floor(vim.o.lines * 0.05),
		width = math.floor(vim.o.columns * 0.9),
		height = math.floor(vim.o.lines * 0.9),
		border = "rounded",
		style = "minimal",
		hide = true,
	},
}

M.togglefile = function(path, opts)
	opts = opts or {}
	local listed = opts.listed

	if listed == nil then
		listed = true
	end

	if not path or path == "" then
		vim.notify("toggler: file path required", vim.log.levels.ERROR)
		return
	end

	local target = vim.fn.fnamemodify(path, ":p")
	local bufnr = M.file_buf or -1

	if not (vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_name(bufnr) == target) then
		bufnr = vim.fn.bufadd(target)
		vim.fn.bufload(bufnr)
		if vim.bo[bufnr].buftype ~= "" then
			vim.notify("toggler: target is not a file buffer", vim.log.levels.ERROR)
			return
		end
		M.file_buf = bufnr
	end

	vim.bo[bufnr].buflisted = listed

	local win = M.file_win

	if not (win and vim.api.nvim_win_is_valid(win)) then
		win = vim.iter(vim.fn.win_findbuf(bufnr)):find(function(b_wid)
			return vim.iter(vim.api.nvim_tabpage_list_wins(0)):any(function(t_wid)
				return b_wid == t_wid
			end)
		end)
	end

	if not win or not vim.api.nvim_win_is_valid(win) then
		win = vim.api.nvim_open_win(bufnr, false, M.config.winopt)
		vim.api.nvim_win_set_var(win, "toggler_unlisted", true)
		M.file_win = win
	end

	unlist_win_buf(win)

	if vim.api.nvim_win_get_config(win).hide then
		vim.api.nvim_win_set_buf(win, bufnr)
		vim.api.nvim_win_set_config(win, { hide = false })
		M.file_prev_win = vim.api.nvim_get_current_win()
		vim.api.nvim_set_current_win(win)
	else
		vim.api.nvim_win_set_config(win, { hide = true })
		local fallback = M.file_prev_win
		if fallback and vim.api.nvim_win_is_valid(fallback) then
			vim.api.nvim_set_current_win(fallback)
		else
			vim.api.nvim_set_current_win(vim.fn.win_getid(vim.fn.winnr("#")))
		end
	end
end

return M
