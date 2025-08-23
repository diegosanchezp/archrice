-- map nvim fold keybindings to vscode
if vim.g.vscode then
  local vscode = require('vscode')
  vim.keymap.set('n', 'zM', function() vscode.call("editor.foldAll") end, { noremap = true, silent = true })
  vim.keymap.set('n', 'zR', function() vscode.call("editor.unfoldAll") end, { noremap = true, silent = true })
  vim.keymap.set('n', 'zc', function() vscode.call("editor.fold") end, { noremap = true, silent = true })
  vim.keymap.set('n', 'zC', function() vscode.call("editor.foldRecursively") end, { noremap = true, silent = true })
  vim.keymap.set('n', 'zo', function() vscode.call("editor.unfold") end, { noremap = true, silent = true })
  vim.keymap.set('n', 'zO', function() vscode.call("editor.unfoldRecursively") end, { noremap = true, silent = true })
  vim.keymap.set('n', 'za', function() vscode.call("editor.toggleFold") end, { noremap = true, silent = true })
end
