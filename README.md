# nvim-ack

requires at least Neovim 0.12.0 and ripgrep.

## Features

* :Ack

## Install

```lua
vim.pack.add({ "https://github.com/wwcd/nvim-ack" })

require('nvim-ack').setup({})

vim.keymap.set('n', '<leader>gv',
  function()
    vim.api.nvim_feedkeys(':Ack ' .. vim.fn.expand('<cword>') .. ' ', 'n', false)
  end,
  { silent = true }
)

vim.keymap.set('v', 'gv',
  function()
    local selection = require('nvim-ack.utils').get_visual_selection()

    -- exit visule mode
    local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'n', false)

    vim.api.nvim_feedkeys(':Ack ' .. string.format("%q", selection), 'n', false)
  end,
  { silent = true }
)

vim.keymap.set('n', '<leader>ga',
  function() vim.api.nvim_feedkeys(':Ack ', 'n', false) end,
  { silent = true }
)

```

