require('dashboard').setup {
  theme = 'doom',
  config = { 
    header = {
      '',
      '',
      '----------',
      '| Neovim |',
      '----------',
      '',
    },
    center = { 
      { icon = '  ', desc = 'Find file', action = 'Telescope find_files', shortcut = 'SPC f f' },
      { icon = '➕ ', desc = 'New file', action = 'enew', shortcut = 'SPC f n' },  
    },
  }
}
