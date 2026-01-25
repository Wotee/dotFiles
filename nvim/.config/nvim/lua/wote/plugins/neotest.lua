return {
	"nvim-neotest/neotest",
	dependencies = {
		{ "nsidorenco/neotest-vstest" },
	},
	keys = {
		{ "<leader>rt", "<cmd>lua require('neotest').run.run()<CR>", desc = "Run test under cursor" },
		{
			"<leader>rf",
			"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
			desc = "Run all tests in the file",
		},
		{ "<leader>rT", "<cmd>lua require('neotest').run.run('.')<CR>", desc = "Run tests in working directory" },

		{ "<leader>ro", "<cmd>lua require('neotest').output.open()<CR>", desc = "Open test output" },
		{
			"<leader>rO",
			"<cmd>lua require('neotest').output.open({enter = true})<CR>",
			desc = "Open test output, focus",
		},
		{ "<leader>ri", "<cmd>lua require('neotest').summary.toggle()<CR>", desc = "Toggle test summary" },
	},
	opts = {
		adapters = {
			require("neotest-vstest"),
		},
		watch = {
			symbol_queries = {
				-- Empty queries to avoid parser node mismatches; watcher will rerun on changed file only
				fsharp = "",
				forth = "",
			},
		},
		quickfix = {
			open = function()
				require("trouble").open({ mode = "quickfix", focus = false })
			end,
		},
	},
}
