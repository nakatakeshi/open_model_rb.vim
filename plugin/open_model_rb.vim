" --------------------------------------
"  open_model_rb.vim
"
"  open app/model/$current_word.rb 
"  if $current_word is camelcase, then convert underscore(snake case.)
"  if $current_word is pluralized word, then convert singularized word using
"  each regexp and if file not exists use activce_support method to convert.
"  and finally if app/model/$converted_word.rb is not exists , trying open
"  using ctags.
"
" " how settings.
" " vertical split and jump to app file in current window
" autocmd FileType ruby :noremap fg :call OpenAppModel('vne')<ENTER>
" " jump to app file in current window
" autocmd FileType ruby :noremap ff :call OpenAppModel('e')<ENTER>
" " split window horizontal, and ...
" autocmd FileType ruby :noremap fd :call OpenAppModel('sp')<ENTER>
" " open tab, and ...
" autocmd FileType ruby :noremap fd :call OpenAppModel('tabe')<ENTER>
" " for visual mode, use OpenAppModelV()
" autocmd FileType ruby :vnoremap fg :call OpenAppModelV('vne')<ENTER>
" ---------------------------------------

if exists('open_app_model')
  finish
endif
let open_app_model = 1
let s:save_cpo = &cpo
set cpo&vim

function! OpenAppModel(cmd)
  call s:OpenAppModel(a:cmd, expand("<cword>"))
endfunction

function! OpenAppModelV(cmd)
  call s:OpenAppModel(a:cmd, getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1])
endfunction


function! s:OpenAppModel(cmd, word)
    " convert to snale case if need
    " active_supportでやりたいがbundle exec するとおもいのでruby直
    let l:snaked_word = a:word
    if l:snaked_word =~ '[A-Z]'
        let l:snaked_word = system(printf(
            \'ruby -e "def to_snake_case(str);str.gsub(/::/, %s{/}).gsub(/([A-Z]+)([A-Z][a-z])/,%s{\1_\2}).gsub(/([a-z\d])([A-Z])/,%s{\1_\2}).tr(%s{-}, %s{_}).downcase;end; print to_snake_case(ARGV[0]);" %s',
            \'%q',
            \'%q',
            \'%q',
            \'%q',
            \'%q',
            \a:word)
        \)
    endif
    " open app/model/$model.rb if exists
    if filereadable('./app/models/' . l:snaked_word . '.rb')
        exe a:cmd . " " . './app/models/' . l:snaked_word . '.rb'
        return
    endif
    " 複数形 -> 単数の対応
    " active_supportの変換を使いたいけど重たいので
    " とりあえず、かんたんな変換
    let l:dict = {
        \'men': 'man',
    \}
    if has_key(l:dict, l:snaked_word) && filereadable('./app/models/' . l:dict[l:snaked_word] . '.rb')
        exe a:cmd . " " . './app/models/' . l:dict[l:snaked_word] . '.rb'
        return
    endif

    " stories -> story的な
    if l:snaked_word =~ 'ies$' && filereadable('./app/models/' . substitute(l:snaked_word,'ies$','y','g') . '.rb')
        exe a:cmd . " " . './app/models/' . substitute(l:snaked_word,'ies$','y','g') . '.rb'
        return
    endif
    " es終わりを取る
    if l:snaked_word =~ 'es$' && filereadable('./app/models/' . substitute(l:snaked_word,'es$','','g') . '.rb')

        exe a:cmd . " " . './app/models/' . substitute(l:snaked_word,'es$','','g') . '.rb'
        return
    endif
    " s終わりを取る
    if l:snaked_word =~ 's$' && filereadable('./app/models/' . substitute(l:snaked_word,'s$','','g') . '.rb')
        exe a:cmd . " " . './app/models/' . substitute(l:snaked_word,'s$','','g') . '.rb'
        return
    endif

    " だめならactive_supportで単数に変換
    let l:singularized_word = system(printf(
        \'bundle exec ruby -e "require ''active_support/inflector''; print ARGV[0].singularize" %s',
        \l:snaked_word)
    \)
    if filereadable('./app/models/' . l:singularized_word . '.rb')
        exe a:cmd . " " . './app/models/' . l:singularized_word . '.rb'
        return
    endif

    " それでもだめならctagsを使う
    " ただし別ウィンドウとかで開くやり方わからないから今のバッファ内で移動
    :execute "normal! \<C-]>"

    
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
