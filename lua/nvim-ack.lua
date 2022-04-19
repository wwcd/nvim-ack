local M = {}

M.ack = function(nargs)
  local cmd = 'rg --vimgrep --no-heading ' .. table.concat(nargs.fargs, ' ')
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
  vim.api.nvim_create_user_command("Ack", M.ack, {nargs='?', bang=true})
end

return M
