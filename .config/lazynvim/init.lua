-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- Enable filetype detection
vim.cmd('filetype plugin indent on')

-- Recognize EJS files as HTML
vim.api.nvim_exec([[
  autocmd BufRead,BufNewFile *.ejs set filetype=html
]], false)

