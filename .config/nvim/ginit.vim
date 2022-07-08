if exists('g:GuiLoaded')
  GuiTabline 0
  GuiPopupmenu 0
  :GuiFont FiraCode Nerd Font Mono:h10
  " :GuiFont UbuntuMono Nerd Font Mono:h11

  " set window title to cwd (works great when using gnome)
  set title
  augroup dirchange
      autocmd!
      autocmd DirChanged * let &titlestring=fnamemodify(v:event['cwd'], ':t') . ' - ' . v:event['cwd']
  augroup END

  " Paste with middle mouse click
  set mouse=a
  vmap <LeftRelease> "*ygv

  " Paste with Ctrl + V
  inoremap <silent> <C-V> <C-R>+
  cnoremap <silent> <C-V> <C-R>+
endif
