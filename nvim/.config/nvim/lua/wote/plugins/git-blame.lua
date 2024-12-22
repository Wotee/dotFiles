return {
  "f-person/git-blame.nvim",
  event = "VeryLazy",
  opts = {
    enabled = true,
    message_template = "<author>, <date>: <summary>",
    date_format = "%d-%m-%Y",
    virtual_text_column = 1,
  },
}
