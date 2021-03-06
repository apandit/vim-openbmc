" Copyright 2016 Google Inc.
"
" Licensed under the Apache License, Version 2.0 (the "License");
" you may not use this file except in compliance with the License.
" You may obtain a copy of the License at
"
"     http://www.apache.org/licenses/LICENSE-2.0
"
" Unless required by applicable law or agreed to in writing, software
" distributed under the License is distributed on an "AS IS" BASIS,
" WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
" See the License for the specific language governing permissions and
" limitations under the License.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Some globals
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !exists("g:openbmc_get_git_root_cmd")
  let g:openbmc_get_git_root_cmd = "git rev-parse --show-toplevel | xargs echo -n"
endif

if !exists("g:openbmc_remote_path")
  let g:openbmc_remote_path = "github.com/openbmc"
endif

if !exists("g:openbmc_check_remote_cmd")
  let g:openbmc_check_remote_cmd = "git remote -v | grep -i '" . g:openbmc_remote_path . "'"
endif

if !exists("g:openbmc_crumb_name")
  let g:openbmc_crumb_name = ".openbmc.crumb"
endif

if !exists("g:openbmc_astyle_cmd")
  let s:script_path = fnamemodify(resolve(expand("<sfile>:p")), ":h")
  let g:openbmc_astyle_cmd = s:script_path . "/astyle.sh"
  unlet s:script_path
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configurations used for openbmc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! OpenbmcApplyAstyle()
  if (&ft=='c' || &ft=='cpp')
    " Set astyle as the format program
    let &formatprg=g:openbmc_astyle_cmd
    " Format entire file on write
    " Opt-in (requires specific disable)
    if !(exists("g:openbmc_disable_formatonsave") && g:openbmc_disable_formatonsave = 1)
      autocmd BufWritePre <buffer> :normal gggqG
    endif
  endif
endfunction

" Coding Style
autocmd User SignalOpenbmc :call OpenbmcApplyAstyle()

" Coding Style > General
autocmd User SignalOpenbmc :setlocal tabstop=8 expandtab shiftwidth=4 softtabstop=4

" Coding Style > General
autocmd User SignalOpenbmc :setlocal textwidth=80


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check for settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Determines if we're currently in an openbmc project
" Checks pwd for .openbmc.crumb and then checks if we're in a git repository.
" If repo, checks remotes for "github.com/openbmc" or .openbmc.crumb at root.
function! IsOpenbmcProject()
  if filereadable(g:openbmc_crumb_name)
    return 1
  endif

  " Get git info
  let l:git_root = system(g:openbmc_get_git_root_cmd)

  " No git repo (match ignore case)
  if l:git_root =~? "fatal"
    return 0
  endif

  " Found crumb in git root
  if filereadable(l:git_root . "/" . g:openbmc_crumb_name)
    return 2
  endif

  " Check for remotes
  let l:openbmc_remotes = system(g:openbmc_check_remote_cmd)
  if l:openbmc_remotes =~? g:openbmc_remote_path
    return 3
  endif

  return 0
endfunction

" Applies openbmc settings and adds buffer local variable
function! UseOpenbmcSettings()
  doautocmd User SignalOpenbmc
  if !exists("b:is_openbmc_buffer")
    let b:is_openbmc_buffer = 1
  endif
endfunction

function! CheckAndUseOpenbmcSettings()
  if IsOpenbmcProject() == 1
    call UseOpenbmcSettings()
  endif
endfunction


" Default behavior is to check whether openbmc settings should be applied
" Setting this global forces openbmc settings on all files
if exists("g:openbmc_make_settings_global")
  autocmd BufNewFile,BufRead * :call UseOpenbmcSettings()
else
  autocmd BufNewFile,BufRead * :call CheckAndUseOpenbmcSettings()
endif
