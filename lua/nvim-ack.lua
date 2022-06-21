local M = {}

M.ack = function(nargs)
  local cmd = 'rg --vimgrep --no-heading ' .. table.concat(nargs.fargs, ' ')
  local lines = {}
  local function onevent(_, d, e)
    if e == "stdout" or e == "stderr" then
      if d then
        vim.list_extend(lines, vim.list_slice(d, 0, #d-1))
      end
    end

    if e == "exit" then
      vim.fn.setqflist({}, " ", {
        title = cmd,
        lines = lines,
        efm = '%f:%l:%c:%m'
      })
      vim.cmd('copen')
      -- if d ~= 0 then
      --   vim.api.nvim_echo({{'[ACK] FAILED', 'ErrorMsg'}}, false, {})
      -- end
    end
  end
  vim.fn.jobstart(cmd, {
    stdin = 'null',
    on_stderr = onevent,
    on_stdout = onevent,
    on_exit = onevent,
  })
end

M.setup = function(_)
  vim.api.nvim_create_user_command("Ack", M.ack, {nargs='?', bang=true})
end

return M
