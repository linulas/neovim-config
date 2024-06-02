return {
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--no-ignore",
      "--hidden",
      "--follow",
      "--with-filename",
      "--line-number",
      "--column",
    },
    pattern = [[\b(KEYWORDS):]], -- ripgrep regex
  },
}
