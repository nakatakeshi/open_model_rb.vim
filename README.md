open_model_rb.vim
=================

open app/model/$word.rb from current word


Dependencies
============

this plugin use ruby and bundler


Installation
============


* locate this plugin

locate this autoload directory's file  to ~/.vim/autoload/
or if you use Neobundle.vim, write this line to your .vimrc
```vim
NeoBundle 'nakatakeshi/open_model_rb.vim'
```

* bundle install

cd /path/to/neo_bundle_s_root/open_model_rb.vim/
bundle install --path vendor/bundle

* add key mapping

add key mapping on your vimrc as you like.

```
" vertical split and jump to app file in current window
autocmd FileType ruby :noremap fg :call OpenAppModel('vne')<ENTER>
" jump to app file in current window
autocmd FileType ruby :noremap ff :call OpenAppModel('e')<ENTER>
" split window horizontal, and ...
autocmd FileType ruby :noremap fd :call OpenAppModel('sp')<ENTER>
" open tab, and ...
autocmd FileType ruby :noremap fd :call OpenAppModel('tabe')<ENTER>
" for visual mode, use OpenAppModelV()
autocmd FileType ruby :vnoremap fg :call OpenAppModelV('vne')<ENTER>
```
