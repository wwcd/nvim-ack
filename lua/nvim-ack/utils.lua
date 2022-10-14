local M = {}

M.get_visual_selection_range = function()
    local line_v, column_v = unpack(vim.fn.getpos("v"), 2, 3)
    local line_cur, column_cur = unpack(vim.fn.getcurpos(), 2, 3)
    -- backwards visual selection
    if line_v > line_cur or (line_v == line_cur and column_cur < column_v) then
        return line_cur, column_cur, line_v, column_v
    end
    return line_v, column_v, line_cur, column_cur
end

M.get_visual_selection = function(delimiter)
    local delimiter = delimiter or ' '
    local mode = vim.fn.mode()
    local line_start, column_start, line_end, column_end = M.get_visual_selection_range()
    local lines = vim.api.nvim_buf_get_lines(0, line_start - 1, line_end, false)

    local concat = {}
    local first_line = 1
    local last_line = line_end - (line_start - 1)
    if first_line == last_line then
        -- get difference in columns, inclusive
        column_end = column_end - column_start + 1
    end
    for row=first_line,last_line do
        local line = lines[row]
        if mode ~= 'V' then
            if row == first_line then
                line = line:sub(column_start)
            end
            if row == last_line then
                line = line:sub(1, column_end)
            end
        end
        table.insert(concat, vim.trim(line))
    end
    return table.concat(concat, delimiter)
end

return M
