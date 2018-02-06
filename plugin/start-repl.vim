function! s:StartRepl()
    let l:from = expand('%:p')
    echom luaeval('require("core").start_from(_A.from)', {'from': l:from})
endfunction

function! s:RestartStartRepl()
    let l:from = expand('%:p')
    echom luaeval('require("core").restart_from(_A.from)', {'from': l:from})
endfunction

function! s:KillRepl()
    let l:from = expand('%:p')
    echom luaeval('require("core").kill_from(_A.from)', {'from': l:from})
endfunction

function! s:KillReplByName(arg)
    echom luaeval('require("core").kill_by_name(_A.from)', {'from': a:arg})
endfunction

function! s:LsRepl()
    for v in luaeval('require("core").ls()', {})
      echom v
    endfor
endfunction

function! s:CreateCache()
    echom luaeval('require("core").create_cache()', {})
endfunction


command! -nargs=0 StartRepl call s:StartRepl()
command! -nargs=0 RestartStartRepl call s:RestartStartRepl()
command! -nargs=0 KillRepl call s:KillRepl()
command! -nargs=1 KillReplByName call s:KillReplByName(<f-args>)
command! -nargs=0 LsRepl call s:LsRepl()
command! -nargs=0 CreateCache call s:CreateCache()
