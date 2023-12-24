local M = {}

-- defaults
local DEFAULT_CONFIG = {
  tag_table = {
    { name = 'TODO',  color = 'red'        },
    { name = 'FIXME', color = 'yellow'     },
    { name = 'DONE',  color = 'lightgreen' },
  },
  keybindings = {},
  fixed_width = false,
}

local DEFAULT_KEYBINDINGS = {
  add_tag           = [[<Leader>0]],
  remove_tag        = [[<Leader>9]],
  move_to_beginning = [[<Leader>8]],
}

local DEFAULT_STYLES = {
  color = 'red',
  style = 'bold',
  key   = 'default',
}

-- setup
function M.setup(config)
  M.config = config

  -- check the configuration and set defaults
  for key, def in pairs(DEFAULT_CONFIG) do
    if M.config[key] == nil then M.config[key] = def end
  end

  for key, def in pairs(DEFAULT_KEYBINDINGS) do
    if M.config.keybindings[key] == nil then M.config.keybindings[key] = def end
  end

  for num, tag in ipairs(M.config.tag_table) do
    if tag['name'] == nil then tag['name'] = [[NOTE]]..tostring(num) end
    for key, def in pairs(DEFAULT_STYLES) do
      if tag[key] == nil then tag[key] = def end
    end
  end

  -- determine the length of the largest tag (for fixed width tags)
  local tag_width = 0
  if M.config.fixed_width then
    for _, tag in ipairs(M.config.tag_table) do
      local len = string.len(tag.name)
      if len > tag_width then tag_width = len end
    end
    tag_width = tag_width + 2
  end

  -- keybindings to assign tags
  for num, tag in ipairs(M.config.tag_table) do
    local key = [[<Leader>]]..tostring(num)
    if tag.key ~= 'default' then
      key = tag.key
    end
    vim.keymap.set(
      {'n', 'v'},
      key,
      string.format([[^dt}dwI- %-]]..tag_width..[[s <Esc>^f}w]], '{'..tag.name..'}')
      )
  end

  -- additional keybindings
  vim.keymap.set(
    {'n', 'v'},
    M.config.keybindings.add_tag,
    [[^a {]]..M.config.tag_table[1].name..[[}<Esc>^f}w]]
    )
  vim.keymap.set(
    {'n', 'v'},
    M.config.keybindings.remove_tag,
    [[^f{dt}dw^w]]
    )
  vim.keymap.set(
    {'n', 'v'},
    M.config.keybindings.move_to_beginning,
    [[^f}w]]
    )

end

return M
