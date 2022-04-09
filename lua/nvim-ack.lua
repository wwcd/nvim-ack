local M = {}

M.ack = function(...)
  local cmd = 'rg --vimgrep --no-heading ' .. table.concat({...}, ' ')
  local lines = {}
  local function onevent(_, d, e)
    if e == "stdout" or e == "stderr" then
      if d then
        vim.list_extend(lines, d)
      end
    end

    if e == "exit" then
      vim.fn.setqflist({}, " ", {
        title = cmd,
        lines = vim.tbl_filter(function(x) return x ~= "" end, lines),
        efm = '%f:%l:%c:%m'
      })
      vim.cmd('copen')
      if d ~= 0 then
        vim.api.nvim_echo({{'[ACK] FAILED', 'ErrorMsg'}}, false, {})
      end
    end
  end
  vim.fn.jobstart(cmd, {
    on_stderr = onevent,
    on_stdout = onevent,
    on_exit = onevent,
    stdout_buffered = true,
    stderr_buffered = true,
  })
end

M.setup = function(_)
  vim.cmd([[command! -nargs=? -range Ack call luaeval('require("nvim-ack").ack(unpack(_A))', [<f-args>])]])
end

return M
