local M = {}

local theme_file = vim.fn.stdpath("config") .. "/lua/config/saved_theme"

local function get_theme() 
 local file = io.open(theme_file, "r")
	if file then
    local theme = file:read("*l")
    file:close()
    return theme
  end
end

function M.apply()
  scheme = get_theme()
  vim.cmd("colorscheme " .. scheme)
	vim.notify(scheme)
end

function M.toggle_theme()
  scheme = get_theme()
	local themes = { "catppuccin", "gruvbox", "pywal16"}
  

	local index = nil
  for i, v in ipairs(themes) do
    if v == scheme then
        index = i
        break
    end
  end
  
	if index then
	  local next_index = (index % #themes) + 1
    local next_scheme = themes[next_index]

    file = io.open(theme_file, "w")
	  file:write(next_scheme .. "\n")
	  file:close()
  end


	M.apply()
end

M.apply()

return M
