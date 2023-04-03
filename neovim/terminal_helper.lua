local M = {}

-- Store the last accessed terminal buffer
local last_terminal_bufnr = nil

-- Function to track the last accessed terminal buffer
function M.track_last_terminal_bufnr()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].buftype == 'terminal' then
    last_terminal_bufnr = bufnr
  end
end

-- Function to run a command in the last accessed terminal buffer
function M.run_command_in_last_terminal(command)
  if last_terminal_bufnr == nil then
    print('No terminal buffer found')
    return
  end

  local current_bufnr = vim.api.nvim_get_current_buf()

  -- Do a horizontal split
  vim.cmd(':split')

  -- Switch to the last accessed terminal buffer
  vim.api.nvim_set_current_buf(last_terminal_bufnr)
  vim.cmd(':startinsert')

  -- Run the command
  vim.api.nvim_input(command .. '\n')
end

return M
