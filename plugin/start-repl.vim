function! s:StartRepl()
    let l:from = expand('%:p')
    return luaeval('require("repl").startreplfrom(_A.from)', {'from': l:from})
endfunction

function! s:CreateCache()
    return luaeval('require("repl").api.create_cache()', {})
endfunction


command! -nargs=0 StartRepl call s:StartRepl()
command! -nargs=0 CreateCache call s:CreateCache()
