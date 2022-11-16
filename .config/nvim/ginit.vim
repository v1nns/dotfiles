if exists('g:GuiLoaded')
  GuiTabline 0
  GuiPopupmenu 0
  GuiFont JetBrainsMono Nerd Font Mono:h9
  " :GuiFont FiraCode Nerd Font Mono:h10
  " :GuiFont UbuntuMono Nerd Font Mono:h11

  " Paste with middle mouse click
  set mouse=a
  vmap <LeftRelease> "*ygv

  " Paste with Ctrl + V
  inoremap <silent> <C-V> <C-R>+
  cnoremap <silent> <C-V> <C-R>+
endif
