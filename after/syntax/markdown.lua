vim.cmd([[syntax case match]])
for _, tag in ipairs(require('notator').config.tag_table) do
  vim.cmd([[highlight]]
  .. [[ hi_]]      .. tag.name
  .. [[ cterm=]]   .. tag.style
  .. [[ ctermfg=]] .. tag.color
  .. [[ guifg=]]   .. tag.color
  )
  vim.cmd([[syntax keyword]]
  .. [[ hi_]] .. tag.name
  .. [[ ]]    .. tag.name
  )
end
vim.cmd([[syntax case ignore]])
