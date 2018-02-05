function! s:StartRepl()
    let l:from = expand('%:p')
    return luaeval('require("repl").startreplfrom(_A.from)', {'from': l:from})
endfunction

command! -nargs=0 ShowStuff lua require('repl').showstuff()
command! -nargs=0 StartRepl call s:StartRepl()
