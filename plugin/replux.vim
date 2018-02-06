function! s:RepluxStart()
    echom luaeval('require("core").start_from()')
endfunction

function! s:RepluxRestart()
    echom luaeval('require("core").restart_from()')
endfunction

function! s:RepluxKill()
    let l:from = expand('%:p')
    echom luaeval('require("core").kill_from()')
endfunction

function! s:RepluxKillByName(arg)
    echom luaeval('require("core").kill_by_name(_A.from)', {'from': a:arg})
endfunction

function! s:RepluxLs()
    for v in luaeval('require("core").ls()', {})
      echom v
    endfor
endfunction

function! s:RepluxCacheProjects()
    echom luaeval('require("core").create_cache()', {})
endfunction


command! -nargs=0 RepluxStart call s:RepluxStart()
command! -nargs=0 RepluxRestart call s:RepluxRestart()
command! -nargs=0 RepluxKill call s:RepluxKill()
command! -nargs=1 RepluxKillByName call s:RepluxKillByName(<f-args>)
command! -nargs=0 RepluxLs call s:RepluxLs()
command! -nargs=0 RepluxCacheProjects call s:RepluxCacheProjects()
