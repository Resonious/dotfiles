execute pathogen#infect()
set t_Co=256
syntax on
filetype plugin indent on

" Tabs are 2 spaces
set expandtab
set shiftwidth=2
set softtabstop=2

" Except in Rust and C files where they are 4 spaces!
autocmd FileType rs setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType c setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType cpp setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType pug setlocal shiftwidth=4 tabstop=4 softtabstop=4

" gdscript uses 4-space tabs
autocmd FileType gd setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4

colorscheme phoenix

function! s:randnum(max) abort
  return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % a:max
endfunction

autocmd! BufWritePost * Neomake

if getcwd() =~ '-crm' || bufname("%") =~ 'Vagrantfile'
  autocmd VimEnter * PhoenixPurple
elseif getcwd() =~ 'softwear-production' || getcwd() =~ 'rails' || getcwd() =~ 'bundler' || getcwd() =~ 'rvm'
  autocmd VimEnter * PhoenixRed
elseif getcwd() =~ 'softwear-mockbot' || getcwd() =~ 'serp'
  autocmd VimEnter * PhoenixYellow
elseif getcwd() =~ 'spree' || getcwd() =~ 'crute' || getcwd() =~ 'Retail-Core'
  autocmd VimEnter * PhoenixBlue
elseif getcwd() =~ 'www' || getcwd() =~ 'former' || getcwd() =~ 'softwear-fba' || getcwd() =~ 'amazon'
  autocmd VimEnter * PhoenixOrange
elseif getcwd() =~ 'hub' || getcwd() =~ 'sw-config'
  autocmd VimEnter * PhoenixGray
elseif getcwd() =~ 'softwear-lib' || getcwd() =~ 'aatc' || getcwd() =~ 'a/r_\?u'
  autocmd VimEnter * PhoenixGreen
elseif getcwd() =~ 'retail'
  autocmd VimEnter * PhoenixBlue
else
  let s:num = s:randnum(5)
  if s:num == 0
    autocmd VimEnter * PhoenixPurple
  elseif s:num == 1
    autocmd VimEnter * PhoenixRed
  elseif s:num == 2
    autocmd VimEnter * PhoenixYellow
  elseif s:num == 3
    autocmd VimEnter * PhoenixOrange
  elseif s:num == 4
    autocmd VimEnter * PhoenixGreen
  elseif s:num == 5
    autocmd VimEnter * PhoenixBlue
  endif
endif

set background=dark
" let g:airline_theme='badwolf'
let g:airline_powerline_fonts = 1

tnoremap <Esc> <C-\><C-n> " Esc to exit terminal mode
nnoremap <A-r> i<Up><CR><C-\><C-n> " Alt+r to rerun last terminal command

" Tab for autocomplete
" :inoremap <Tab> <C-N>

:noremap <C-S> :w<cr>

" Idiotproofing
:command W w
:command Q q
:command Qa qa
:command Wqa wqa
" Typing NERDTree is kind of annoying
:command NT NERDTree
" Because folks don't seem to care about trailing whitespace
:command Trailing %s/\s\+$//g

" Latex stuff
let g:tex_flavor = 'latex'

" FZF!
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
noremap <silent> <C-P> :FZF<CR>

" Use ripgrep for vim
if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" No search result highlighting
set nohlsearch

" Highlight byebugs so I don't leave them around
autocmd BufNewFile,BufRead * syntax match myByebug /\<byebug/
autocmd BufNewFile,BufRead * highlight myByebug ctermbg=red ctermfg=yellow
autocmd BufNewFile,BufRead * syntax match myPry /\<binding\.pry/
autocmd BufNewFile,BufRead * highlight myPry ctermbg=red ctermfg=yellow

" Neoterm stuff:
nnoremap <C-l> :TREPLSendLine<cr>
vnoremap <C-l> :TREPLSendSelection<cr>

let g:neomake_cpp_enabled_makers = ['gcc']
let g:neomake_cpp_clang_maker = {
   \ 'exe': 'g++++',
   \ 'args': ['-Wall', '-Wextra', '-Weverything', '-pedantic', '-Wno-sign-conversion'],
   \ }
