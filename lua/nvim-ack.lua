local M = {}

M.ack = function(nargs)
  local cmd = 'rg --vimgrep --no-heading ' .. table.concat(nargs.fargs, ' ')
  local lines = {}
  local function onevent(_, data, event)
    if event == "stdout" or event == "stderr" then
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(lines, line)
          end
        end
      end
    end

    if event == "exit" then
      vim.fn.setqflist({}, " ", {
        title = cmd,
        lines = lines,
        efm = '%f:%l:%c:%m'
      })
      vim.cmd('copen')
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
  vim.api.nvim_create_user_command("Ack", M.ack, { nargs = '?', bang = true, range = true })
end

return M
