let s:cmds = [
\    'pick',
\    'fixup',
\    'reword',
\    'drop',
\    'squash',
\]

function PrintCmds(selected_cmd)
    for cmd in s:cmds
        if cmd != s:cmds[0] | echon ' | ' | endif
        if cmd == a:selected_cmd
            echohl WarningMsg | echon cmd | echohl None
        else
            echon cmd
        endif
    endfor
endfunction

function RebaseActionWrite(step)
    let line = getline(".")
    if (line == "")
        echo
        return
    endif
    let first_word = split(line)[0]
    let idx = index(s:cmds, first_word)
    if (idx >= 0)
        let selected_cmd = get(s:cmds, idx+a:step, s:cmds[0])
        if (first_word != selected_cmd)
            execute "normal! ^cw" . selected_cmd
            execute "normal! ^"
        endif
        if !a:step | :call PrintCmds(selected_cmd) | endif
    endif
endfunction

" command change shortcuts
nnoremap <Cr> :call RebaseActionWrite(1)<Cr>
nnoremap <S-Right> :call RebaseActionWrite(1)<Cr>
nnoremap <S-Left> :call RebaseActionWrite(-1)<Cr>

:autocmd CursorMoved * :call RebaseActionWrite(0)

" line move shortcuts
nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>
vnoremap <S-Up> :m '<-2<CR>gv=gv
vnoremap <S-Down> :m '>+1<CR>gv=gv
