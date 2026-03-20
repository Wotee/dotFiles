return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				theme = "catppuccin-nvim",
			},
			sections = {
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
				},
				-- Disable progress indicators
				lualine_y = {
					{
						function()
							local neotest = require("neotest")
							local adapter_ids = neotest.state.adapter_ids()
							local adapter_id = adapter_ids[1]
							local statuses = neotest.state.status_counts(adapter_id)
							if statuses.running > 0 then
								return ""
							end
							if statuses.failed > 0 then
								return ""
							else
								return ""
							end
						end,
					},
				},
			},
		})
	end,
}
