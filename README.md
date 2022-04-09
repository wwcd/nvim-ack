# nvim-ack

requires at least Neovim 0.6.0 and ripgrep.

## Features

* :Ack

## Install

### packer.nvim

```lua
require('nvim-ack').setup({})
cmd [[map <leader>gv <cmd>lua vim.fn.feedkeys(':Ack ' .. vim.fn.expand('<cword>') .. ' ')<cr>]]
cmd [[map <leader>ga <cmd>lua vim.fn.feedkeys(':Ack ')<cr>]]
```

