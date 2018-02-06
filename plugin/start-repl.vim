function! s:StartRepl()
    let l:from = expand('%:p')
    echom luaeval('require("core").start_from(_A.from)', {'from': l:from})
endfunction

function! s:CreateCache()
    echom luaeval('require("core").create_cache()', {})
endfunction


command! -nargs=0 StartRepl call s:StartRepl()
command! -nargs=0 CreateCache call s:CreateCache()
