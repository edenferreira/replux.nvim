function! s:StartRepl()
    let l:from = expand('%:p')
    return luaeval('require("repl").startreplfrom(_A.from)', {'from': l:from})
endfunction

echom luaeval('require("repl").api.create_cache()', {})

command! -nargs=0 StartRepl call s:StartRepl()
