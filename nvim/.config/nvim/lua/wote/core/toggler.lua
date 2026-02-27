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

local function resolve_buf(path, listed)
	local target = vim.fn.fnamemodify(path, ":p")
	local bufnr = M.file_buf or -1

	if not (vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_name(bufnr) == target) then
		bufnr = vim.fn.bufadd(target)
		vim.fn.bufload(bufnr)
		if vim.bo[bufnr].buftype ~= "" then
			vim.notify("toggler: target is not a file buffer", vim.log.levels.ERROR)
			return nil
		end
		M.file_buf = bufnr
	end

	vim.bo[bufnr].buflisted = listed
	return bufnr
end

local function find_tab_win(bufnr)
	local tab = vim.api.nvim_get_current_tabpage()
	return vim.iter(vim.fn.win_findbuf(bufnr)):find(function(win)
		return vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_tabpage(win) == tab
	end)
end

local function set_close_mapping(win)
	local buf = vim.api.nvim_win_get_buf(win)
	vim.keymap.set("n", "q", function()
		if not vim.api.nvim_win_is_valid(win) then
			return
		end
		vim.api.nvim_win_set_config(win, { hide = true })
		local fallback = M.file_prev_win
		if fallback and vim.api.nvim_win_is_valid(fallback) then
			vim.api.nvim_set_current_win(fallback)
		else
			local ok, alt = pcall(vim.fn.win_getid, vim.fn.winnr("#"))
			if ok and alt > 0 and vim.api.nvim_win_is_valid(alt) then
				vim.api.nvim_set_current_win(alt)
			end
		end
	end, { buffer = buf, silent = true })
end

local function ensure_float(bufnr, winopt)
	local win = M.file_win
	if not (win and vim.api.nvim_win_is_valid(win)) then
		win = find_tab_win(bufnr)
	end

	if not win or not vim.api.nvim_win_is_valid(win) then
		win = vim.api.nvim_open_win(bufnr, false, winopt)
		vim.api.nvim_win_set_var(win, "toggler_unlisted", true)
		set_close_mapping(win)
		M.file_win = win
	end

	unlist_win_buf(win)
	return win
end

local function jump_to(win)
	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_set_current_win(win)
	end
end

local function hide_win(win)
	if not (win and vim.api.nvim_win_is_valid(win)) then
		return
	end
	vim.api.nvim_win_set_config(win, { hide = true })
	local fallback = M.file_prev_win
	if fallback and vim.api.nvim_win_is_valid(fallback) then
		jump_to(fallback)
	else
		local ok, alt = pcall(vim.fn.win_getid, vim.fn.winnr("#"))
		if ok and alt > 0 and vim.api.nvim_win_is_valid(alt) then
			jump_to(alt)
		end
	end
end

local function show_win(win, bufnr, focus)
	vim.api.nvim_win_set_buf(win, bufnr)
	set_close_mapping(win)
	vim.api.nvim_win_set_config(win, { hide = false })

	if focus then
		local current = vim.api.nvim_get_current_win()
		if current ~= win then
			M.file_prev_win = current
			jump_to(win)
		end
	else
		M.file_prev_win = vim.api.nvim_get_current_win()
	end
end

M.togglefile = function(path, opts)
	opts = opts or {}
	local listed = opts.listed
	if listed == nil then
		listed = true
	end
	local focus = opts.focus
	if focus == nil then
		focus = true
	end

	if not path or path == "" then
		vim.notify("toggler: file path required", vim.log.levels.ERROR)
		return
	end

	local bufnr = resolve_buf(path, listed)
	if not bufnr then
		return
	end

	local winopt = vim.tbl_deep_extend("force", {}, M.config.winopt, opts.winopt or {})
	local win = ensure_float(bufnr, winopt)

	if vim.api.nvim_win_get_config(win).hide then
		show_win(win, bufnr, focus)
	else
		hide_win(win)
	end
end

return M
